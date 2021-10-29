class Courses {
  String? id;
  String? indonesia_text;
  String? english_text;
  String? image;
  String? sub_category_id;
  String? get getId => this.id;

  set setId(String? id) => this.id = id;

  get indonesiatext => this.indonesia_text;

  set indonesiatext(value) => this.indonesia_text = value;

  get englishtext => this.english_text;

  set englishtext(value) => this.english_text = value;

  get getImage => this.image;

  set setImage(image) => this.image = image;

  get subcategory_id => this.sub_category_id;

  set subcategory_id(value) => this.sub_category_id = value;

  Courses(this.id, this.indonesia_text, this.english_text, this.image,
      this.sub_category_id);

  Courses.fromJson(Map<String, dynamic> parsedJson) {
    this.id = parsedJson['id'];
    this.indonesia_text = parsedJson['indonesia_text'];
    this.english_text = parsedJson['english_text'];
    this.image = parsedJson['image'];
    this.sub_category_id = parsedJson['sub_category_id'];
  }
}
