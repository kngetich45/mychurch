class CommentsModel {
  final int? id, mediaId, date, replies, edited,totalCount;
  final String? email, name, profile;
  String? content;

  CommentsModel({
    this.id,
    this.mediaId,
    this.email,
    this.name,
    this.content,
    this.date,
    this.replies,
    this.edited, 
    this.profile,
    this.totalCount
  });

  factory CommentsModel.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    int mediaId = int.parse(json['media_id'].toString());
    int date = int.parse(json['date'].toString());
    int replies = int.parse(json['replies'].toString());
    int edited = int.parse(json['edited'].toString());
    int totalCount = int.parse(json['total_count'].toString());
    return CommentsModel(
      id: id,
      email: json['email'] as String?,
      name: json['name'] as String?,
      content: json['content'] as String?,
      date: date,
      mediaId: mediaId,
      replies: replies,
      edited: edited, 
      totalCount: totalCount, 
      profile: json['profile'] as String?,
    );
  }

  factory CommentsModel.fromJson2(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    int mediaId = int.parse(json['post_id'].toString());
    int date = int.parse(json['date'].toString());
    int replies = int.parse(json['replies'].toString());
    int edited = int.parse(json['edited'].toString());
      int totalCount = int.parse(json['total_count'].toString());
    return CommentsModel(
      id: id,
      email: json['email'] as String?,
      name: json['name'] as String?,
      content: json['content'] as String?,
      date: date,
      mediaId: mediaId,
      replies: replies,
      edited: edited, 
      totalCount: totalCount, 
      profile: json['profile'] as String?,
    );
  }

  factory CommentsModel.fromMap(Map<String, dynamic> data) {
    return CommentsModel(
      id: data['id'],
      email: data['email'],
      name: data['name'],
      content: data['thumbnail'],
      date: data['date'],
      mediaId: data['media_id'],
      replies: data['replies'],
      edited: data['edited'], 
      profile: data['profile'],
     totalCount: data['total_count'],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "name": name,
        "content": content,
        "date": date,
        "mediaId": mediaId,
        "replies": replies,
        "edited": edited, 
        "profile": profile,
      };
}
