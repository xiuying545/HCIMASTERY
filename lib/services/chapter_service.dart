import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp1/model/note.dart';
import 'package:fyp1/model/quiz.dart';

class ChapterService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Update the chapter name in Firestore
  Future<void> updateChapterName(
      String chapterID, String newChapterName) async {
    try {
      await _db.collection('Chapters').doc(chapterID).update({
        'chapterName': newChapterName,
      });
      print('Chapter name updated for chapter ID: $chapterID');
    } catch (e) {
      print('Error updating chapter name: $e');
      rethrow;
    }
  }

  // Add a new chapter
  Future<void> addChapter(Chapter chapter) async {
    try {
      DocumentReference chapterRef = await _db.collection('Chapters').add({
        'chapterName': chapter.chapterName,
      });

      // Add notes under the newly created chapter
      for (Note note in chapter.notes) {
        await _db
            .collection('Chapters')
            .doc(chapterRef.id)
            .collection('Notes')
            .add(note.toJson());
      }

      print('Chapter added with ID: ${chapterRef.id}');
    } catch (e) {
      print('Error adding chapter: $e');
    }
  }

  Future<Note?> getNoteById(String chapterID, String noteID) async {
    try {
      DocumentSnapshot noteSnapshot = await _db
          .collection('Chapters')
          .doc(chapterID)
          .collection('Notes')
          .doc(noteID)
          .get();

      if (noteSnapshot.exists) {
        var noteData = noteSnapshot.data() as Map<String, dynamic>;
        return Note.fromJson(noteData);
      } else {
        print('Note with ID $noteID not found');
        return null;
      }
    } catch (e) {
      print('Error fetching note by ID: $e');
      return null;
    }
  }

  // // Get all chapters
  // Future<List<Chapter>> getChapters() async {
  //   try {
  //     QuerySnapshot querySnapshot = await _db.collection('Chapters').get();
  //     List<Chapter> chapterList = [];

  //     for (var doc in querySnapshot.docs) {
  //       var chapterData = doc.data() as Map<String, dynamic>;
  //       String chapterID = doc.id;
  //       List<Note> notes = await getNotesForChapter(chapterID);

  //       chapterList.add(Chapter(
  //         chapterID: chapterID,
  //         chapterName: chapterData['chapterName'],
  //         notes: notes,
  //       ));
  //     }

  //     print('Fetched chapters: ${chapterList.length}');
  //     return chapterList;
  //   } catch (e) {
  //     print('Error fetching chapters: $e');
  //     return [];
  //   }
  // }

  Future<List<Chapter>> getChapters() async {
  try {
    QuerySnapshot querySnapshot = await _db.collection('Chapters').get();
    List<Chapter> chapterList = [];

    for (var doc in querySnapshot.docs) {
      var chapterData = doc.data() as Map<String, dynamic>;
      String chapterID = doc.id;

      // Only fetch the chapter name (no notes)
      chapterList.add(Chapter(
        chapterID: chapterID,
        chapterName: chapterData['chapterName'],
        notes: [], // Empty list since we're not fetching notes
      ));
    }

    print('Fetched chapter names: ${chapterList.length}');
    return chapterList;
  } catch (e) {
    print('Error fetching chapter names: $e');
    return [];
  }
}

