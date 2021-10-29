class SubCategory {
  String? id;
  String? name;
  String? image;

  String? get getId => this.id;

  set setId(String? id) => this.id = id;

  get getName => this.name;

  set setName(name) => this.name = name;

  get getImage => this.image;

  set setImage(image) => this.image = image;

  SubCategory(this.id, this.name, this.image);

  SubCategory.fromJson(Map<String, dynamic> parsedJson) {
    this.id = parsedJson['id'];
    this.name = parsedJson['name'];
    this.image = parsedJson['image'];
  }
}
