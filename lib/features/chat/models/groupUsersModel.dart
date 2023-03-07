class GroupUsersModel {
  final int? id;
  final String? name, messageText,imageURL,time,userName,phoneNo; 
  bool? isRead;

  GroupUsersModel(
      {this.id,
      this.name,
      this.messageText,
      this.imageURL,
       this.userName,
      this.phoneNo,
      this.time,
      this.isRead});

  factory GroupUsersModel.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return GroupUsersModel(
      id: id,
      name: json['name'] as String?,
      messageText: json['messageText'] as String?,
      userName: json['userName'] as String?,
      phoneNo: json['phoneNo'] as String?,
      imageURL: json['imageURL'] as String?,
      time: json['time'] as String?,
      isRead: json['isRead'] as bool?
    );
  }
}