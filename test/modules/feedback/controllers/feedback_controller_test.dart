// test/modules/feedback/controllers/feedback_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/models/models.dart';
import 'package:rexone_mobile/modules/feedback/controllers/feedback.controller.dart';
import 'package:rexone_mobile/modules/feedback/services/feedback.service.dart';
import '../../../mocks/test_services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeFeedbackService fakeService;
  late FeedbackController controller;

  setUp(() {
    Get.testMode = true;
    fakeService = FakeFeedbackService();
    Get.put<FeedbackService>(fakeService);
    controller = Get.put(FeedbackController());
  });

  tearDown(() {
    Get.reset();
  });

  group('FeedbackController', () {
    test('initializes with default rating of 8 and isSubmitting false', () {
      expect(controller.rating.value, equals(8));
      expect(controller.isSubmitting.value, isFalse);
      expect(controller.textController.text, isEmpty);
    });

    test('setRating updates rating within 1..10 and ignores out-of-bounds values', () {
      controller.setRating(5);
      expect(controller.rating.value, equals(5));

      controller.setRating(10);
      expect(controller.rating.value, equals(10));

      controller.setRating(1);
      expect(controller.rating.value, equals(1));

      // Out of bounds - should remain 1
      controller.setRating(0);
      expect(controller.rating.value, equals(1));

      controller.setRating(11);
      expect(controller.rating.value, equals(1));
    });

    test('submitFeedback validates empty text and aborts submission', () async {
      controller.textController.text = '   ';
      final result = await controller.submitFeedback();

      expect(result, isFalse);
      expect(fakeService.lastSubmittedData, isNull);
    });

    test('submitFeedback submits payload and clears form on success', () async {
      controller.textController.text = 'Great app! Love the UI.';
      controller.setRating(9);

      final result = await controller.submitFeedback();

      expect(result, isTrue);
      expect(fakeService.lastSubmittedData, isNotNull);
      expect(fakeService.lastSubmittedData![FeedbackKeys.content], equals('Great app! Love the UI.'));
      expect(fakeService.lastSubmittedData![FeedbackKeys.rating], equals(9));
      expect(controller.textController.text, isEmpty);
      expect(controller.rating.value, equals(8));
    });

    test('submitFeedback returns false when service returns failure', () async {
      fakeService.submitResponse = ApiResponse.error(
        message: 'Server error',
        statusCode: 500,
      );

      controller.textController.text = 'Bug report';
      final result = await controller.submitFeedback();

      expect(result, isFalse);
      expect(controller.isSubmitting.value, isFalse);
    });
  });
}
