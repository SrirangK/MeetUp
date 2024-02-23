class ChatUser {
  ChatUser({
    required this.image,
    required this.name,
    required this.createdAt,
    required this.id,
    required this.isOnline,
    required this.lastActive,
    required this.pushToken,
    required this.email,
    required this.status,
    required this.interest,
  });
  late  String image;
  late  String name;
  late  String createdAt;
  late  String id;
  late  bool isOnline;
  late  String lastActive;
  late  String pushToken;
  late  String email;
  late  String status;
  late String interest;


  ChatUser.fromJson(Map<String, dynamic> json){
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    id = json['id'] ?? '';
    isOnline = json['is_online'] ?? '';
    lastActive = json['last_active'] ?? '';
    pushToken = json['push_token'] ?? '';
    email = json['email'] ?? '';
    status = json['status'] ?? '';
    interest=json['interest']??'';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['is_online'] = isOnline;
    data['last_active'] = lastActive;
    data['push_token'] = pushToken;
    data['email'] = email;
    data['status'] = status;
    data['interest']=interest;
    return data;
  }
}