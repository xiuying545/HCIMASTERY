import 'package:flutter/material.dart';
import 'package:fyp1/model/note.dart';
import 'package:fyp1/model/note_progress.dart';
import 'package:fyp1/services/note_progress_service.dart';
import 'package:fyp1/services/note_service.dart';

class NoteViewModel extends ChangeNotifier {
  final ChapterService _noteService = ChapterService();
  final NoteProgressService _noteProgressService = NoteProgressService();

  List<Chapter> _chapters = [];
  List<Note> _notes = [];

  final List<NoteProgress> _studentProgress = [];
  bool _isLoading = false;
  late String _userId;
  String _chapterId = "";

  // Getters
  List<Chapter> get chapters => _chapters;
  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;
  List<NoteProgress> get studentProgress => _studentProgress;
  String get chapterId => _chapterId;

  Future<void> setupChapterData(String userId) async {
    // _noteService.loadData();
    _userId = userId;
    await fetchChapters();
    await fetchProgress();
  }

  // Fetch all chapters
  Future<void> fetchChapters() async {
    _isLoading = true;
    notifyListeners();
    try {
      _chapters = await _noteService.getChapters();
    } catch (e) {
      print('Error fetching chapters: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProgress() async {
    List<Future<NoteProgress?>> progressFutures = [];
    _isLoading = true;
    for (var chapter in _chapters) {
      if (chapter.chapterID != null) {
        progressFutures
            .add(_noteProgressService.getProgress(_userId, chapter.chapterID!));
      }
    }



    List<NoteProgress?> progressResults = await Future.wait(progressFutures);

    _studentProgress.addAll(progressResults.whereType<NoteProgress>());

    _isLoading = false;
  }

  // Calculate progress for each chapter
  Map<String, double> calculateProgressByChapter() {
    Map<String, double> progressMap = {};

    try {
      for (var chapter in _chapters) {
        double completionRate = 0;
        NoteProgress? studentProgress = _studentProgress.firstWhere(
          (progress) => progress.chapterID == chapter.chapterID,
          orElse: () => NoteProgress(
              studentID: "", chapterID: chapter.chapterID!, progress: {}),
        );

        if (chapter.notes != null) {
          int totalNotes = chapter.notes!.length;
          int completedCount = studentProgress.progress.values
              .where((status) => status == "Completed")
              .length;

          completionRate =
              (totalNotes > 0) ?  ((completedCount / totalNotes)) : 0.0;
          progressMap[chapter.chapterID!] = completionRate;
        } else {
          progressMap[chapter.chapterID!] = 0;
        }
      }
 
    } catch (e) {
      print("Error calculating progress: $e");
    }

    return progressMap;
  }

  Future<void> updateNoteProgress(NoteProgress noteProgress) async {
    try {
      _chapterId = noteProgress.chapterID;
      // Update Firestore or backend service
   
      await _noteProgressService.addOrUpdateProgress(noteProgress);

      // Check if student progress already exists for the same chapter
      int index = _studentProgress.indexWhere(
          (progress) => progress.chapterID == noteProgress.chapterID);

      if (index != -1) {
        // Update existing progress
        _studentProgress[index] = noteProgress;
      } else {
        // Add new progress
        _studentProgress.add(noteProgress);
      }
  
    } catch (e) {
      print("Error updating note progress: $e");
    }
  }

  // Fetch notes for a specific chapter
  Future<void> fetchNotesForChapter(String chapterID) async {
    _isLoading = true;
    notifyListeners();
    try {
      _notes = await _noteService.getNotesForChapter(chapterID);
    } catch (e) {
      print('Error fetching notes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch a specific note by ID
  Future<Note?> getNoteById(String chapterID, String noteID) async {
    _isLoading = true;
    notifyListeners();

    try {
      return await _noteService.getNoteById(chapterID, noteID);
    } catch (e) {
      print('Error fetching note by id: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CRUD operations for chapters
  Future<void> addChapter(Chapter chapter) async {
    try {
      await _noteService.addChapter(chapter);
      await fetchChapters();
    } catch (e) {
      print('Error adding chapters: $e');
      notifyListeners();
    }
  }

  Future<void> deleteChapter(String chapterID) async {
    try {
      await _noteService.deleteChapter(chapterID);
      await fetchChapters();
    } catch (e) {
      print('Error deleting chapters: $e');
      notifyListeners();
    }
  }

  Future<void> updateChapterName(
      String chapterID, String newChapterName) async {
    try {
      await _noteService.updateChapterName(chapterID, newChapterName);
      await fetchChapters();
    } catch (e) {
      print('Error updating chapters name: $e');
      notifyListeners();
    }
  }

  // CRUD operations for notes
  Future<void> addNoteToChapter(String chapterID, Note note) async {
    try {
      await _noteService.addNoteToChapter(chapterID, note);
      await fetchNotesForChapter(chapterID);
    } catch (e) {
      print('Error adding note: $e');
      notifyListeners();
    }
  }

  Future<void> updateNote(String chapterID, Note note) async {
    try {
      await _noteService.updateNote(chapterID, note);
      await fetchNotesForChapter(chapterID);
    } catch (e) {
      print('Error updating note: $e');
      notifyListeners();
    }
  }

  Future<void> deleteNote(String chapterID, String noteID) async {
    try {
      await _noteService.deleteNote(chapterID, noteID);
      await fetchNotesForChapter(chapterID);
    } catch (e) {
      print('Error deleting note: $e');
      notifyListeners();
    }
  }
}
