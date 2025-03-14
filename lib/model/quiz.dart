class Quiz {
  String? quizzID;
  String chapter;
  String question;
  List<String> options;
  int answer;
  String? imageUrl;

  Quiz({
    this.quizzID,
    required this.chapter,
    required this.question,
    required this.options,
    required this.answer,
    this.imageUrl,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      quizzID: json['quizzID'],
      chapter: json['chapter'],
      question: json['question'],
      options: List<String>.from(json['options']),
      answer: json['answer'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapter': chapter,
      'question': question,
      'options': options,
      'answer': answer,
      'imageUrl': imageUrl,
    };
  }
}
