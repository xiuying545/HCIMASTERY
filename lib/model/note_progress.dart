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


 factory NoteProgress.fromJson(String progressID, Map<String, dynamic> json) {
  return NoteProgress(
    progressID: progressID,  
    studentID: json['studentID'],
    chapterID: json['chapterID'],
    progress: Map<String, String>.from(json['progress']),
  );
}
  Map<String, dynamic> toJson() {
    return {
    
      'studentID': studentID,
      'chapterID': chapterID,
      'progress': progress,
    };
  }
}
