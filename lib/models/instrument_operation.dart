/// Mirrors the backend `InstrumentOperation` model / `InstrumentOperationSerializer`.
class InstrumentOperation {
  InstrumentOperation({
    required this.operationId,
    this.id,
    this.patientIdentifier,
    this.status,
    this.rawData,
    this.resultData,
    this.videoFilePath,
    this.pdfResultPath,
    this.startedAt,
    this.finishedAt,
    this.receivedAt,
  });

  final int? id;
  final String operationId;
  final String? patientIdentifier;
  final String? status;
  final Map<String, dynamic>? rawData;
  final Map<String, dynamic>? resultData;
  final String? videoFilePath;
  final String? pdfResultPath;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final DateTime? receivedAt;

  factory InstrumentOperation.fromJson(Map<String, dynamic> json) {
    return InstrumentOperation(
      id: json['id'] as int?,
      operationId: json['operation_id'] as String? ?? '',
      patientIdentifier: json['patient_identifier'] as String?,
      status: json['status'] as String?,
      rawData: json['raw_data'] as Map<String, dynamic>?,
      resultData: json['result_data'] as Map<String, dynamic>?,
      videoFilePath: json['video_file_path'] as String?,
      pdfResultPath: json['pdf_result_path'] as String?,
      startedAt: _parseDate(json['started_at']),
      finishedAt: _parseDate(json['finished_at']),
      receivedAt: _parseDate(json['received_at']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
