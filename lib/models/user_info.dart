//앱 이용 사용자 정보 추상화..
class UserInfo {
  String? name;
  String? email;
  String? profileImagePath;

  UserInfo({this.name, this.email, this.profileImagePath});

  //객체의 데이터를 db에 insert sqflite.. Map 으로 만들어서
  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'profileImagePath': profileImagePath};
  }

  //db select, map 으로 전달되어서, map 데이터로 객체 생성..
  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      name: map['name'],
      email: map['email'],
      profileImagePath: map['profileImagePath'],
    );
  }
}
