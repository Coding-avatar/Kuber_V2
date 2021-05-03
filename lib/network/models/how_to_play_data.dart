class HowToPlayData {
  int pkFAQ;
  String question;
  String answer;

  HowToPlayData({this.pkFAQ, this.question, this.answer});

  HowToPlayData.fromJson(Map<String, dynamic> json) {
    pkFAQ = json['pk_FAQ'];
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pk_FAQ'] = this.pkFAQ;
    data['question'] = this.question;
    data['answer'] = this.answer;
    return data;
  }
}
