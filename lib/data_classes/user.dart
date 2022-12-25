class UserInfo {
  String? username = '';
  String? email = '';
  List<dynamic>? twinks = [];
  List<dynamic>? likedTwinks = [];
  List<dynamic>? savedTwinks = [];
  List<dynamic>? followers = [];
  List<dynamic>? following = [];
  UserInfo({
    this.username,
    this.email,
    this.twinks,
    this.likedTwinks,
    this.savedTwinks,
    this.followers,
    this.following,
  });

  UserInfo.copy(UserInfo u) {
    username = u.username;
    email = u.email;
    twinks = u.twinks;
    likedTwinks = u.likedTwinks;
    savedTwinks = u.savedTwinks;
    followers = u.followers;
    following = u.following;
  }
}
