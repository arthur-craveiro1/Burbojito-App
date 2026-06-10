import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/instrument.dart';
import '../models/instrument_operation.dart';
import '../models/patient.dart';

/// Centralized HTTP client for the burbojito backend.
///
/// Base URL points to the deployed Django API. All endpoints live under
/// `/api/instruments/` (see backend `urlpatterns`). There is currently no
/// authentication, so requests are sent without an Authorization header.
class ApiService {
  ApiService({
    http.Client? client,
    this.baseUrl = defaultBaseUrl,
  }) : _client = client ?? http.Client();

  static const String defaultBaseUrl = 'https://burbojito.highway-api.com';

  final http.Client _client;
  final String baseUrl;

  static const Duration _timeout = Duration(seconds: 30);

  Map<String, String> get _jsonHeaders => const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    return Uri.parse('$baseUrl$path').replace(
      queryParameters: query?.map((k, v) => MapEntry(k, '$v')),
    );
  }

  // ---------------------------------------------------------------------------
  // Patients (core app)
  // ---------------------------------------------------------------------------

  /// GET /api/patients/
  Future<List<Patient>> listPatients() async {
    final response = await _client
        .get(_uri('/api/patients/'), headers: _jsonHeaders)
        .timeout(_timeout);

    final data = _decodeList(response);
    return data
        .map((e) => Patient.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET `/api/patients/<id>/`
  Future<Patient> getPatient(String patientId) async {
    final response = await _client
        .get(_uri('/api/patients/$patientId/'), headers: _jsonHeaders)
        .timeout(_timeout);

    return Patient.fromJson(_decodeMap(response));
  }

  /// GET `/api/patients/<id>/report/`
  ///
  /// Returns the absolute URL of the patient's report PDF, or null when the
  /// patient has no report yet.
  Future<String?> getPatientReportUrl(String patientId) async {
    final response = await _client
        .get(_uri('/api/patients/$patientId/report/'), headers: _jsonHeaders)
        .timeout(_timeout);

    final decoded = _decodeMap(response);
    return decoded['report_url'] as String?;
  }

  // ---------------------------------------------------------------------------
  // Auth (core app)
  // ---------------------------------------------------------------------------

  /// POST /api/login/
  ///
  /// Returns the raw response map: `{success, message, user, token}`.
  /// The token is a placeholder until the backend ships real JWT.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _client
        .post(
          _uri('/api/login/'),
          headers: _jsonHeaders,
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(_timeout);

    return _decodeMap(response);
  }

  // ---------------------------------------------------------------------------
  // Instruments
  // ---------------------------------------------------------------------------

  /// GET /api/instruments/
  Future<List<Instrument>> listInstruments() async {
    final response = await _client
        .get(_uri('/api/instruments/'), headers: _jsonHeaders)
        .timeout(_timeout);

    final data = _decodeList(response);
    return data
        .map((e) => Instrument.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET `/api/instruments/<id>/`
  Future<Instrument> getInstrument(int instrumentId) async {
    final response = await _client
        .get(_uri('/api/instruments/$instrumentId/'), headers: _jsonHeaders)
        .timeout(_timeout);

    return Instrument.fromJson(_decodeMap(response));
  }

  /// GET /api/instruments/status/summary/
  Future<InstrumentStatusSummary> getStatusSummary() async {
    final response = await _client
        .get(_uri('/api/instruments/status/summary/'), headers: _jsonHeaders)
        .timeout(_timeout);

    return InstrumentStatusSummary.fromJson(_decodeMap(response));
  }

  /// POST /api/instruments/status/update/
  ///
  /// Sent by the local agent/instrument to report its current state.
  Future<Instrument> updateInstrumentStatus({
    required String serialNumber,
    required String status,
    String? ipAddress,
    String? firmwareVersion,
    Map<String, dynamic>? payload,
  }) async {
    final body = <String, dynamic>{
      'serial_number': serialNumber,
      'status': status,
      if (ipAddress != null) 'ip_address': ipAddress,
      if (firmwareVersion != null) 'firmware_version': firmwareVersion,
      if (payload != null) 'payload': payload,
    };

    final response = await _client
        .post(
          _uri('/api/instruments/status/update/'),
          headers: _jsonHeaders,
          body: jsonEncode(body),
        )
        .timeout(_timeout);

    final decoded = _decodeMap(response);
    return Instrument.fromJson(decoded['instrument'] as Map<String, dynamic>);
  }

  // ---------------------------------------------------------------------------
  // Operations
  // ---------------------------------------------------------------------------

  /// POST /api/instruments/operations/receive/
  ///
  /// Submits the data produced after an exam/operation.
  Future<InstrumentOperation> receiveOperation({
    required String serialNumber,
    required String operationId,
    String? patientIdentifier,
    DateTime? startedAt,
    DateTime? finishedAt,
    String? videoFilePath,
    String? pdfResultPath,
    required Map<String, dynamic> data,
    Map<String, dynamic>? result,
  }) async {
    final body = <String, dynamic>{
      'serial_number': serialNumber,
      'operation_id': operationId,
      if (patientIdentifier != null) 'patient_identifier': patientIdentifier,
      if (startedAt != null) 'started_at': startedAt.toIso8601String(),
      if (finishedAt != null) 'finished_at': finishedAt.toIso8601String(),
      if (videoFilePath != null) 'video_file_path': videoFilePath,
      if (pdfResultPath != null) 'pdf_result_path': pdfResultPath,
      'data': data,
      if (result != null) 'result': result,
    };

    final response = await _client
        .post(
          _uri('/api/instruments/operations/receive/'),
          headers: _jsonHeaders,
          body: jsonEncode(body),
        )
        .timeout(_timeout);

    final decoded = _decodeMap(response);
    return InstrumentOperation.fromJson(
      decoded['operation'] as Map<String, dynamic>,
    );
  }

  /// GET /api/instruments/operations/
  ///
  /// Optionally filtered by [serialNumber].
  Future<List<InstrumentOperation>> listOperations({
    String? serialNumber,
  }) async {
    final response = await _client
        .get(
          _uri('/api/instruments/operations/', {
            if (serialNumber != null) 'serial_number': serialNumber,
          }),
          headers: _jsonHeaders,
        )
        .timeout(_timeout);

    final data = _decodeList(response);
    return data
        .map((e) => InstrumentOperation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET `/api/instruments/operations/<operation_id>/`
  Future<InstrumentOperation> getOperation(String operationId) async {
    final response = await _client
        .get(
          _uri('/api/instruments/operations/$operationId/'),
          headers: _jsonHeaders,
        )
        .timeout(_timeout);

    return InstrumentOperation.fromJson(_decodeMap(response));
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _decodeMap(http.Response response) {
    _ensureSuccess(response);
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }

  List<dynamic> _decodeList(http.Response response) {
    _ensureSuccess(response);
    return jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;

    String detail = response.body;
    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is Map && decoded['detail'] != null) {
        detail = decoded['detail'].toString();
      }
    } catch (_) {
      // keep raw body
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: detail,
    );
  }

  void dispose() => _client.close();
}

/// Thrown when the backend responds with a non-2xx status.
class ApiException implements Exception {
  ApiException({required this.statusCode, required this.message});

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
