import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp1/model/noteProgress.dart';


class NoteProgressService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;




  Future<NoteProgress?> getProgress(String studentID, String chapterID) async {
    try {

      DocumentSnapshot doc = await _db.collection('Note Progress')
          .doc('$studentID-$chapterID') 
          .get();

      // If the document exists, return the progress
      if (doc.exists) {
        return NoteProgress.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching progress: $e');
    }
  }


  Future<void> addOrUpdateProgress(NoteProgress progress) async {
    try {

      await _db.collection('Note Progress')
          .doc('${progress.studentID}-${progress.chapterID}')  
          .set(progress.toJson(), SetOptions(merge: true)); 
    } catch (e) {
      throw Exception('Error adding/updating progress: $e');
    }
  }
  
void addSampleProgressData() async {
  final noteProgressService = NoteProgressService();


  List<NoteProgress> sampleProgressData = [
    NoteProgress(
      studentID: "1",
      chapterID: "chapter1",
      progress: {
        "note1": "Completed",  
        "note2": "In Progress",  
        "note3": "Not Started",  
      },
    ),
    // Chapter 2 progress
    NoteProgress(
      studentID: "1",
      chapterID: "chapter2",
      progress: {
        "note1": "Completed", 
        "note2": "Completed", 
        "note3": "In Progress",  
      },
    ),
    // Chapter 3 progress
    NoteProgress(
      studentID: "1",
      chapterID: "chapter3",
      progress: {
        "note1": "Not Started",  
        "note2": "In Progress",  
        "note3": "Not Started",  
      },
    ),
    NoteProgress(
      studentID: "1",
      chapterID: "chapter4",
      progress: {
        "note1": "Completed", 
        "note2": "Completed",  
        "note3": "Completed",  
      },
    ),
  ];

  // Add or update progress for each chapter
  for (var progress in sampleProgressData) {
    try {
      await noteProgressService.addOrUpdateProgress(progress);
      print('Progress for Chapter ${progress.chapterID} added/updated successfully.');
    } catch (e) {
      print('Error adding progress for Chapter ${progress.chapterID}: $e');
    }
  }
}
}
