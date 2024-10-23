class Quiz {
  String? quizzID; 
  int chapter;
  String question;
  List<String> options;
  String answer;

  Quiz({
    this.quizzID, 
    required this.chapter,
    required this.question,
    required this.options,
    required this.answer,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      quizzID: json['quizzID'],
      chapter: json['chapter'],
      question: json['question'],
      options: List<String>.from(json['options']),
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapter': chapter,
      'question': question,
      'options': options,
      'answer': answer,
    };
  }
}
