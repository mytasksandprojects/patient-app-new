class AppointmentCategoryResponse {
  final bool? success;
  final List<AppointmentCategory>? data;
  AppointmentCategoryResponse({ this.success,  this.data});
  factory AppointmentCategoryResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentCategoryResponse(
      success: json['success'],
      data: List<AppointmentCategory>.from(
          json['data'].map((x) => AppointmentCategory.fromJson(x))),
    );
  }
}
class AppointmentCategory {
    final int? id;
  final String? label;
  final String ?labelAr;
  final List<AppointmentType>? types;
  final DateTime? createdAt;
  final DateTime? updatedAt;
   double? fee;
  final bool? isAvailable;
  AppointmentCategory({
      this.id,
     this.label,
     this.labelAr,
     this.types,
    this.createdAt,
    this.updatedAt,
     this.isAvailable,
    this.fee, });

  factory AppointmentCategory.fromJson(Map<String, dynamic> json) {
    return AppointmentCategory(
      id: json['id'],
      label: json['label'],
      labelAr: json['label_ar'],
       fee: json['price']!=null?double.parse(json['price']):0.0,
      types: List<AppointmentType>.from(
          json['types'].map((x) => AppointmentType.fromJson(x))),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
                isAvailable: json['is_available'] ?? false,

    );
  }
}

class AppointmentType {
  final int? id;
  final int ?appointmentCategoryId;
  final String? label;
  final String ?labelAr;
  final String ?color;

  AppointmentType({
     this.id,
     this.appointmentCategoryId,
     this.label,
     this.labelAr,
     this.color,
  });

  factory AppointmentType.fromJson(Map<String, dynamic> json) {
    return AppointmentType(
      id: json['id'],
      appointmentCategoryId: json['appointment_category_id'],
      label: json['label'],
      labelAr: json['label_ar'],
      color: json['color'],
    );
  }
  
}