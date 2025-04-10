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
        return NoteProgress.fromJson(doc.id, doc.data() as Map<String, dynamic>); // ✅ Pass doc.id
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching progress: $e');
    }
  }

  Future<void> addOrUpdateProgress(NoteProgress progress) async {
    try {
      await _db
          .collection('Note Progress')
          .doc(progress.studentID)
          .collection('chapters')
          .doc(progress.chapterID)
          .set(progress.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error adding/updating progress: $e');
    }
  }
}
