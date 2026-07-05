import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../atoms/atoms.dart';

/// Mirrors web `src/design/molecules/PasscodeBoxesInput.tsx` — six digit
/// boxes with a dash after the third digit.
///
/// Implemented as one invisible [TextField] driving six painted boxes, which
/// gives reliable soft-keyboard backspace and paste behavior on mobile.
class PasscodeBoxesInput extends StatefulWidget {
  const PasscodeBoxesInput({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.helperText,
    this.errorText,
    this.disabled = false,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String label;
  final String? helperText;
  final String? errorText;
  final bool disabled;

  @override
  State<PasscodeBoxesInput> createState() => _PasscodeBoxesInputState();
}

class _PasscodeBoxesInputState extends State<PasscodeBoxesInput> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(PasscodeBoxesInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final displayText = hasError ? widget.errorText : widget.helperText;
    final digits =
        List.generate(6, (i) => i < widget.value.length ? widget.value[i] : '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.navy900,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: widget.disabled
              ? null
              : () {
                  _focusNode.requestFocus();
                  _controller.selection = TextSelection.collapsed(
                    offset: _controller.text.length,
                  );
                },
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Hidden input that owns the real text editing state.
              Opacity(
                opacity: 0,
                child: SizedBox(
                  height: 1,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: !widget.disabled,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    autofillHints: const [AutofillHints.oneTimeCode],
                    onChanged: widget.onChanged,
                    decoration:
                        const InputDecoration(counterText: ''),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var index = 0; index < 6; index++) ...[
                    _DigitBox(
                      digit: digits[index],
                      isFocused: !widget.disabled &&
                          _focusNode.hasFocus &&
                          widget.value.length == index,
                      hasError: hasError,
                      disabled: widget.disabled,
                    ),
                    if (index == 2)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          '-',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy900.withValues(alpha: 0.7),
                          ),
                        ),
                      )
                    else if (index < 5)
                      const SizedBox(width: 8),
                  ],
                ],
              ),
            ],
          ),
        ),
        if (displayText != null && displayText.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            displayText,
            style: TextStyle(
              fontSize: 12,
              color: hasError
                  ? AppColors.error
                  : AppColors.navy900.withValues(alpha: 0.6),
            ),
          ),
        ],
      ],
    );
  }
}

class _DigitBox extends StatelessWidget {
  const _DigitBox({
    required this.digit,
    required this.isFocused,
    required this.hasError,
    required this.disabled,
  });

  final String digit;
  final bool isFocused;
  final bool hasError;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final borderColor = hasError
        ? AppColors.error
        : isFocused
            ? AppColors.gold500
            : AppColors.gray300;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: disabled ? AppColors.bgSecondary : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Text(
        digit,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
          color: disabled
              ? AppColors.navy900.withValues(alpha: 0.5)
              : AppColors.navy900,
        ),
      ),
    );
  }
}
