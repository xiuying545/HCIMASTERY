import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp1/model/note_progress.dart';

class NoteProgressService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<NoteProgress?> getProgress(String studentID, String chapterID) async {
    try {
      DocumentSnapshot doc = await _db
          .collection('Note Progress')
          .doc(studentID)
          .collection('chapters')
          .doc(chapterID)
          .get();

      if (doc.exists) {
        return NoteProgress.fromJson(
          studentID: studentID,
          chapterID: chapterID,
          json: doc.data() as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching progress: $e');
    }
  }

  Future<void> addOrUpdateProgress(NoteProgress progress) async {
    try {
      final json = progress.toJson();

      await _db
          .collection('Note Progress')
          .doc(progress.studentID)
          .collection('chapters')
          .doc(progress.chapterID)
          .set(json, SetOptions(merge: true));

      await _db.collection('Note Progress').doc(progress.studentID).set(
          {'lastUpdated': FieldValue.serverTimestamp()},
          SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error adding/updating progress: $e');
    }
  }

  Future<void> deleteAllProgressForStudent(String studentID) async {
    try {
      final chaptersRef =
          _db.collection('Note Progress').doc(studentID).collection('chapters');

      final snapshot = await chaptersRef.get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      await _db.collection('Note Progress').doc(studentID).delete();
    } catch (e) {
      throw Exception('Error deleting all progress for student: $e');
    }
  }

  Future<void> deleteProgressForChapter(String chapterID) async {
    try {
      final studentsSnapshot = await _db.collection('Note Progress').get();
      print("Total students found: ${studentsSnapshot.docs.length}");
      for (var studentDoc in studentsSnapshot.docs) {
        final chapterDoc = await _db
            .collection('Note Progress')
            .doc(studentDoc.id)
            .collection('chapters')
            .doc(chapterID)
            .get();

        if (chapterDoc.exists) {
          await chapterDoc.reference.delete();
          print("deleting note progress chapter for ${chapterID}");
        }
      }
    } catch (e) {
      throw Exception('Error deleting progress for chapter: $e');
    }
  }

  Future<void> deleteProgressForChapterNote(
      String chapterID, String noteID) async {
    try {
      final studentsSnapshot = await _db.collection('Note Progress').get();
      print("Total students found: ${studentsSnapshot.docs.length}");

      for (var studentDoc in studentsSnapshot.docs) {
        final chapterRef = _db
            .collection('Note Progress')
            .doc(studentDoc.id)
            .collection('chapters')
            .doc(chapterID);

        final chapterDoc = await chapterRef.get();

        if (chapterDoc.exists) {
          final data = chapterDoc.data() as Map<String, dynamic>;
  
          if (data.containsKey('progress')) {
            final progress = Map<String, dynamic>.from(data['progress']);
       
            if (progress.containsKey(noteID)) {
              progress.remove(noteID);
              await chapterRef.update({'progress': progress});
            }
          }
        }
      }
    } catch (e) {
      throw Exception('Error deleting note progress from chapter: $e');
    }
  }
}
