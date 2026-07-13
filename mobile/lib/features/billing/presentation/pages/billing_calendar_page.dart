import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../companies/domain/entities/company.dart';
import '../../../companies/presentation/controllers/companies_controller.dart';
import '../../data/datasources/billing_remote_datasource.dart';
import '../../data/models/billing_model.dart';
import '../../domain/entities/billing_record.dart';

class BillingCalendarPage extends ConsumerStatefulWidget {
  const BillingCalendarPage({super.key});

  @override
  ConsumerState<BillingCalendarPage> createState() =>
      _BillingCalendarPageState();
}

class _BillingCalendarPageState extends ConsumerState<BillingCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<BillingRecord> _records = [];
  Map<String, Company> _companiesMap = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();

    // Reload billing data whenever companies change
    ref.listen(companiesProvider, (prev, next) {
      if (mounted && next.hasValue) {
        _loadData();
      }
    });
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final dataSource = BillingRemoteDataSource();

      // Mark overdue reminders as a safety net
      await dataSource.markOverdue();

      final records = await dataSource.getAll();

      final companiesState = ref.read(companiesProvider);
      final companies = companiesState.valueOrNull ?? [];
      final map = <String, Company>{};
      for (final c in companies) {
        map[c.id] = c;
      }

      if (mounted) {
        setState(() {
          _records = records;
          _companiesMap = map;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Company? _findCompany(String companyId) => _companiesMap[companyId];

  List<BillingRecord> _getRecordsForDay(DateTime day) {
    return _records.where((r) =>
        r.reminderDate.year == day.year &&
        r.reminderDate.month == day.month &&
        r.reminderDate.day == day.day).toList();
  }

  List<BillingRecord> _getUpcomingRecords() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _records
        .where((r) =>
            !r.reminderDate.isBefore(today) &&
            r.status != BillingStatus.paid)
        .toList()
      ..sort((a, b) => a.reminderDate.compareTo(b.reminderDate));
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de Cobros'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Modo claro' : 'Modo oscuro',
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: isDark ? AppColors.white : AppColors.black))
          : _error != null
              ? _buildError()
              : _buildCalendar(isDark),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                size: 48, color: AppColors.gray400),
            const SizedBox(height: 16),
            const Text(
              'Error al cargar cobros',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.gray500),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _loadData,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(bool isDark) {
    final textColor = isDark ? AppColors.gray100 : AppColors.black;
    final mutedColor = isDark ? AppColors.gray400 : AppColors.gray600;
    final todayBg = isDark ? AppColors.gray700 : AppColors.gray200;
    final markerColor = isDark ? AppColors.white : AppColors.black;
    final borderColor = isDark ? AppColors.gray600 : AppColors.gray300;

    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime(2020),
          lastDay: DateTime(2030),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            setState(() => _calendarFormat = format);
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            todayDecoration: BoxDecoration(
              color: todayBg,
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(color: textColor),
            selectedDecoration: BoxDecoration(
              color: markerColor,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(
                color: isDark ? AppColors.black : AppColors.white),
            defaultTextStyle: TextStyle(color: textColor),
            weekendTextStyle: TextStyle(color: mutedColor),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
            leftChevronIcon: Icon(Icons.chevron_left, color: textColor),
            rightChevronIcon: Icon(Icons.chevron_right, color: textColor),
            formatButtonTextStyle: TextStyle(color: textColor),
            formatButtonDecoration: BoxDecoration(
              border: Border.fromBorderSide(
                  BorderSide(color: borderColor)),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              final dayRecords = _getRecordsForDay(day);
              if (dayRecords.isEmpty) return null;

              final hasOverdue = dayRecords.any((r) => r.status == BillingStatus.overdue);
              final hasPending = dayRecords.any((r) => r.status == BillingStatus.pending);

              Color dotColor;
              if (hasOverdue) {
                dotColor = AppColors.error;
              } else if (hasPending) {
                dotColor = AppColors.warning;
              } else {
                dotColor = AppColors.success;
              }

              return Positioned(
                bottom: 4,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ),
        Divider(height: 1, color: isDark ? AppColors.gray700 : AppColors.gray200),
        Expanded(
          child: _selectedDay != null
              ? _buildSelectedDayList(isDark)
              : _buildUpcomingList(isDark),
        ),
      ],
    );
  }

  Widget _buildSelectedDayList(bool isDark) {
    final dayRecords = _getRecordsForDay(_selectedDay!);
    final textColor = isDark ? AppColors.gray100 : AppColors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            DateFormat('EEEE d \'de\' MMMM', 'es').format(_selectedDay!),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
        Expanded(
          child: dayRecords.isEmpty
              ? const Center(
                  child: Text('Sin cobros este día',
                      style: TextStyle(color: AppColors.gray500)),
                )
              : _buildRecordsList(dayRecords, isDark),
        ),
      ],
    );
  }

  Widget _buildUpcomingList(bool isDark) {
    final upcoming = _getUpcomingRecords();

    if (upcoming.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline,
                size: 48, color: AppColors.gray300),
            SizedBox(height: 16),
            Text('Sin cobros pendientes',
                style: TextStyle(fontSize: 16, color: AppColors.gray500)),
          ],
        ),
      );
    }

    final textColor = isDark ? AppColors.gray100 : AppColors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Próximos cobros',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor)),
        ),
        Expanded(child: _buildRecordsList(upcoming, isDark)),
      ],
    );
  }

  Widget _buildRecordsList(List<BillingRecord> records, bool isDark) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          final company = _findCompany(record.companyId);
          return _buildBillingCard(record, company, isDark);
        },
      ),
    );
  }

  Widget _buildBillingCard(
      BillingRecord record, Company? company, bool isDark) {
    final isPaid = record.status == BillingStatus.paid;
    final isOverdue = record.status == BillingStatus.overdue;
    final companyName = company?.name ?? 'Empresa';
    final displayAmount = record.amount ?? company?.billingAmount;
    final textColor = isDark ? AppColors.gray100 : AppColors.black;
    final dayBg =
        isDark ? AppColors.gray700 : AppColors.gray100;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _openBillingDetail(record, company, isDark),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isPaid
                      ? AppColors.successLight
                      : isOverdue
                          ? AppColors.errorLight
                          : dayBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    DateFormat('d').format(record.reminderDate),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isPaid
                          ? AppColors.success
                          : isOverdue
                              ? AppColors.error
                              : textColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(companyName,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: textColor)),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM yyyy', 'es')
                          .format(record.reminderDate),
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.gray500),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (displayAmount != null)
                    Text(
                      '\$${_formatAmount(displayAmount)}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textColor),
                    ),
                  const SizedBox(height: 4),
                  if (isPaid)
                    SizedBox(
                      height: 28,
                      child: OutlinedButton(
                        onPressed: () => _markPending(record),
                        style: OutlinedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          side: BorderSide(
                              color: isDark
                                  ? AppColors.gray600
                                  : AppColors.gray300),
                        ),
                        child: Text('Revertir',
                            style: TextStyle(
                                fontSize: 11, color: textColor)),
                      ),
                    )
                  else
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: isOverdue
                                ? AppColors.errorLight
                                : AppColors.warningLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                              isOverdue ? 'Vencido' : 'Pendiente',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: isOverdue
                                      ? AppColors.error
                                      : AppColors.warning)),
                        ),
                        const SizedBox(width: 6),
                        SizedBox(
                          height: 28,
                          child: OutlinedButton(
                            onPressed: () => _markPaid(record),
                            style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              side: BorderSide(
                                  color: isDark
                                      ? AppColors.gray600
                                      : AppColors.gray300),
                            ),
                            child: Text('Pagado',
                                style: TextStyle(
                                    fontSize: 11, color: textColor)),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right,
                  color: isDark ? AppColors.gray500 : AppColors.gray400,
                  size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _markPaid(BillingRecord record) async {
    final dataSource = BillingRemoteDataSource();
    await dataSource.update(BillingModel(
      id: record.id,
      companyId: record.companyId,
      reminderDate: record.reminderDate,
      amount: record.amount,
      status: BillingStatus.paid,
    ));
    if (mounted) {
      AppToast.success(context, 'Cobro marcado como pagado');
      _loadData();
    }
  }

  Future<void> _markPending(BillingRecord record) async {
    final dataSource = BillingRemoteDataSource();
    await dataSource.update(BillingModel(
      id: record.id,
      companyId: record.companyId,
      reminderDate: record.reminderDate,
      amount: record.amount,
      status: BillingStatus.pending,
    ));
    if (mounted) {
      AppToast.info(context, 'Cobro revertido a pendiente');
      _loadData();
    }
  }

  String _formatAmount(double amount) {
    final format = NumberFormat('#,##0', 'es_CO');
    return format.format(amount);
  }

  void _openBillingDetail(
      BillingRecord record, Company? company, bool isDark) {
    final companyName = company?.name ?? 'Empresa';
    final displayAmount = record.amount ?? company?.billingAmount;
    final textColor = isDark ? AppColors.gray100 : AppColors.black;
    final bgColor = isDark ? AppColors.gray800 : AppColors.white;
    final subBg = isDark ? AppColors.gray700 : AppColors.gray50;
    final borderColor = isDark ? AppColors.gray600 : AppColors.gray200;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.gray600
                          : AppColors.gray300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(companyName,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: textColor)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: record.status == BillingStatus.paid
                        ? AppColors.successLight
                        : record.status == BillingStatus.overdue
                            ? AppColors.errorLight
                            : subBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    record.status == BillingStatus.paid
                        ? 'Pagado'
                        : record.status == BillingStatus.overdue
                            ? 'Vencido'
                            : 'Pendiente',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: record.status == BillingStatus.paid
                          ? AppColors.success
                          : record.status == BillingStatus.overdue
                              ? AppColors.error
                              : AppColors.gray600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildDetailRow(
                    icon: Icons.calendar_today,
                    label: 'Fecha de cobro',
                    value: DateFormat('dd/MM/yyyy')
                        .format(record.reminderDate),
                    isDark: isDark),
                if (company != null && company.billingDay != null)
                  _buildDetailRow(
                      icon: Icons.event_repeat,
                      label: 'Día de cobro mensual',
                      value: 'Día ${company.billingDay}',
                      isDark: isDark),
                if (displayAmount != null)
                  _buildDetailRow(
                      icon: Icons.attach_money,
                      label: 'Monto a cobrar',
                      value: '\$${_formatAmount(displayAmount)} COP',
                      isDark: isDark),
                if (company != null &&
                    company.notes != null &&
                    company.notes!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('Notas',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray500)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: subBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    child: Text(company.notes!,
                        style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.gray300
                                : AppColors.gray700)),
                  ),
                ],
                const SizedBox(height: 32),
                if (record.status == BillingStatus.paid)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await _markPending(record);
                        if (context.mounted) Navigator.pop(context);
                      },
                      icon: const Icon(Icons.undo),
                      label: const Text('Revertir a pendiente'),
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await _markPaid(record);
                        if (context.mounted) Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Marcar como pagado'),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    final textColor = isDark ? AppColors.gray100 : AppColors.black;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon,
              size: 20,
              color: isDark ? AppColors.gray500 : AppColors.gray400),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.gray500)),
                Text(value,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
