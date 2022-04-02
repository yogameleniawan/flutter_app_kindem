class User {
  int id = 0;
  String name = "";
  String email = "";
  String? photo = "";

  int get getId => this.id;
  set setId(int id) => this.id = id;

  get getName => this.name;
  set setName(name) => this.name = name;

  get getEmail => this.email;
  set setEmail(email) => this.email = email;

  get getPhoto => this.photo;
  set setPhoto(photo) => this.photo = photo;

  User() {}

  User.toString(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    email = data['email'];
    photo = data['profile_photo_path'];
  }

  User.fromJson(Map<String, dynamic> parsedJson) {
    this.id = parsedJson['id'];
    this.name = parsedJson['name'];
    this.email = parsedJson['email'];
    this.photo = parsedJson['profile_photo_path'];
  }
}
