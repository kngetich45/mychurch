class GroupMessageModel {
  final int? id, chatId;
  final String? messageContent,messageType,time,userName,phoneNo; 
  bool? isSent,isRead;

  GroupMessageModel(
      {this.id,
      this.chatId,
      this.userName,
      this.phoneNo,
      this.messageContent,
      this.messageType,
      this.isSent,
      this.isRead,
      this.time});

  factory GroupMessageModel.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return GroupMessageModel(
      id: id,
      chatId:json['chatId'] as int?,
      messageContent: json['messageContent'] as String?,
      userName: json['userName'] as String?,
      phoneNo: json['phoneNo'] as String?,
      messageType: json['messageType'] as String?,
      isSent: json['isSent'] as bool?,
      isRead: json['isRead'] as bool?,
      time: json['time'] as String?
    );
  }
}