class UserProfile {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String? fcmToken;

  const UserProfile({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.fcmToken,
  });

  factory UserProfile.fromJson(String id, Map<String, dynamic> json) {
    return UserProfile(
      id: id,
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      fcmToken: json['fcmToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'displayName': displayName,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (fcmToken != null) 'fcmToken': fcmToken,
    };
  }
}
