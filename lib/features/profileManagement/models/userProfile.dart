class UserProfile {
  final String? name;
  final String? userId;
  final String? firebaseId;
  final String? profileUrl;
  final String? email;
  final String? mobileNumber;
  final String? status;
  final String? allTimeScore;
  final String? allTimeRank;
  final String? coins;
  final String? registeredDate;
  final String? referCode;
  final String? fcmToken;
  final String? gender;
  final String? location; 
  final int? activated;
  final String? isPremier; 

  UserProfile({this.email, this.fcmToken, this.referCode, this.firebaseId, this.mobileNumber, this.name, this.profileUrl, this.userId, this.allTimeRank, this.allTimeScore, this.coins, this.registeredDate, this.status,this.gender, this.location, this.activated, this.isPremier});

  static UserProfile fromJson(Map<String, dynamic> jsonData) {
    //torefer keys go profileMan.remoteRepo
    return UserProfile(
        allTimeRank: jsonData['all_time_rank'],
        mobileNumber: jsonData['mobile'],
        name: jsonData['name'],
        profileUrl: jsonData['profile'],
        registeredDate: jsonData['date_registered'],
        status: jsonData['status'],
        userId: jsonData['id'],
        firebaseId: jsonData['firebase_id'],
        allTimeScore: jsonData['all_time_score'],
        coins: jsonData['coins'],
        referCode: jsonData['refer_code'],
        fcmToken: jsonData['fcm_id'],
        email: jsonData['email'],
        gender: jsonData['gender'],
        location: jsonData['location'], 
        activated: jsonData['location'],
        isPremier: jsonData['isPremier']
        );
  }
   
  UserProfile copyWith({String? profileUrl, String? name, String? allTimeRank, String? allTimeScore, String? coins, String? status, String? mobile, String? email, String? gender,String? location, int? activated, String? isPremier}) {
    return UserProfile(
        fcmToken: this.fcmToken,
        userId: this.userId,
        profileUrl: profileUrl ?? this.profileUrl,
        email: email ?? this.email,
        name: name ?? this.name,
        firebaseId: this.firebaseId,
        referCode: this.referCode,
        allTimeRank: allTimeRank ?? this.allTimeRank,
        allTimeScore: allTimeScore ?? this.allTimeScore,
        coins: coins ?? this.coins,
        mobileNumber: mobile ?? this.mobileNumber,
        registeredDate: this.registeredDate,
        status: status ?? this.status,
        gender: gender ?? this.gender,
        location: location ?? this.location,  
        isPremier: isPremier ?? this.isPremier);
  }

  UserProfile copyWithProfileData(String? name, String? mobile, String? email) {
    return UserProfile(
      fcmToken: this.fcmToken,
      referCode: this.referCode,
      userId: this.userId,
      profileUrl: this.profileUrl,
      email: email,
      name: name,
      firebaseId: this.firebaseId,
      allTimeRank: this.allTimeRank,
      allTimeScore: this.allTimeScore,
      coins: this.coins,
      mobileNumber: mobile,
      registeredDate: this.registeredDate,
      status: this.status,
      gender: this.gender,
      location: this.location, 
      activated: this.activated,
       isPremier: this.isPremier
    );
  }

  
  static const String TABLE = "userdata";
  static final columns = [
    "email",
    "name",
    "profileUrl",
    "mobileNumber",
    "userId",
    "firebaseId",
    "status",
    "allTimeScore",
    "allTimeRank",
    "coins",
    "registeredDate",
    "referCode",
    "fcmToken",
    "gender",
    "location",
    "activated",
    "isPremier"
  ];
  factory UserProfile.fromJsonActivated(Map<String, dynamic> json) {
    //print(json);
    return UserProfile(
        allTimeRank: json['all_time_rank']as String?,
        mobileNumber: json['mobile']as String?,
        name: json['name']as String?,
        profileUrl: json['profile']as String?,
        registeredDate: json['date_registered']as String?,
        status: json['status']as String?,
        userId: json['id']as String?,
        firebaseId: json['firebase_id']as String?,
        allTimeScore: json['all_time_score']as String?,
        coins: json['coins']as String?,
        referCode: json['refer_code']as String?,
        fcmToken: json['fcm_id']as String?,
        email: json['email']as String?,
        gender: json['gender'] as String?,
        location: json['location'] as String?, 
        isPremier: json['isPremier'] as String?, 
        activated: 0);
  }

} 