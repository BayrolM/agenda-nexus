import 'package:flutter/services.dart';

class AmountFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newRaw = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (newRaw.isEmpty) {
      return const TextEditingValue(
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final truncated = newRaw.length > 8 ? newRaw.substring(0, 8) : newRaw;

    final formatted = truncated.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );

    final cursorIndex = newValue.selection.end;
    final typedBeforeCursor =
        newRaw.substring(0, cursorIndex.clamp(0, newRaw.length)).length;

    int pos = 0;
    int digits = 0;
    for (int i = 0; i < formatted.length; i++) {
      if (digits == typedBeforeCursor) break;
      pos = i + 1;
      if (RegExp(r'\d').hasMatch(formatted[i])) digits++;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: pos),
    );
  }
}

class AmountValidators {
  AmountValidators._();

  static String? validate(String? value, {bool required = false}) {
    if (value == null || value.trim().isEmpty) {
      return required ? 'Este campo es obligatorio' : null;
    }
    final clean = value.replaceAll('.', '').replaceAll(',', '').trim();
    if (clean.isEmpty) return 'Este campo es obligatorio';
    if (!RegExp(r'^\d+$').hasMatch(clean)) return 'Solo numeros positivos';
    if (clean.length > 8) return 'Maximo 8 digitos';
    return null;
  }

  static double? parse(String formatted) {
    final clean = formatted.replaceAll('.', '').replaceAll(',', '');
    return double.tryParse(clean);
  }

  static String formatThousands(String raw) {
    final clean = raw.replaceAll('.', '').replaceAll(',', '');
    if (clean.isEmpty) return '';
    final number = int.tryParse(clean);
    if (number == null) return '';
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }
}
