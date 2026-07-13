import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../data/datasources/auth_remote_datasource.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  final String pendingId;
  final String email;

  const VerifyEmailPage({
    super.key,
    required this.pendingId,
    required this.email,
  });

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isVerifying = false;
  bool _isResending = false;
  int _resendSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendSeconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  String get _code => _controllers.map((c) => c.text).join();

  Future<void> _verify() async {
    final code = _code;
    if (code.length != 6) {
      AppToast.warning(context, 'Ingresa el codigo de 6 digitos');
      return;
    }

    setState(() => _isVerifying = true);

    try {
      final dataSource = AuthRemoteDataSource();
      final result = await dataSource.verifyEmail(
        pendingId: widget.pendingId,
        code: code,
      );

      if (mounted) {
        if (result != null && result['token'] != null) {
          AppToast.success(context, 'Correo verificado exitosamente');
          // Auto-login: go to home page
          context.go('/');
        } else {
          AppToast.success(context, 'Correo verificado exitosamente');
          context.go('/login');
        }
      }
    } on AuthException catch (e) {
      if (mounted) AppToast.error(context, e.message);
    } catch (e) {
      if (mounted) {
        AppToast.error(context, 'Error al verificar. Intenta de nuevo.');
      }
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  Future<void> _resendCode() async {
    if (_resendSeconds > 0) return;

    setState(() => _isResending = true);

    try {
      final dataSource = AuthRemoteDataSource();
      await dataSource.resendCode(pendingId: widget.pendingId);

      if (mounted) {
        AppToast.success(context, 'Codigo reenviado. Revisa tu correo.');
        _startResendTimer();
      }
    } on AuthException catch (e) {
      if (mounted) AppToast.error(context, e.message);
    } catch (e) {
      if (mounted) {
        AppToast.error(context, 'Error al reenviar codigo.');
      }
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.gray100 : AppColors.black;
    final secondaryText = isDark ? AppColors.gray400 : AppColors.gray500;
    final borderColor = isDark ? AppColors.gray600 : AppColors.gray300;
    final focusBorderColor = isDark ? AppColors.gray100 : AppColors.black;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.mark_email_unread_outlined,
                  size: 64,
                  color: textColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'Verifica tu correo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enviamos un codigo de 6 digitos a',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.email,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 40),
                _buildCodeInputs(borderColor, focusBorderColor, textColor),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isVerifying ? null : _verify,
                    child: _isVerifying
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : const Text('Verificar'),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _resendSeconds > 0 || _isResending
                      ? null
                      : _resendCode,
                  child: Text(
                    _resendSeconds > 0
                        ? 'Reenviar codigo en $_resendSeconds s'
                        : 'Reenviar codigo',
                    style: TextStyle(
                      color: _resendSeconds > 0
                          ? AppColors.gray400
                          : textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeInputs(
      Color borderColor, Color focusBorderColor, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          width: 48,
          height: 56,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: focusBorderColor, width: 2),
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                _focusNodes[index + 1].requestFocus();
              }
              if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
              if (_code.length == 6) {
                _verify();
              }
            },
          ),
        );
      }),
    );
  }
}
