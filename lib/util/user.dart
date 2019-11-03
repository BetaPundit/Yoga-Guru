class User {
  static String _email;
  static String _uid;
  static String _displayName;
  static String _photoUrl;

  // User(this.email, this.uid, this.displayName, this.photoUrl);

  void setUser(Map<String, dynamic> map) {
    _email = map['email'];
    _uid = map['uid'];
    _displayName = map['displayName'];
    _photoUrl = map['photoUrl'];
  }

  String get uid => _uid;

  String get email => _email;

  String get displayName => _displayName;

  String get photoUrl => _photoUrl;

  Map<String, String> get getUser {
    return {
      'email': _email,
      'displayName': _displayName,
      'uid': _uid,
      'photoUrl': _photoUrl,
    };
  }
}
