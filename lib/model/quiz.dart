class Quiz {
  String? quizzID; 
  String chapter;
  String question;
  List<String> options;
  int answer;

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
      'quizzID':quizzID,
      'chapter': chapter,
      'question': question,
      'options': options,
      'answer': answer,
    };
  }
}
