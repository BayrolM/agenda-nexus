import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/utils/amount_formatter.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/company.dart';
import '../controllers/companies_controller.dart';
import 'company_form_validators.dart';

class CompanyFormPage extends ConsumerStatefulWidget {
  final String? companyId;

  const CompanyFormPage({super.key, this.companyId});

  @override
  ConsumerState<CompanyFormPage> createState() => _CompanyFormPageState();
}

class _CompanyFormPageState extends ConsumerState<CompanyFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _billingDayController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isLoading = false;
  Company? _existingCompany;

  bool get _isEditing => widget.companyId != null;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_onTextChanged);
    _notesController.addListener(_onTextChanged);
    if (_isEditing) _loadCompany();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadCompany() async {
    final companies = ref.read(companiesProvider).valueOrNull ?? [];
    try {
      _existingCompany = companies.firstWhere((c) => c.id == widget.companyId);
      _nameController.text = _existingCompany!.name;
      _descriptionController.text = _existingCompany!.description ?? '';
      _emailController.text = _existingCompany!.contactEmail ?? '';
      _phoneController.text = _existingCompany!.contactPhone ?? '';
      _billingDayController.text =
          _existingCompany!.billingDay?.toString() ?? '';
      final amount = _existingCompany!.billingAmount;
      if (amount != null) {
        final raw = amount.toStringAsFixed(0);
        final formatted = raw.replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );
        _amountController.text = formatted;
      }
      _notesController.text = _existingCompany!.notes ?? '';
    } catch (_) {
      if (mounted) {
        AppToast.error(context, 'Empresa no encontrada');
        context.pop();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.removeListener(_onTextChanged);
    _descriptionController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _billingDayController.dispose();
    _amountController.dispose();
    _notesController.removeListener(_onTextChanged);
    _notesController.dispose();
    super.dispose();
  }

  bool _validateAll() {
    final validations = <MapEntry<String, String?>>[
      MapEntry('Nombre', CompanyValidators.validateName(_nameController.text)),
      MapEntry('Descripcion',
          CompanyValidators.validateDescription(_descriptionController.text)),
      MapEntry('Correo', CompanyValidators.validateEmail(_emailController.text)),
      MapEntry(
          'Telefono', CompanyValidators.validatePhone(_phoneController.text)),
      MapEntry('Dia de cobro',
          CompanyValidators.validateBillingDay(_billingDayController.text)),
      MapEntry(
          'Monto', CompanyValidators.validateAmount(_amountController.text)),
      MapEntry('Notas', CompanyValidators.validateNotes(_notesController.text)),
    ];

    for (final v in validations) {
      if (v.value != null) {
        AppToast.error(context, '${v.key}: ${v.value}');
        return false;
      }
    }
    return true;
  }

  Future<void> _handleSave() async {
    if (!_validateAll()) return;

    setState(() => _isLoading = true);

    try {
      final companiesNotifier = ref.read(companiesProvider.notifier);
      final currentUser = ref.read(authStateProvider).valueOrNull;
      if (currentUser == null) {
        if (mounted) AppToast.error(context, 'Debes iniciar sesion');
        return;
      }

      final company = Company(
        id: _existingCompany?.id ?? '',
        userId: currentUser.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        contactEmail: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        contactPhone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        billingDay: _billingDayController.text.trim().isEmpty
            ? null
            : int.tryParse(_billingDayController.text.trim()),
        billingAmount: _amountController.text.trim().isEmpty
            ? null
            : AmountValidators.parse(_amountController.text.trim()),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        isActive: _existingCompany?.isActive ?? true,
      );

      if (_isEditing) {
        await companiesNotifier.update(company);
      } else {
        await companiesNotifier.create(company);
      }

      if (mounted) {
        AppToast.success(
          context,
          _isEditing
              ? 'Empresa actualizada exitosamente'
              : 'Empresa creada exitosamente',
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) AppToast.error(context, 'Error al guardar: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.gray100 : AppColors.black;
    final mutedText = isDark ? AppColors.gray400 : AppColors.gray500;
    final descLen = _descriptionController.text.length;
    final notesLen = _notesController.text.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Empresa' : 'Nueva Empresa'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                maxLength: 50,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\- ]')),
                  LengthLimitingTextInputFormatter(50),
                ],
                decoration: const InputDecoration(
                  labelText: 'Nombre *',
                  hintText: 'Nombre de la empresa',
                  counterText: '',
                ),
                validator: CompanyValidators.validateName,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                inputFormatters: [LengthLimitingTextInputFormatter(255)],
                decoration: InputDecoration(
                  labelText: 'Descripcion',
                  hintText: 'Breve descripcion',
                  counterText: '',
                  counter: Text(
                    '$descLen/255',
                    style: TextStyle(
                      color: descLen > 255 ? AppColors.error : mutedText,
                      fontSize: 12,
                    ),
                  ),
                ),
                validator: CompanyValidators.validateDescription,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo de contacto',
                  hintText: 'contacto@empresa.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: CompanyValidators.validateEmail,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 20,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-() ]')),
                  LengthLimitingTextInputFormatter(20),
                ],
                decoration: const InputDecoration(
                  labelText: 'Telefono',
                  hintText: '+57 300 123 4567',
                  prefixIcon: Icon(Icons.phone_outlined),
                  counterText: '',
                ),
                validator: CompanyValidators.validatePhone,
              ),
              const SizedBox(height: 24),

              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Informacion de Cobro',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _billingDayController,
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Dia de cobro *',
                        hintText: '1-31',
                        prefixIcon: Icon(Icons.calendar_today, size: 20),
                        counterText: '',
                      ),
                      validator: CompanyValidators.validateBillingDay,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      inputFormatters: [AmountFormatter()],
                      decoration: const InputDecoration(
                        labelText: 'Monto (COP) *',
                        hintText: 'Ej: 500.000',
                        prefixIcon: Icon(Icons.attach_money, size: 20),
                      ),
                      validator: CompanyValidators.validateAmount,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _notesController,
                maxLines: 3,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                inputFormatters: [LengthLimitingTextInputFormatter(255)],
                decoration: InputDecoration(
                  labelText: 'Notas (opcional)',
                  hintText: 'Informacion adicional...',
                  alignLabelWithHint: true,
                  counterText: '',
                  counter: Text(
                    '$notesLen/255',
                    style: TextStyle(
                      color: notesLen > 255 ? AppColors.error : mutedText,
                      fontSize: 12,
                    ),
                  ),
                ),
                validator: CompanyValidators.validateNotes,
              ),
              const SizedBox(height: 32),

              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : Text(
                          _isEditing ? 'Guardar Cambios' : 'Crear Empresa',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
