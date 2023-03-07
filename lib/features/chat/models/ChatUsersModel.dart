class ChatUsersModel {
  final int id;
  final String name,profileURL,mobile,email,firebaseId; 
  int isPremier;

  ChatUsersModel(
      {required this.id,
      required this.name,
      required this.firebaseId,
      required this.mobile,
      required this.email,
      required this.profileURL, 
      required this.isPremier});
  
  factory ChatUsersModel.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    int isPremier = int.parse(json['isPremier'].toString());
    return ChatUsersModel(
        id: id,
        name: json['name'],
        profileURL: json['profile'],
        isPremier: isPremier,
         email: json['email'],
        firebaseId: json['firebase_id'], 
        mobile: json['mobile']);
  }

  factory ChatUsersModel.fromMap(Map<String, dynamic> json) {
    return ChatUsersModel(
        id: json['id'],
        name: json['name'],
        profileURL: json['profile'],
        isPremier: json['isPremier'],
        email: json['email'],
        firebaseId: json['firebase_id'], 
        mobile: json['mobile']);
  }

  Map<String, dynamic> toMap() =>
      {"id": id, "name": name, "profile": profileURL, "isPremier": isPremier,"email": email, "firebase_id": firebaseId, "mobile": mobile};
      
}