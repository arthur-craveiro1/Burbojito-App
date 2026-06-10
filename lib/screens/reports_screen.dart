import 'package:flutter/material.dart';

import '../models/instrument_operation.dart';

/// "Relatórios" screen.
///
/// Currently backed by mock data so the screen is presentable without the
/// backend. To use real data, swap `_loadMockOperations()` for
/// `ApiService().listOperations()` (see commented line in `_reload`).
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late Future<List<InstrumentOperation>> _operationsFuture;

  @override
  void initState() {
    super.initState();
    _operationsFuture = _loadMockOperations();
  }

  Future<void> _reload() async {
    setState(() {
      // To use the real backend, replace the line below with:
      // _operationsFuture = ApiService().listOperations();
      _operationsFuture = _loadMockOperations();
    });
    await _operationsFuture;
  }

  /// Returns hardcoded sample reports, mimicking the backend response shape.
  Future<List<InstrumentOperation>> _loadMockOperations() async {
    // Small delay so the loading spinner is visible briefly.
    await Future.delayed(const Duration(milliseconds: 350));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 10);

    // Most recent Thursday strictly before today.
    final daysSinceThursday =
        ((today.weekday - DateTime.thursday + 7) % 7) == 0
            ? 7
            : (today.weekday - DateTime.thursday + 7) % 7;
    final lastThursday = today.subtract(Duration(days: daysSinceThursday));

    InstrumentOperation op({
      required String id,
      String? pdf,
      String? patient,
      required DateTime when,
    }) {
      return InstrumentOperation(
        operationId: id,
        patientIdentifier: patient,
        status: 'received',
        pdfResultPath: pdf,
        receivedAt: when,
      );
    }

    return [
      // Hoje
      op(
        id: 'OP-2026-0001',
        pdf: '/reports/Marilene_Esquivoni.pdf',
        when: today.add(const Duration(hours: 2)),
      ),
      op(
        id: 'OP-2026-0002',
        pdf: '/reports/Arthur.Moreira_Craveiro.pdf',
        when: today.add(const Duration(hours: 1, minutes: 20)),
      ),
      op(
        id: 'OP-2026-0003',
        pdf: '/reports/Camote_Oliveira_Inocente.pdf',
        when: today.add(const Duration(minutes: 40)),
      ),
      op(id: 'OP-2026-0004', when: today),
      // Quinta-feira
      op(id: 'OP-2026-0005', when: lastThursday.add(const Duration(hours: 3))),
      op(id: 'OP-2026-0006', when: lastThursday.add(const Duration(hours: 2))),
      op(id: 'OP-2026-0007', when: lastThursday),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: const Color(0xFF4A86E8),
        unselectedItemColor: Colors.black87,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, '/home');
              }
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/patients');
              break;
            case 2:
              break; // already on Relatórios
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Relatórios',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A1F3C),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<InstrumentOperation>>(
                  future: _operationsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return _ErrorState(
                        message: snapshot.error.toString(),
                        onRetry: _reload,
                      );
                    }

                    final operations = snapshot.data ?? const [];
                    if (operations.isEmpty) {
                      return _EmptyState(onRetry: _reload);
                    }

                    final groups = _groupByDay(operations);
                    return RefreshIndicator(
                      onRefresh: _reload,
                      child: ListView(
                        children: [
                          for (final group in groups) ...[
                            _SectionHeader(label: group.label),
                            for (final op in group.operations)
                              _ReportTile(operation: op),
                            const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Groups operations into day buckets, most recent first.
  List<_DayGroup> _groupByDay(List<InstrumentOperation> operations) {
    final sorted = [...operations]..sort((a, b) {
        final da = _dateOf(b);
        final db = _dateOf(a);
        return da.compareTo(db);
      });

    final Map<DateTime, List<InstrumentOperation>> buckets = {};
    for (final op in sorted) {
      final date = _dateOf(op);
      final key = DateTime(date.year, date.month, date.day);
      buckets.putIfAbsent(key, () => []).add(op);
    }

    final keys = buckets.keys.toList()..sort((a, b) => b.compareTo(a));
    return [
      for (final key in keys)
        _DayGroup(label: _dayLabel(key), operations: buckets[key]!),
    ];
  }

  DateTime _dateOf(InstrumentOperation op) {
    return op.receivedAt ?? op.finishedAt ?? op.startedAt ?? DateTime(1970);
  }

  String _dayLabel(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = today.difference(day).inDays;

    if (difference == 0) return 'Hoje';
    if (difference == 1) return 'Ontem';

    const weekdays = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo',
    ];
    return weekdays[day.weekday - 1];
  }
}

class _DayGroup {
  _DayGroup({required this.label, required this.operations});

  final String label;
  final List<InstrumentOperation> operations;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF9AA7B8),
        ),
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({required this.operation});

  final InstrumentOperation operation;

  /// Derives the display filename for the report.
  String get _fileName {
    final path = operation.pdfResultPath;
    if (path != null && path.isNotEmpty) {
      final segments = path.split(RegExp(r'[/\\]'));
      final name = segments.isNotEmpty ? segments.last : path;
      if (name.isNotEmpty) return name;
    }
    final patient = operation.patientIdentifier;
    if (patient != null && patient.isNotEmpty) return '$patient.pdf';
    return 'Nome.pdf';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8C7A8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.attach_file, size: 22, color: Colors.black87),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              _fileName,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRetry,
      child: ListView(
        children: const [
          SizedBox(height: 120),
          Icon(Icons.folder_open, size: 56, color: Color(0xFF9AA7B8)),
          SizedBox(height: 16),
          Center(
            child: Text(
              'Nenhum relatório encontrado.',
              style: TextStyle(fontSize: 16, color: Color(0xFF9AA7B8)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, size: 56, color: Color(0xFF9AA7B8)),
          const SizedBox(height: 16),
          const Text(
            'Não foi possível carregar os relatórios.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Color(0xFF0A1F3C)),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF9AA7B8)),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A86E8),
            ),
            child: const Text(
              'Tentar novamente',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
