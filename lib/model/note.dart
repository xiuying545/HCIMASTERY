import 'package:fyp1/model/quiz.dart';

class Note {
  String? noteID;
  final String title;
  final String content;
  final List<String>? images;
  final List<String>? videoLink;
   int order;

  Note({
    this.noteID,
    required this.title,
    required this.content,
    this.images,
    this.videoLink,
    required this.order,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      noteID: json['noteID'],
      title: json['title'] as String,
      content: json['content'] as String,
      order : json ['order'] as int,
      images: List<String>.from(json['images'] ?? []),
      videoLink: List<String>.from(json['videoLink'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'images': images,
      'order' : order,
      'videoLink': videoLink,
    };
  }
}

class Chapter {
  String? chapterID;
   String chapterName;
  List<Note>? notes;
  List<Quiz>? quizzes;

  Chapter(
      {this.chapterID, required this.chapterName, this.notes, this.quizzes});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterID: json['chapterID'],
      chapterName: json['chapterName'] as String,
      notes: (json['notes'] as List<dynamic>)
          .map((note) => Note.fromJson(note as Map<String, dynamic>))
          .toList(),
      quizzes: (json['quizzes'] as List<dynamic>)
          .map((quiz) => Quiz.fromJson(quiz as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapterID': chapterID,
      'chapterName': chapterName,
      'notes': notes?.map((note) => note.toJson()).toList(),
      'quizzes': quizzes?.map((quiz) => quiz.toJson()).toList(),
    };
  }
}
