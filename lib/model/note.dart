class Note {
  String? noteID;        
  final String title;       
  final String content;     
  final List<String>? images;      
  final List<String>? videoLink;   

  Note({
    this.noteID,
    required this.title,
    required this.content,
    this.images,
   this.videoLink,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      noteID: json['noteID'],
      title: json['title'] as String,
      content: json['content'] as String,
     images: List<String>.from(json['images'] ?? []),
      videoLink: List<String>.from(json['videoLink'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'noteID': noteID,
      'title': title,
      'content': content,
      'images': images,
      'videoLink': videoLink,
    };
  }
}

class Chapter {
  String? chapterID;        
  final String chapterName;    
  final List<Note> notes;      // List of Note objects directly

  Chapter({
    this.chapterID,
    required this.chapterName,
    required this.notes,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterID: json['chapterID'],
      chapterName: json['chapterName'] as String,
      notes: (json['notes'] as List<dynamic>)
          .map((note) => Note.fromJson(note as Map<String, dynamic>))
          .toList(), // Convert List of maps to List of Note objects
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapterID': chapterID,
      'chapterName': chapterName,
      'notes': notes.map((note) => note.toJson()).toList(), // Convert List of Note objects to List of maps
    };
  }
}
