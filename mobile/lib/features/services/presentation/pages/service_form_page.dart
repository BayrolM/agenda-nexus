import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/utils/amount_formatter.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../companies/presentation/pages/company_form_validators.dart';
import '../../domain/entities/company_service.dart';
import '../controllers/services_controller.dart';

class ServiceFormPage extends ConsumerStatefulWidget {
  final String companyId;
  final String? serviceId;

  const ServiceFormPage({
    super.key,
    required this.companyId,
    this.serviceId,
  });

  @override
  ConsumerState<ServiceFormPage> createState() => _ServiceFormPageState();
}

class _ServiceFormPageState extends ConsumerState<ServiceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _monthlyCostController = TextEditingController();
  final _notesController = TextEditingController();

  ServiceType _selectedType = ServiceType.other;
  DateTime? _expirationDate;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureApiKey = true;
  CompanyService? _existingService;

  bool get _isEditing => widget.serviceId != null;

  static String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final trimmed = value.trim();
    if (trimmed.length < 3) return 'Minimo 3 caracteres';
    if (trimmed.length > 40) return 'Maximo 40 caracteres';
    return null;
  }

  @override
  void initState() {
    super.initState();
    _notesController.addListener(_onTextChanged);
    if (_isEditing) _loadService();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadService() async {
    final services =
        ref.read(servicesByCompanyProvider(widget.companyId)).valueOrNull ?? [];
    try {
      _existingService = services.firstWhere((s) => s.id == widget.serviceId);
      _selectedType = _existingService!.serviceType;
      _nameController.text = _existingService!.name;
      _urlController.text = _existingService!.url ?? '';
      _usernameController.text = _existingService!.username ?? '';
      _passwordController.text = _existingService!.password ?? '';
      _apiKeyController.text = _existingService!.apiKey ?? '';
      final cost = _existingService!.monthlyCost;
      if (cost != null) {
        _monthlyCostController.text =
            AmountValidators.formatThousands(cost.toStringAsFixed(0));
      }
      _notesController.text = _existingService!.notes ?? '';
      _expirationDate = _existingService!.expirationDate;
    } catch (_) {
      if (mounted) {
        AppToast.error(context, 'Servicio no encontrado');
        context.pop();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _apiKeyController.dispose();
    _monthlyCostController.dispose();
    _notesController.removeListener(_onTextChanged);
    _notesController.dispose();
    super.dispose();
  }

  bool _validateAll() {
    final validations = <MapEntry<String, String?>>[
      MapEntry('Nombre', CompanyValidators.validateName(_nameController.text)),
      MapEntry('Usuario', _validateUsername(_usernameController.text)),
      MapEntry('Costo mensual',
          AmountValidators.validate(_monthlyCostController.text)),
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
      final servicesNotifier =
          ref.read(servicesByCompanyProvider(widget.companyId).notifier);

      final service = CompanyService(
        id: _existingService?.id ?? '',
        companyId: widget.companyId,
        serviceType: _selectedType,
        name: _nameController.text.trim(),
        url: _urlController.text.trim().isEmpty
            ? null
            : _urlController.text.trim(),
        username: _usernameController.text.trim().isEmpty
            ? null
            : _usernameController.text.trim(),
        password: _passwordController.text.trim().isEmpty
            ? null
            : _passwordController.text.trim(),
        apiKey: _apiKeyController.text.trim().isEmpty
            ? null
            : _apiKeyController.text.trim(),
        expirationDate: _expirationDate,
        monthlyCost: _monthlyCostController.text.trim().isEmpty
            ? null
            : AmountValidators.parse(_monthlyCostController.text.trim()),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      if (_isEditing) {
        await servicesNotifier.update(service);
      } else {
        await servicesNotifier.create(service);
      }

      if (mounted) {
        AppToast.success(
          context,
          _isEditing
              ? 'Servicio actualizado exitosamente'
              : 'Servicio creado exitosamente',
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) AppToast.error(context, 'Error al guardar: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickExpirationDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate:
          _expirationDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (date != null) {
      setState(() => _expirationDate = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.gray100 : AppColors.black;
    final mutedText = isDark ? AppColors.gray400 : AppColors.gray500;
    final chipSelectedBg = isDark ? AppColors.gray100 : AppColors.black;
    final chipSelectedText = isDark ? AppColors.black : AppColors.white;
    final chipDefaultBg = isDark ? AppColors.gray800 : AppColors.white;
    final chipBorder = isDark ? AppColors.gray600 : AppColors.gray300;
    final notesLen = _notesController.text.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Servicio' : 'Nuevo Servicio'),
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
              Text(
                'Tipo de Servicio',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ServiceType.values.map((type) {
                  final isSelected = _selectedType == type;
                  return ChoiceChip(
                    label: Text(_getServiceTypeLabel(type)),
                    selected: isSelected,
                    onSelected: (_) =>
                        setState(() => _selectedType = type),
                    selectedColor: chipSelectedBg,
                    backgroundColor: chipDefaultBg,
                    labelStyle: TextStyle(
                      color: isSelected ? chipSelectedText : textColor,
                      fontWeight: FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: isSelected ? chipSelectedBg : chipBorder,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                maxLength: 50,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                textCapitalization: TextCapitalization.words,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\- ]')),
                  LengthLimitingTextInputFormatter(50),
                ],
                decoration: const InputDecoration(
                  labelText: 'Nombre *',
                  hintText: 'Ej: GitHub Pro, Google Workspace',
                  counterText: '',
                ),
                validator: CompanyValidators.validateName,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _urlController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'URL',
                  hintText: 'https://...',
                  prefixIcon: Icon(Icons.link, size: 20),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _usernameController,
                maxLength: 40,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(40),
                ],
                decoration: const InputDecoration(
                  labelText: 'Usuario / Correo',
                  hintText: 'usuario@correo.com',
                  prefixIcon: Icon(Icons.person_outline, size: 20),
                  counterText: '',
                ),
                validator: _validateUsername,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Contrasena',
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(
                          () => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _apiKeyController,
                obscureText: _obscureApiKey,
                decoration: InputDecoration(
                  labelText: 'API Key (opcional)',
                  prefixIcon:
                      const Icon(Icons.vpn_key_outlined, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureApiKey
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(
                          () => _obscureApiKey = !_obscureApiKey);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: _pickExpirationDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Fecha de expiracion',
                    prefixIcon:
                        const Icon(Icons.event_outlined, size: 20),
                    suffixIcon: _expirationDate != null
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              setState(() => _expirationDate = null);
                            },
                          )
                        : null,
                  ),
                  child: Text(
                    _expirationDate != null
                        ? DateFormat('dd/MM/yyyy')
                            .format(_expirationDate!)
                        : 'Seleccionar fecha',
                    style: TextStyle(
                      color: _expirationDate != null
                          ? textColor
                          : AppColors.gray400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _monthlyCostController,
                keyboardType: TextInputType.number,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                inputFormatters: [AmountFormatter()],
                decoration: const InputDecoration(
                  labelText: 'Costo mensual (COP)',
                  hintText: 'Ej: 50.000',
                  prefixIcon: Icon(Icons.attach_money, size: 20),
                ),
                validator: (value) => AmountValidators.validate(value),
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
                      : Text(_isEditing
                          ? 'Guardar Cambios'
                          : 'Crear Servicio'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getServiceTypeLabel(ServiceType type) {
    switch (type) {
      case ServiceType.google:
        return 'Google';
      case ServiceType.github:
        return 'GitHub';
      case ServiceType.database:
        return 'Base de Datos';
      case ServiceType.hosting:
        return 'Hosting';
      case ServiceType.backend:
        return 'Backend';
      case ServiceType.email:
        return 'Correo';
      case ServiceType.domain:
        return 'Dominio';
      case ServiceType.other:
        return 'Otro';
    }
  }
}
