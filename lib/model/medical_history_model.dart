class MedicalHistoryResponse {
  final String status;
  final String message;
  final MedicalHistoryData data;

  MedicalHistoryResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MedicalHistoryResponse.fromJson(Map<String, dynamic> json) {
    return MedicalHistoryResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: MedicalHistoryData.fromJson(json['data'] ?? {}),
    );
  }
}

class MedicalHistoryData {
  final int patientId;
  final MedicalHistorySummary summary;
  final MedicalHistoryRecords history;

  MedicalHistoryData({
    required this.patientId,
    required this.summary,
    required this.history,
  });

  factory MedicalHistoryData.fromJson(Map<String, dynamic> json) {
    return MedicalHistoryData(
      patientId: json['patient_id'] ?? 0,
      summary: MedicalHistorySummary.fromJson(json['summary'] ?? {}),
      history: MedicalHistoryRecords.fromJson(json['history'] ?? {}),
    );
  }
}

class MedicalHistorySummary {
  final int totalRecords;
  final List<String> recordTypes;
  final int recordTypesCount;

  MedicalHistorySummary({
    required this.totalRecords,
    required this.recordTypes,
    required this.recordTypesCount,
  });

  factory MedicalHistorySummary.fromJson(Map<String, dynamic> json) {
    return MedicalHistorySummary(
      totalRecords: json['total_records'] ?? 0,
      recordTypes: List<String>.from(json['record_types'] ?? []),
      recordTypesCount: json['record_types_count'] ?? 0,
    );
  }
}

class MedicalHistoryRecords {
  final RecordCategory? iris;
  final RecordCategory? lenses;
  final RecordCategory? yagLaser;
  final RecordCategory? retinaLaser;
  final RecordCategory? oculoplastyLaser;
  final RecordCategory? glaucomaLaser;
  final RecordCategory? dilatation;

  MedicalHistoryRecords({
    this.iris,
    this.lenses,
    this.yagLaser,
    this.retinaLaser,
    this.oculoplastyLaser,
    this.glaucomaLaser,
    this.dilatation,
  });

  factory MedicalHistoryRecords.fromJson(Map<String, dynamic> json) {
    return MedicalHistoryRecords(
      iris: json['iris'] != null ? RecordCategory.fromJson(json['iris']) : null,
      lenses: json['lenses'] != null ? RecordCategory.fromJson(json['lenses']) : null,
      yagLaser: json['yag_laser'] != null ? RecordCategory.fromJson(json['yag_laser']) : null,
      retinaLaser: json['retina_laser'] != null ? RecordCategory.fromJson(json['retina_laser']) : null,
      oculoplastyLaser: json['oculoplasty_laser'] != null ? RecordCategory.fromJson(json['oculoplasty_laser']) : null,
      glaucomaLaser: json['glaucoma_laser'] != null ? RecordCategory.fromJson(json['glaucoma_laser']) : null,
      dilatation: json['dilatation'] != null ? RecordCategory.fromJson(json['dilatation']) : null,
    );
  }

  List<RecordCategory> getAllCategories() {
    return [
      if (iris != null) iris!,
      if (lenses != null) lenses!,
      if (yagLaser != null) yagLaser!,
      if (retinaLaser != null) retinaLaser!,
      if (oculoplastyLaser != null) oculoplastyLaser!,
      if (glaucomaLaser != null) glaucomaLaser!,
      if (dilatation != null) dilatation!,
    ];
  }
}

class RecordCategory {
  final int count;
  final List<MedicalRecord> records;

  RecordCategory({
    required this.count,
    required this.records,
  });

  factory RecordCategory.fromJson(Map<String, dynamic> json) {
    return RecordCategory(
      count: json['count'] ?? 0,
      records: (json['records'] as List<dynamic>?)
          ?.map((record) => MedicalRecord.fromJson(record))
          .toList() ?? [],
    );
  }
}

class MedicalRecord {
  final int id;
  final int patientId;
  final String recordType;
  final String? createdAt;
  final String? updatedAt;
  final String? createdAtFormatted;
  final String? updatedAtFormatted;
  final Map<String, dynamic> data;

  MedicalRecord({
    required this.id,
    required this.patientId,
    required this.recordType,
    this.createdAt,
    this.updatedAt,
    this.createdAtFormatted,
    this.updatedAtFormatted,
    required this.data,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    // Extract common fields
    Map<String, dynamic> data = Map<String, dynamic>.from(json);
    data.remove('id');
    data.remove('patient_id');
    data.remove('record_type');
    data.remove('created_at');
    data.remove('updated_at');
    data.remove('created_at_formatted');
    data.remove('updated_at_formatted');
    data.remove('patient');

    return MedicalRecord(
      id: json['id'] ?? 0,
      patientId: json['patient_id'] ?? 0,
      recordType: json['record_type'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      createdAtFormatted: json['created_at_formatted'],
      updatedAtFormatted: json['updated_at_formatted'],
      data: data,
    );
  }

  // Helper methods to get specific data fields
  String? get complaint => data['complaint'];
  String? get remarks => data['remarks'];
  String? get managementPlanComment => data['management_plan_comment'];
  String? get transcribedText => data['transcribed_text'];
  String? get comment => data['comment'];

  // IOP (Intraocular Pressure) fields
  String? get iopAirPuffLeft => data['iop_air_puff_left'];
  String? get iopAirPuffRight => data['iop_air_puff_right'];
  String? get iopAppLeft => data['iop_app_left'];
  String? get iopAppRight => data['iop_app_right'];

  // Visual Acuity fields
  String? get ucvaRight => data['ucva_right'];
  String? get bcvaLeft => data['bcva_left'];
  String? get bcvaRight => data['bcva_right'];

  // Autorefraction fields
  String? get arSphereLeft => data['ar_sphere_left'];
  String? get arSphereRight => data['ar_sphere_right'];
  String? get arCylinderLeft => data['ar_cylinder_left'];
  String? get arCylinderRight => data['ar_cylinder_right'];
  String? get arAxisLeft => data['ar_axis_left'];
  String? get arAxisRight => data['ar_axis_right'];

  // Anterior segment fields
  String? get antSegRadio2Right => data['ant_seg_radio2_right'];
  String? get antSegRadio2Left => data['ant_seg_radio2_left'];
}
