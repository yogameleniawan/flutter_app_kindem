class Score {
  String? id;
  String? score;
  String? user_id;
  String? created_at;
  String? name;
  String? image;
  String? get getId => this.id;

  set setId(String? id) => this.id = id;

  get getScore => this.score;

  set setScore(score) => this.score = score;

  get userid => this.user_id;

  set userid(value) => this.user_id = value;

  get createdat => this.created_at;

  set createdat(value) => this.created_at = value;

  get getName => this.name;

  set setName(name) => this.name = name;

  get getImage => this.image;

  set setImage(image) => this.image = image;
  int is_true = 0;
  int total_test = 0;
  int get istrue => this.is_true;

  set istrue(int value) => this.is_true = value;

  get totaltest => this.total_test;

  set totaltest(value) => this.total_test = value;

  Score() {}

  Score.getScore(Map<String, dynamic> data) {
    is_true = data['is_true'];
    total_test = data['total_test'];
  }

  Score.fromJson(Map<String, dynamic> parsedJson) {
    this.id = parsedJson['id'];
    this.name = parsedJson['name'];
    this.image = parsedJson['image'];
    this.score = parsedJson['score'];
    this.created_at = parsedJson['created_at'];
  }
}
