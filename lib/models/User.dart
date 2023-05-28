class User {
  String display_name;
  int followers;
  String id;

  User({required this.display_name, required this.followers, required this.id});
  static User fromJason(dynamic json) {
    String name = json["display_name"];
    int followers = json["followers"]["total"];
    String id = json["id"];
    return User(display_name: name, followers: followers, id: id);
  }
}
