class HymnsCategoryModel {
  final int id;
  final String title, thumbnail;

  HymnsCategoryModel({required this.id, required this.title, required this.thumbnail});
 

  factory HymnsCategoryModel.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return HymnsCategoryModel(
        id: id,
        title: json['name'],
        thumbnail: json['thumbnail']);
  }

  factory HymnsCategoryModel.fromMap(Map<String, dynamic> data) {
    return HymnsCategoryModel(
        id: data['id'],
        title: data['name'],
        thumbnail: data['thumbnail'] );
  }

  Map<String, dynamic> toMap() =>
      {"id": id, "title": title, "thumbnail": thumbnail};
}
