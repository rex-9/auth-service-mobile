// lib/controllers/auth_controller.dart (updated methods)
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final AuthService _auth = Get.find();
  final StorageService _storage = StorageService();

  // Observables
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var authToken = ''.obs;
  var currentUser = Rxn<UserModel>();

  // Form data
  var email = ''.obs;
  var passcode = ''.obs;
  var confirmPasscode = ''.obs;
  var fullName = ''.obs;
  var username = ''.obs;

  // init loading state while checking auth status
  var isCheckingAuth = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    isCheckingAuth.value = true;
    final token = _storage.getToken();
    if (token != null && token.isNotEmpty) {
      authToken.value = token;
      isLoggedIn.value = true;
      await getCurrentUser();
    } else {
      isLoggedIn.value = false;
    }
    isCheckingAuth.value = false;
  }

  // Step 1: Check if user exists
  Future<PeekedUserStatus> peekUser(String emailAddress) async {
    try {
      final response = await _auth.peekUser(emailAddress);

      if (!response.success) {
        // API call failed
        return PeekedUserStatus.error;
      }
      // API succeeded, check if user exists
      return response.data == true
          ? PeekedUserStatus.exists
          : PeekedUserStatus.notExists;
    } catch (e) {
      // Exception occurred
      return PeekedUserStatus.error;
    }
  }

  // Step 2a: Sign in with email and password (existing user with password)
  Future<void> signIn() async {
    isLoading.value = true;

    try {
      final response = await _auth.signIn(email.value, passcode.value);

      if (response.success && response.data != null) {
        final token = response.data!['token'];
        authToken.value = token;
        _storage.setToken(token);
        _storage.setUserEmail(email.value);
        isLoggedIn.value = true;
        AppRoutes.toHome();
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Sign in failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Step 2b: Send confirmation code (for new user registration)
  Future<void> sendConfirmationCode() async {
    isLoading.value = true;

    try {
      final response = await _auth.sendConfirmationCode(email.value);

      if (response.success) {
        AppRoutes.toVerifyEmail(arguments: {'email': email.value});
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to send verification code');
    } finally {
      isLoading.value = false;
    }
  }

  // Step 3: Verify code (for new user)
  Future<void> verifyCode(String code) async {
    isLoading.value = true;

    try {
      final response = await _auth.confirmCode(email.value, code);

      if (response.success && response.data != null) {
        // User is confirmed and signed in
        final token = response.data!['token'];
        authToken.value = token;
        _storage.setToken(token);
        _storage.setUserEmail(email.value);
        isLoggedIn.value = true;
        AppRoutes.toHome();
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Verification failed');
    } finally {
      isLoading.value = false;
    }
  }

  // Alternative: Register new user with full details
  Future<void> signUp() async {
    isLoading.value = true;

    try {
      final response = await _auth.signUp(
        username: username.value,
        name: fullName.value,
        email: email.value,
        password: passcode.value,
        passwordConfirmation: confirmPasscode.value,
      );

      if (response.success) {
        Get.snackbar('Success', 'Verification code sent to ${email.value}');
        AppRoutes.toVerifyEmail(arguments: {'email': email.value});
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Registration failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Google Sign In
  Future<void> signInWithGoogle() async {
    isLoading.value = true;

    try {
      final signIn = GoogleSignIn.instance;

      // Step 1: authenticate user
      final user = await signIn.authenticate();

      // Step 2: request authorization (scopes)
      const scopes = <String>['email'];
      final auth = await user.authorizationClient.authorizeScopes(scopes);
      final accessToken = auth.accessToken;

      final response = await _auth.signInWithGoogle(accessToken);

      if (response.success && response.data != null) {
        final token = response.data!['token'];
        authToken.value = token;
        _storage.setToken(token);
        _storage.setUserEmail(user.email);

        isLoggedIn.value = true;
        AppRoutes.toHome();
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Google sign in failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Get current user
  Future<void> getCurrentUser() async {
    try {
      final response = await _auth.getCurrentUser();
      if (response.success && response.data != null) {
        currentUser.value = UserModel.fromJson(response.data!);
      }
    } catch (e) {
      print('Error getting user: $e');
    }
  }

  // Forgot password
  Future<void> forgotPassword(String emailAddress) async {
    isLoading.value = true;

    try {
      final response = await _auth.forgotPassword(emailAddress);
      if (response.success) {
        Get.snackbar('Success', response.message);
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to send reset instructions');
    } finally {
      isLoading.value = false;
    }
  }

  // Sign out
  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // Ignore network error on sign out
    }

    _storage.clearAll();
    authToken.value = '';
    isLoggedIn.value = false;
    email.value = '';
    passcode.value = '';
    confirmPasscode.value = '';
    fullName.value = '';
    username.value = '';
    AppRoutes.toAuth();
  }
}
