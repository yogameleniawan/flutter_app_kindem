class Score {
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
}
