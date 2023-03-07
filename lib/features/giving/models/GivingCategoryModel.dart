class GivingCategoryModel {
  final int id;
  final String title, thumbnail;

  GivingCategoryModel({required this.id, required this.title, required this.thumbnail});
 

  factory GivingCategoryModel.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return GivingCategoryModel(
        id: id,
        title: json['name'],
        thumbnail: json['thumbnail']);
  }

  factory GivingCategoryModel.fromMap(Map<String, dynamic> data) {
    return GivingCategoryModel(
        id: data['id'],
        title: data['name'],
        thumbnail: data['thumbnail'] );
  }

  Map<String, dynamic> toMap() =>
      {"id": id, "title": title, "thumbnail": thumbnail};
}
