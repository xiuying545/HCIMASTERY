class NoteProgress {
  String? progressID;  
  final String studentID;     
  final String chapterID;   
  final Map<String, String> progress; 

  NoteProgress({
    this.progressID,
    required this.studentID,
    required this.chapterID,
    required this.progress,
  });


 factory NoteProgress.fromJson({
    required String studentID,
    required String chapterID,
    required Map<String, dynamic> json,
  }) {
    return NoteProgress(
      studentID: studentID,
      chapterID: chapterID,
      progress: Map<String, String>.from(json['progress'] ?? {}),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'progress': progress,
    };
  }
}
