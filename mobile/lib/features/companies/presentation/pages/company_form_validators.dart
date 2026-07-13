import '../../../../shared/utils/amount_formatter.dart';

class CompanyValidators {
  CompanyValidators._();

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es obligatorio';
    }
    final trimmed = value.trim();
    if (trimmed.length < 3) return 'Minimo 3 caracteres';
    if (trimmed.length > 50) return 'Maximo 50 caracteres';
    if (!RegExp(r'^[a-zA-Z0-9\- ]+$').hasMatch(trimmed)) {
      return 'Solo letras, numeros y guiones (-)';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final trimmed = value.trim();
    if (trimmed.length < 2) return 'Minimo 2 caracteres';
    if (trimmed.length > 255) return 'Maximo 255 caracteres';
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final trimmed = value.trim();
    if (!RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$')
        .hasMatch(trimmed)) {
      return 'Formato de correo invalido';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final trimmed = value.trim();
    if (trimmed.length < 8) return 'Minimo 8 caracteres';
    if (trimmed.length > 20) return 'Maximo 20 caracteres';
    if (!RegExp(r'^[0-9+\-() ]+$').hasMatch(trimmed)) {
      return 'Solo numeros, +, -, (, ) y espacios';
    }
    return null;
  }

  static String? validateBillingDay(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El dia de cobro es obligatorio';
    }
    final trimmed = value.trim();
    if (!RegExp(r'^\d+$').hasMatch(trimmed)) return 'Solo numeros enteros';
    final day = int.tryParse(trimmed);
    if (day == null || day < 1 || day > 31) {
      return 'Debe ser un dia entre 1 y 31';
    }
    return null;
  }

  static String? validateAmount(String? value) {
    return AmountValidators.validate(value, required: true);
  }

  static String? validateNotes(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (value.trim().length > 255) return 'Maximo 255 caracteres';
    return null;
  }
}
