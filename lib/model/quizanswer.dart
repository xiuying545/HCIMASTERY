class QuizAnswer {
  String? answerID; 
  final int userID;
  final int quizzID;
  final String studentAnswer;

  QuizAnswer({
    this.answerID, 
    required this.userID,
    required this.quizzID,
    required this.studentAnswer,
  });


  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'quizzID': quizzID,
      'studentAnswer': studentAnswer,
    };
  }

  factory QuizAnswer.fromJson(Map<String, dynamic> json) {
    return QuizAnswer(
      answerID: json['answerID'], 
      userID: json['userID'],
      quizzID: json['quizzID'],
      studentAnswer: json['studentAnswer'],
    );
  }
}