// Get all notes for a specific chapter
  Future<List<Note>> getNotesForChapter(String chapterID) async {
    try {
      QuerySnapshot noteSnapshot = await _db
          .collection('Chapters')
          .doc(chapterID)
          .collection('Notes')
          .get();

      List<Note> noteList = noteSnapshot.docs.map((doc) {
        var noteData = Note.fromJson(doc.data() as Map<String, dynamic>);
        noteData.noteID = doc.id; // Assign Firestore-generated document ID
        return noteData;
      }).toList();

      print('Fetched notes for chapter $chapterID: ${noteList.length}');
      return noteList;
    } catch (e) {
      print('Error fetching notes for chapter $chapterID: $e');
      return [];
    }
  }

  // Add a new note under a specific chapter
  Future<void> addNoteToChapter(String chapterID, Note note) async {
    try {
      await _db
          .collection('Chapters')
          .doc(chapterID)
          .collection('Notes')
          .add(note.toJson());
      print('Note added to chapter $chapterID');
    } catch (e) {
      print('Error adding note to chapter $chapterID: $e');
    }
  }

  // Update an existing note
  Future<void> updateNote(String chapterID, Note note) async {
    try {
      await _db
          .collection('Chapters')
          .doc(chapterID)
          .collection('Notes')
          .doc(note.noteID)
          .update(note.toJson());
      print('Note updated with ID: ${note.noteID}');
    } catch (e) {
      print('Error updating note: $e');
    }
  }

  // Delete a note
  Future<void> deleteNote(String chapterID, String noteID) async {
    try {
      await _db
          .collection('Chapters')
          .doc(chapterID)
          .collection('Notes')
          .doc(noteID)
          .delete();
      print('Note deleted with ID: $noteID');
    } catch (e) {
      print('Error deleting note: $e');
    }
  }

  // Delete a chapter (including its notes)
  Future<void> deleteChapter(String chapterID) async {
    try {
      // First, delete all notes under the chapter
      QuerySnapshot noteSnapshot = await _db
          .collection('Chapters')
          .doc(chapterID)
          .collection('Notes')
          .get();

      for (var doc in noteSnapshot.docs) {
        await doc.reference.delete();
      }

      // Then delete the chapter itself
      await _db.collection('Chapters').doc(chapterID).delete();
      print('Chapter deleted with ID: $chapterID');
    } catch (e) {
      print('Error deleting chapter: $e');
    }
  }

  Future<void> loadData() async {
    List<Chapter> hciChapters = [
      Chapter(
        chapterID: "chapter1",
        chapterName: "Introduction to HCI",
        notes: [
          Note(
            noteID: "note1",
            title: "What is HCI?",
            content:
                "Human-Computer Interaction (HCI) focuses on designing user-centered systems by understanding user needs, capabilities, and limitations.",
          ),
          Note(
            noteID: "note2",
            title: "Goals of HCI",
            content:
                "The main goals of HCI are to improve usability, enhance user experience, and ensure accessibility for all users.",
          ),
          Note(
            noteID: "note3",
            title: "HCI and Interaction Design",
            content:
                "HCI is closely linked to interaction design, which focuses on creating meaningful and intuitive interactions between users and systems.",
          ),
        ],
      ),
      Chapter(
        chapterID: "chapter2",
        chapterName: "HCI Design Principles",
        notes: [
          Note(
            noteID: "note1",
            title: "Usability Principles",
            content:
                "Usability principles, such as learnability, efficiency, and satisfaction, are core to HCI design.",
          ),
          Note(
            noteID: "note2",
            title: "Norman’s Design Principles",
            content:
                "Don Norman's design principles include feedback, constraints, affordances, and mapping to create effective interfaces.",
          ),
          Note(
            noteID: "note3",
            title: "Cognitive Load in HCI",
            content:
                "Minimizing cognitive load helps users process information efficiently and reduces errors.",
          ),
        ],
      ),
      Chapter(
        chapterID: "chapter3",
        chapterName: "HCI Evaluation Techniques",
        notes: [
          Note(
            noteID: "note1",
            title: "Usability Testing",
            content:
                "Usability testing involves observing users interact with a system to identify usability issues.",
          ),
          Note(
            noteID: "note2",
            title: "Heuristic Evaluation",
            content:
                "Heuristic evaluation uses predefined heuristics to identify usability flaws in interfaces.",
          ),
          Note(
            noteID: "note3",
            title: "Surveys and Feedback",
            content:
                "Surveys and user feedback are crucial for understanding user satisfaction and collecting suggestions for improvement.",
          ),
        ],
      ),
    ];

    for (var note in hciChapters) {
      await addChapter(note);
    }
  }

   Future<void> addQuizToChapter(String chapterID, Quiz quiz) async {
    try {
      await _db
          .collection('Chapters')
          .doc(chapterID)
          .collection('Quizzes')
          .add(quiz.toJson());
      print('Quiz added to chapter $chapterID');
    } catch (e) {
      print('Error adding quiz to chapter $chapterID: $e');
    }
  }

  // Update an existing quiz
  Future<void> updateQuiz(String chapterID, String quizID, Quiz quiz) async {
    try {
      await _db
          .collection('Chapters')
          .doc(chapterID)
          .collection('Quizzes')
          .doc(quizID)
          .update(quiz.toJson());
      print('Quiz updated with ID: $quizID');
    } catch (e) {
      print('Error updating quiz: $e');
    }
  }

  // Delete a quiz
  Future<void> deleteQuiz(String chapterID, String quizID) async {
    try {
      await _db
          .collection('Chapters')
          .doc(chapterID)
          .collection('Quizzes')
          .doc(quizID)
          .delete();
      print('Quiz deleted with ID: $quizID');
    } catch (e) {
      print('Error deleting quiz: $e');
    }
  }

  // Fetch all quizzes for a specific chapter
  Future<List<Quiz>> getQuizzesByChapter(String chapterID) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('Chapters')
          .doc(chapterID)
          .collection('Quizzes')
          .get();

      List<Quiz> quizList = querySnapshot.docs.map((doc) {
        var quizData = Quiz.fromJson(doc.data() as Map<String, dynamic>);
        quizData.quizzID = doc.id; // Assign Firestore-generated document ID
        return quizData;
      }).toList();

      print('Fetched quizzes for chapter $chapterID: ${quizList.length}');
      return quizList;
    } catch (e) {
      print('Error fetching quizzes for chapter $chapterID: $e');
      return [];
    }
  }

  // Fetch a specific quiz by its ID
  Future<Quiz?> getQuizById(String chapterID, String quizID) async {
    try {
      DocumentSnapshot quizSnapshot = await _db
          .collection('Chapters')
          .doc(chapterID)
          .collection('Quizzes')
          .doc(quizID)
          .get();

      if (quizSnapshot.exists) {
        var quizData = quizSnapshot.data() as Map<String, dynamic>;
        return Quiz.fromJson(quizData);
      } else {
        print('Quiz with ID $quizID not found');
        return null;
      }
    } catch (e) {
      print('Error fetching quiz by ID: $e');
      return null;
    }
  }

  // Predefined quizzes to load into the database
  Future<void> predefinedQuizzes() async {
    List<Quiz> predefinedQuizList = [
      Quiz(
        chapter: "1tVIMjWSBHWuKDGQLWIA",
        question: 'What is the main purpose of a user interface?',
        options: [
          'To perform calculations',
          'To manage system resources',
          'To facilitate user interaction with the system',
          'To store data'
        ],
        answer: 2,
      ),
      Quiz(
        chapter: "1tVIMjWSBHWuKDGQLWIA",
        question: 'Which of the following is an example of a command line interface?',
        options: [
          'Microsoft Word',
          'Terminal',
          'Adobe Photoshop',
          'Web Browser'
        ],
        answer: 1,
      ),
      // More predefined quizzes...
    ];

    for (Quiz quiz in predefinedQuizList) {
      await addQuizToChapter(quiz.chapter, quiz);
    }
  }
}
