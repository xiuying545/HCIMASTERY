import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp1/model/note.dart';

class NoteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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

  // Get all chapters
  Future<List<Chapter>> getChapters() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('Chapters').get();
      List<Chapter> chapterList = [];

      for (var doc in querySnapshot.docs) {
        var chapterData = doc.data() as Map<String, dynamic>;
        String chapterID = doc.id;
        List<Note> notes = await getNotesForChapter(chapterID);

        chapterList.add(Chapter(
          chapterID: chapterID,
          chapterName: chapterData['chapterName'],
          notes: notes,
        ));
      }

      print('Fetched chapters: ${chapterList.length}');
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
  Future<void> updateNote(String chapterID, String noteID, Note note) async {
    try {
      await _db
          .collection('Chapters')
          .doc(chapterID)
          .collection('Notes')
          .doc(noteID)
          .update(note.toJson());
      print('Note updated with ID: $noteID');
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
}
