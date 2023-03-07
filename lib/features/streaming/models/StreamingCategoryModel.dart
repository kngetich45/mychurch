class StreamingCategoryModel {
  final int id;
  final String title, thumbnail,streamurl,detail;

  StreamingCategoryModel({required this.id, required this.title,required this.detail,required this.streamurl, required this.thumbnail});
 

  factory StreamingCategoryModel.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return StreamingCategoryModel(
        id: id,
        title: json['title'],
        streamurl: json['stream_url'],
        detail: json['detail'],
        thumbnail: json['thumbnail']);
  }

  factory StreamingCategoryModel.fromMap(Map<String, dynamic> data) {
    return StreamingCategoryModel(
        id: data['id'],
        title: data['title'],
         detail: data['detail'],
           streamurl: data['stream_url'],
        thumbnail: data['thumbnail'] );
  }

  Map<String, dynamic> toMap() =>
      {"id": id, "title": title, "thumbnail": thumbnail};
}
