class GivingModel {
  final int? id;
  final String? title, thumbnail, categoryid, paymenttype, amount, details, mpesa, paypallink;

  GivingModel({this.id, this.title, this.categoryid, this.paymenttype, this.amount, this.details, this.mpesa, this.paypallink, this.thumbnail});

  static const String GIVING_TABLE = "givingbookmarks";
  static final bookmarkscolumns = ["id", "title", "category_id", "payment_type", "amount", "details", "mpesa", "paypal_link", "thumbnail"];

  factory GivingModel.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return GivingModel(
        id: id,
        title: json['title'] as String?,
        thumbnail: json['thumbnail'] as String?,
        categoryid: json['category_id'] as String?,
        paymenttype: json['payment_type'] as String?,
        amount: json['amount'] as String?,
        mpesa: json['mpesa'] as String?,
       details: json['details'] as String?,
        paypallink: json['paypal_link'] as String?); 
  }

  factory GivingModel.fromMap(Map<String, dynamic> data) {
    return GivingModel(
        id: data['id'],
        title: data['title'],
        thumbnail: data['thumbnail'],
        categoryid: data['thumbnail'],
        paymenttype: data['thumbnail'],
        amount: data['thumbnail'],
        mpesa: data['thumbnail'],
        paypallink: data['thumbnail'], 
        details: data['details']);
  }

  Map<String, dynamic> toMap() =>
      {"id": id, "title": title, "thumbnail": thumbnail, "category_id": categoryid, "payment_type": paymenttype, "amount": amount, "paypal_link": paypallink, "mpesa": mpesa, "details": details};
}
