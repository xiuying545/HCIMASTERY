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
      if (chapter.notes != null) {
        for (Note note in chapter.notes!) {
          await _db
              .collection('Chapters')
              .doc(chapterRef.id)
              .collection('Notes')
              .add(note.toJson());
        }
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

  Future<List<Chapter>> getChapters() async {
    try {
      QuerySnapshot chapterSnapshot = await _db.collection('Chapters').get();
      List<Chapter> chapterList = [];

      for (var chapterDoc in chapterSnapshot.docs) {
        var chapterData = chapterDoc.data() as Map<String, dynamic>;
        String chapterID = chapterDoc.id;

        // // Fetch notes for the current chapter
        // List<Note> notes = await getNotesForChapter(chapterID);

        chapterList.add(Chapter(
          chapterID: chapterID,
          chapterName: chapterData['chapterName'],
          notes: [], 
        ));
      }

      print('Fetched chapters with notes: ${chapterList.length}');
      return chapterList;
    } catch (e) {
      print('Error fetching chapters: $e');
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

      print('Fetched quizzes for chapter $chapterID: ${quizList[0].quizzID}');
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

}
