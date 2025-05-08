class QuizAnswer {
  String? answerID; 
  final String userID;
  final String chapterID; 
  final List<String> quizzID;
  final List<int> studentAnswer;

  QuizAnswer({
    this.answerID, 
    required this.userID,
    required this.chapterID, 
    required this.quizzID,
    required this.studentAnswer,
  });

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'chapterID': chapterID, 
      'quizzID': quizzID,
      'studentAnswer': studentAnswer,
    };
  }

  factory QuizAnswer.fromJson(Map<String, dynamic> json) {
    return QuizAnswer(
      answerID: json['answerID'], 
      userID: json['userID'],
      chapterID: json['chapterID'], 
      quizzID: List<String>.from(json['quizzID']), 
      studentAnswer: List<int>.from(json['studentAnswer']), 
    );
  }
}
