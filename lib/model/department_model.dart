class DepartmentModel{
  int? id;
  int? active;
  String? title;
  String? titleAr;
  String? createdAt;
//  String? description;
//  String? image;

  DepartmentModel({
    this.title,
    this.titleAr,
    this.id,
    this.active,
    this.createdAt,
  //  this.image,
  //  this.description
  });
  factory DepartmentModel.fromJson(Map<String,dynamic> json){
    return DepartmentModel(
      title: json['title'],
      titleAr: json['title_ar'],
      active: json['active'],
      createdAt: json['created_at'],
      id:json['id'],
     // description: json['description'],
     // image:json['image'],
    );
  }

}