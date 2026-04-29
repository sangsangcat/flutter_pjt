// 앱 이용 사용자 정보 추상화..
class UserInfo {
  String? name;
  String? email;
  String? profileImagePath;

  UserInfo({this.name, this.email, this.profileImagePath});

  // 현재는 Firebase 환경이지만, 데이터 변환의 일관성을 위해 유지하거나 필요 시 활용합니다.
  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'profileImagePath': profileImagePath};
  }

  // db select, map 으로 전달되어서, map 데이터로 객체 생성..
  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      name: map['name'],
      email: map['email'],
      profileImagePath: map['profileImagePath'],
    );
  }

  // 새로운 객체를 생성하며 특정 필드만 교체할 때 사용 (Immutable 패턴)
  UserInfo copyWith({
    String? name,
    String? email,
    String? profileImagePath,
  }) {
    return UserInfo(
      name: name ?? this.name,
      email: email ?? this.email,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }
}
