/// Centralized JSON keys for API envelope, pagination, and JSONAPI structure.
/// These are shared across all modules and used in both requests and responses.
class JsonKeys {
  const JsonKeys._();

  // ===== API Envelope =====
  static const status = 'status';
  static const code = 'code';
  static const data = 'data';
  static const success = 'success';
  static const error = 'error';
  static const message = 'message';
  static const meta = 'meta';
  static const pagination = 'pagination';

  // ===== Pagination Meta =====
  static const page = 'page';
  static const currentPage = 'current_page';
  static const totalPages = 'total_pages';
  static const totalCount = 'total_count';
  static const limit = 'limit';
  static const nextPage = 'next_page';
  static const prevPage = 'prev_page';

  // ===== JSONAPI Structure =====
  static const id = 'id';
  static const attributes = 'attributes';
}

/// Request/response keys for auth endpoints.
class AuthKeys {
  const AuthKeys._();

  static const email = 'email';
  static const user = 'user';
  static const token = 'token';
  static const signinKey = 'signin_key';
  static const password = 'password';
  static const passwordConfirmation = 'password_confirmation';
  static const confirmationCode = 'confirmation_code';
  static const challengeToken = 'challenge_token';
  static const username = 'username';
  static const name = 'name';
}

/// Request/response keys for AI endpoints.
class AiKeys {
  const AiKeys._();

  static const messages = 'messages';
  static const processing = 'processing';
  static const roomTitle = 'room_title';
  static const roomId = 'room_id';
  static const title = 'title';
  static const room = 'room';
  static const role = 'role';
}

/// Request/response keys for payment endpoints.
class PaymentKeys {
  const PaymentKeys._();

  static const checkoutUrl = 'checkout_url';
  static const productId = 'product_id';
  static const successUrl = 'success_url';
  static const cancelUrl = 'cancel_url';
}

/// Keys for WebSocket event messages.
class SocketKeys {
  const SocketKeys._();

  static const type = 'type';
  static const message = 'message';
}
