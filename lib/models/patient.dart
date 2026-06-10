/// Review status shown on the patient card.
///
/// The backend has no such field yet, so it is derived: a patient with a
/// generated `report_pdf` is considered REVISADO, otherwise NOVO.
enum PatientStatus { novo, revisado }

/// Mirrors the backend `Patient` model / `PatientSerializer` (core app).
class Patient {
  Patient({
    required this.name,
    required this.status,
    this.id,
    this.doctor,
    this.date,
    this.dateOfBirth,
    this.age,
    this.visualSiteScore,
    this.isHighRisk = false,
    this.reportPdfUrl,
  });

  final String? id;
  final String name;

  /// Not provided by the backend yet (the doctor lives on `Evaluation`).
  /// Kept so mock data and a future join can fill it.
  final String? doctor;

  /// Registration date (`created_at`).
  final DateTime? date;

  final DateTime? dateOfBirth;
  final int? age;
  final int? visualSiteScore;
  final bool isHighRisk;

  /// Absolute or relative URL to the patient's report PDF, when available.
  final String? reportPdfUrl;

  final PatientStatus status;

  factory Patient.fromJson(Map<String, dynamic> json) {
    final reportPdf = json['report_pdf'] as String?;

    return Patient(
      id: json['id']?.toString(),
      name: json['name'] as String? ?? '',
      date: _parseDate(json['created_at']),
      dateOfBirth: _parseDate(json['date_of_birth']),
      age: (json['age'] as num?)?.toInt(),
      visualSiteScore: (json['visual_site_score'] as num?)?.toInt(),
      isHighRisk: json['is_high_risk'] as bool? ?? false,
      reportPdfUrl: reportPdf,
      status: (reportPdf != null && reportPdf.isNotEmpty)
          ? PatientStatus.revisado
          : PatientStatus.novo,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  /// Initials used for the avatar fallback (e.g. "Helena Martinez" -> "HM").
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
