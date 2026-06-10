/// Mirrors the backend `Instrument` model / `InstrumentSerializer`.
class Instrument {
  Instrument({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.status,
    this.ipAddress,
    this.firmwareVersion,
    this.lastSeen,
    this.lastStatusPayload,
  });

  final int? id;
  final String name;
  final String? serialNumber;
  final String status;
  final String? ipAddress;
  final String? firmwareVersion;
  final DateTime? lastSeen;
  final Map<String, dynamic>? lastStatusPayload;

  factory Instrument.fromJson(Map<String, dynamic> json) {
    return Instrument(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      serialNumber: json['serial_number'] as String?,
      status: json['status'] as String? ?? 'unknown',
      ipAddress: json['ip_address'] as String?,
      firmwareVersion: json['firmware_version'] as String?,
      lastSeen: _parseDate(json['last_seen']),
      lastStatusPayload: json['last_status_payload'] as Map<String, dynamic>?,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}

/// Mirrors the response of GET /api/instruments/status/summary/.
class InstrumentStatusSummary {
  InstrumentStatusSummary({
    required this.total,
    required this.online,
    required this.offline,
    required this.busy,
    required this.error,
    required this.maintenance,
  });

  final int total;
  final int online;
  final int offline;
  final int busy;
  final int error;
  final int maintenance;

  factory InstrumentStatusSummary.fromJson(Map<String, dynamic> json) {
    int read(String key) => (json[key] as num?)?.toInt() ?? 0;
    return InstrumentStatusSummary(
      total: read('total'),
      online: read('online'),
      offline: read('offline'),
      busy: read('busy'),
      error: read('error'),
      maintenance: read('maintenance'),
    );
  }
}
