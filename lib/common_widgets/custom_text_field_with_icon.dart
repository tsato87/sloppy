import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/string_validator.dart';


final passwordVisibleProvider = StateProvider.autoDispose((ref) => false);

class CustomPasswordFieldWithIcon extends ConsumerWidget {
  final String? defaultText;
  final String? hintText;
  final String? errorText;
  final TextEditingController editingController;
  final bool inputEnable;
  final StringValidator? validator;
  final int minLines;
  final int maxLines;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;

  const CustomPasswordFieldWithIcon({
    Key? key,
    this.defaultText,
    this.hintText,
    this.errorText,
    required this.editingController,
    this.inputEnable = true,
    this.validator,
    this.minLines = 1,
    this.maxLines = 1,
    this.onChanged,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (defaultText is String && editingController.text == '') {
      editingController.text = defaultText!;
    }
    bool passwordVisible = ref.watch(passwordVisibleProvider);
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        prefixIcon: const Icon(Icons.lock),
        hintText: hintText,
        errorText: errorText,
        enabled: inputEnable,
        suffixIcon: GestureDetector(
          child: Icon(
            // Based on passwordVisible state choose the icon
            passwordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onTapDown: (detail) {
            ref.read(passwordVisibleProvider.notifier).state = true;
          },
          onTapUp: (detail) {
            ref.read(passwordVisibleProvider.notifier).state = false;
          },
          onLongPressEnd: (detail) {
            ref.read(passwordVisibleProvider.notifier).state = false;
          },
          onPanEnd: (detail) {
            ref.read(passwordVisibleProvider.notifier).state = false;
          },
        ),
      ),
      enableInteractiveSelection: false,
      controller: editingController,
      inputFormatters: <TextInputFormatter>[
        if (validator != null) _ValidatorInputFormatter(editingValidator: validator!),
      ],
      onSaved: onSaved,
      onChanged: onChanged,
      keyboardType: TextInputType.visiblePassword,
      obscureText: !passwordVisible,
      maxLines: maxLines,
      minLines: minLines,
    );
  }
}

class CustomTextFieldWithIcon extends StatelessWidget {
  final TextEditingController editingController;
  final IconData? iconPrefix;
  final String? defaultText;
  final String? hintText;
  final String? errorText;
  final bool inputEnable;
  final StringValidator? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int minLines;
  final int maxLines;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;

  const CustomTextFieldWithIcon({
    Key? key,
    // TODO: nullを許さないように修正
    // required this.editingControllerProvider,
    required this.editingController,
    this.iconPrefix,
    this.defaultText,
    this.hintText,
    this.errorText,
    this.inputEnable = true,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.onChanged,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (defaultText is String) {
      editingController.text = defaultText!;
    }
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        prefixIcon: Icon(iconPrefix),
        hintText: hintText,
        errorText: errorText,
        enabled: inputEnable,
      ),
      controller: editingController,
      inputFormatters: <TextInputFormatter>[
        if (validator != null) _ValidatorInputFormatter(editingValidator: validator!),
      ],
      onSaved: onSaved,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
    );
  }
}

class _ValidatorInputFormatter implements TextInputFormatter {
  final StringValidator editingValidator;

  _ValidatorInputFormatter({required this.editingValidator});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final bool oldValueValid = editingValidator.isValid(oldValue.text);
    final bool newValueValid = editingValidator.isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }
}
