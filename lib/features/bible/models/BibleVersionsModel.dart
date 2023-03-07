class BibleVersionsModel {
  final int? id;
  final String? name, code;
  final String? description, source;

  BibleVersionsModel({this.id, this.name, this.code, this.description, this.source});
  static const String TABLE = "versions";
  static final columns = ["id", "name", "code", "description"];

  factory BibleVersionsModel.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return BibleVersionsModel(
        id: id,
        name: json['name'] as String?,
        code: json['shortcode'] as String?,
        description: json['description'] as String?,
        source: json['source'] as String?);
  }

  factory BibleVersionsModel.fromMap(Map<String, dynamic> data) {
    return BibleVersionsModel(
        id: data['id'],
        name: data['name'],
        description: data['description'],
        code: data['code'],
        source: "");
  }

  Map<String?, dynamic> toMap() => {
        "id": id,
        "name": name,
        "code": code,
        "description": description,
        source: ""
      };
}
