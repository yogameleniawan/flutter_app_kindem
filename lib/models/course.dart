class Courses {
  String? id;
  String? indonesia_text;
  String? english_text;
  String? image;
  String? image_course;

  String? sub_category_id;
  String? sub_name;
  String? sub_image;
  String? category_name;
  String? category_image;

  int? complete;
  int? total;
  int? is_voice;
  int? get isvoice => this.is_voice;

  String? get imagecourse => this.image_course;

  set imagecourse(String? value) => this.image_course = value;

  set isvoice(int? value) => this.is_voice = value;

  get subimage => this.sub_image;

  set subimage(value) => this.sub_image = value;

  get categoryname => this.category_name;

  set categoryname(value) => this.category_name = value;

  get categoryimage => this.category_image;

  set categoryimage(value) => this.category_image = value;
  String? get getName => this.sub_name;

  set setName(String? name) => this.sub_name = name;

  int? get getComplete => this.complete;

  set setComplete(int? complete) => this.complete = complete;

  get getTotal => this.total;

  set setTotal(total) => this.total = total;

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
      this.sub_category_id, this.is_voice);

  Courses.fromJson(Map<String, dynamic> parsedJson) {
    this.id = parsedJson['id'];
    this.indonesia_text = parsedJson['indonesia_text'];
    this.english_text = parsedJson['english_text'];
    this.image = parsedJson['image'];
    this.sub_category_id = parsedJson['sub_category_id'];
    this.is_voice = parsedJson['is_voice'];
    this.image_course = parsedJson['image_course'];
  }

  Courses.choiceAnswer(Map<String, dynamic> parsedJson) {
    this.english_text = parsedJson['english_text'];
  }

  Courses.incompleteCourse(Map<String, dynamic> parsedJson) {
    this.id = parsedJson['id'];
    this.sub_name = parsedJson['sub_name'];
    this.sub_image = parsedJson['sub_image'];
    this.category_name = parsedJson['category_name'];
    this.category_image = parsedJson['category_image'];
    this.sub_category_id = parsedJson['sub_category_id'];
    this.complete = parsedJson['complete'];
    this.total = parsedJson['total'];
    this.image_course = parsedJson['image_course'];
  }
}
