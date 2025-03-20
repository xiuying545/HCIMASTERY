class QuizAnswer {
  String? answerID; 
  final String userID;
  final String chapter; // Add chapter field
  final List<String> quizzID;
  final List<int> studentAnswer;

  QuizAnswer({
    this.answerID, 
    required this.userID,
    required this.chapter, // Require chapter in constructor
    required this.quizzID,
    required this.studentAnswer,
  });

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'chapter': chapter, // Include chapter in JSON
      'quizzID': quizzID,
      'studentAnswer': studentAnswer,
    };
  }

  factory QuizAnswer.fromJson(Map<String, dynamic> json) {
    return QuizAnswer(
      answerID: json['answerID'], 
      userID: json['userID'],
      chapter: json['chapter'], // Include chapter in fromJson
      quizzID: List<String>.from(json['quizzID']), // Ensure quizzID is a List<String>
      studentAnswer: List<int>.from(json['studentAnswer']), 
    );
  }
}
