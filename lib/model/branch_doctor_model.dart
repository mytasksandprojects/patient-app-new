class BranchDoctorModel {
  int? userId;
  String? name;
  String? nameAr;
  String? email;
  String? phone;
  int? department;
  String? specialization;
  String? specializationAr;
  int? experienceYears;
  String? profileImage;

  BranchDoctorModel({
    this.userId,
    this.name,
    this.nameAr,
    this.email,
    this.phone,
    this.department,
    this.specialization,
    this.specializationAr,
    this.experienceYears,
    this.profileImage,
  });

  factory BranchDoctorModel.fromJson(Map<String, dynamic> json) {
    return BranchDoctorModel(
      userId: json['user_id'],
      name: "${json['f_name'] ?? ''} ${json['l_name'] ?? ''}".trim(),
      nameAr: json['name_ar'],
      email: json['email'],
      phone: json['phone'],
      department: json['department'],
      specialization: json['specialization'],
      specializationAr: json['specialization_ar'],
      experienceYears: json['ex_year'],
      profileImage: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'name_ar': nameAr,
      'email': email,
      'phone': phone,
      'department': department,
      'specialization': specialization,
      'specialization_ar': specializationAr,
      'experience_years': experienceYears,
      'profile_image': profileImage,
    };
  }
}

class BranchDoctorResponse {
  int? response;
  List<BranchDoctorModel>? data;

  BranchDoctorResponse({
    this.response,
    this.data,
  });

  factory BranchDoctorResponse.fromJson(Map<String, dynamic> json) {
    return BranchDoctorResponse(
      response: json['response'],
      data: json['data'] != null
          ? List<BranchDoctorModel>.from(
              json['data'].map((item) => BranchDoctorModel.fromJson(item)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}
