class Category {
  String? id;
  String? name;
  String? image;
  int? is_complete;
  int? get iscomplete => this.is_complete;

  set iscomplete(int? value) => this.is_complete = value;

  String? get getId => this.id;

  set setId(String? id) => this.id = id;

  get getName => this.name;

  set setName(name) => this.name = name;

  get getImage => this.image;

  set setImage(image) => this.image = image;

  Category({this.id, this.name, this.image});

  Category.fromJson(Map<String, dynamic> parsedJson) {
    this.id = parsedJson['id'];
    this.name = parsedJson['name'];
    this.image = parsedJson['image'];
    this.is_complete = parsedJson['is_complete'];
  }

  Category.finishedJson(Map<String, dynamic> parsedJson) {
    this.id = parsedJson['category_id'];
  }
}
