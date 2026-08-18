// lib/pages/ai_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/controllers/ai.controller.dart';
import 'package:rexone_mobile/design/design.dart';
import 'package:rexone_mobile/models/models.dart';

/// AI chat page. Pure [GetView] \u2014 all state and UI controllers live in
/// [AiController]. No StatefulWidget, no initState, no setState.
class AiPage extends GetView<AiController> {
  const AiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppPage(
        title: controller.currentRoomTitle.value,
        showBackButton: true,
        padding: EdgeInsets.zero,
        actions: [
          IconButton(
            icon: Icon(Design.icons.forum),
            onPressed: () => _showRoomsBottomSheet(context),
            tooltip: 'Rooms',
          ),
          IconButton(
            icon: Icon(Design.icons.deleteSweep),
            onPressed: () async {
              final ok = await AppDialog.confirm(
                context: context,
                title: Constants.locale.clearHistoryTitle.tr,
                message: Constants.locale.clearHistoryConfirmMsg.tr,
                confirmLabel: Constants.locale.confirmClear.tr,
              );
              if (ok) controller.clearHistory();
            },
            tooltip: 'Clear Chat',
          ),
        ],
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.all(Design.spacing.lg),
                  itemCount:
                      controller.messages.length +
                      (controller.isProcessing.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.messages.length &&
                        controller.isProcessing.value) {
                      return _buildThinkingBubble(context);
                    }
                    return _buildMessageBubble(
                      context,
                      controller.messages[index],
                    );
                  },
                ),
              ),
            ),
            _buildInputBar(context),
          ],
        ),
      ),
    );
  }

  void _showRoomsBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(Design.spacing.lg),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Design.spacing.radiusLarge),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Chat Rooms', style: context.typo.headline3),
                  AppButton(
                    type: ButtonType.text,
                    text: '+ New Chat',
                    onPressed: () {
                      Get.back();
                      controller.createNewRoom();
                    },
                  ),
                ],
              ),
              SizedBox(height: Design.spacing.md),
              Flexible(
                child: Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.rooms.length,
                    itemBuilder: (context, index) {
                      final room = controller.rooms[index];
                      final isSelected =
                          controller.currentRoomId.value == room.id;

                      return AppListTile(
                        leading: Icon(
                          Design.icons.chat,
                          color: isSelected
                              ? context.colors.primary
                              : context.colors.textSecondary,
                        ),
                        title: Text(
                          room.title,
                          style: context.typo.bodyLarge.copyWith(
                            color: isSelected
                                ? context.colors.primary
                                : context.colors.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          '${room.messageCount} messages',
                          style: context.typo.caption,
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Design.icons.delete,
                            size: 20,
                            color: context.colors.error,
                          ),
                          onPressed: () async {
                            final ok = await AppDialog.confirm(
                              context: context,
                              title: Constants.locale.deleteRoomTitle.tr,
                              message: Constants.locale.deleteRoomConfirmMsg.tr,
                              confirmLabel: Constants.locale.confirmDelete.tr,
                            );
                            if (ok) {
                              controller.deleteRoom(room.id);
                            }
                          },
                        ),
                        onTap: () {
                          Get.back();
                          controller.selectRoom(room);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildMessageBubble(BuildContext context, AiMessageModel msg) {
    final isUser = msg.isUser;
    final colors = context.colors;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: Design.spacing.md),
        padding: EdgeInsets.symmetric(
          horizontal: Design.spacing.lg,
          vertical: Design.spacing.md,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: isUser ? colors.primary : colors.surface,
          borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
          border: isUser ? null : Border.all(color: colors.border),
          boxShadow: Design.colors.shadows.sm,
        ),
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              msg.content,
              style: context.typo.bodyMedium.copyWith(
                color: isUser ? Colors.white : colors.textPrimary,
              ),
            ),
            if (msg.isFailed) ...[
              SizedBox(height: Design.spacing.xs),
              Text(
                'Failed to generate response',
                style: context.typo.caption.copyWith(color: colors.error),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildThinkingBubble(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: Design.spacing.md),
        padding: EdgeInsets.symmetric(
          horizontal: Design.spacing.lg,
          vertical: Design.spacing.md,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'AI is thinking',
              style: context.typo.bodyMedium.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(width: Design.spacing.sm),
            const AppLoading(type: LoadingType.dots, size: LoadingSize.small),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Design.spacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.divider)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.textController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => controller.handleSend(),
                decoration: Design.styles.input(hint: 'Type your message...'),
              ),
            ),
            SizedBox(width: Design.spacing.sm),
            IconButton(
              icon: Icon(Design.icons.send, color: context.colors.primary),
              onPressed: controller.handleSend,
            ),
          ],
        ),
      ),
    );
  }
}
