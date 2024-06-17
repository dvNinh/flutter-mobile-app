class UserInfo {
  static UserInfo? _instance;

  String user = '';
  String company = '';
  String job = '';

  static UserInfo get instance {
    _instance ??= UserInfo._internal();
    return _instance!;
  }

  UserInfo._internal();
}
