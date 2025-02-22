import 'package:flutter/material.dart';

import 'package:fyp1/model/note.dart';
import 'package:fyp1/model/noteProgress.dart';
import 'package:fyp1/services/noteProgress_service.dart';
import 'package:fyp1/services/note_service.dart';

class NoteViewModel extends ChangeNotifier {
  final NoteService _noteService = NoteService();
  final NoteProgressService _noteProgressService = NoteProgressService();

  List<Chapter> _chapters = [];
  List<Note> _notes = [];
  final Map<String, Map<String, String>> _studentProgress = {};
  bool _isLoadingChapters = false;
  bool _isLoadingNotes = false;
  bool _isLoading = false;
  Map<String, double> progressMap = {};
  String? _errorMessage;

  // Getters
  List<Chapter> get chapters => _chapters;
  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;
  bool get isLoadingChapters => _isLoadingChapters;
  bool get isLoadingNotes => _isLoadingNotes;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  Map<String, Map<String, String>> get studentProgress => _studentProgress;

  // Helper method for fetching data
  Future<void> _performFetch<T>(
      Future<T> fetchOperation, void Function(T) onSuccess) async {
    try {
      final result = await fetchOperation;
      onSuccess(result);
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      notifyListeners();
    }
  }

  // Fetch all chapters
  Future<void> fetchChapters() async {
    _isLoadingChapters = true;
    _errorMessage = null;
    notifyListeners();

    await _performFetch(
      _noteService.getChapters(),
      (data) => _chapters = data,
    );

    _isLoadingChapters = false;
  }

  // Fetch notes for a specific chapter
  Future<void> fetchNotesForChapter(String chapterID) async {
    _isLoadingNotes = true;
    _errorMessage = null;
    notifyListeners();

    await _performFetch(
      _noteService.getNotesForChapter(chapterID),
      (data) => _notes = data,
    );

    _isLoadingNotes = false;
  }

   Future<Note?> getNoteById(String chapterID, String noteID) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final note = await _noteService.getNoteById(chapterID, noteID);
      return note;
    } catch (e) {
      _errorMessage = 'Error fetching note: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<NoteProgress> fetchStudentProgress(
      String studentID, String chapterID) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      NoteProgress? noteProgress =
          await _noteProgressService.getProgress(studentID, chapterID);

      noteProgress ??= NoteProgress(
        studentID: studentID,
        chapterID: chapterID,
        progress: {},
      );

      const defaultValue = 'Not Started';
      for (final note in notes) {
        noteProgress.progress[note.noteID!] ??= defaultValue;
      }
      
      noteProgress.progress["quiz"]??=defaultValue;

      return noteProgress;
    } catch (error) {
      _errorMessage = error.toString();
      return NoteProgress(
        studentID: studentID,
        chapterID: chapterID,
        progress: {},
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add or update student progress for a specific chapter
  Future<void> addOrUpdateStudentProgress(NoteProgress progress) async {
    try {
      await _noteProgressService.addOrUpdateProgress(progress);
      _studentProgress[progress.studentID] ??= {};
      _studentProgress[progress.studentID]?[progress.chapterID] =
          progress.progress.toString();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add/update student progress: $e';
      notifyListeners();
    }
  }

  // Add a new chapter
  Future<void> addChapter(Chapter chapter) async {
    try {
      await _noteService.addChapter(chapter);
      await fetchChapters();
    } catch (e) {
      _errorMessage = 'Error adding chapter: $e';
      notifyListeners();
    }
  }

  // Add a new note to a chapter
  Future<void> addNoteToChapter(String chapterID, Note note) async {
    try {
      await _noteService.addNoteToChapter(chapterID, note);
      await fetchNotesForChapter(chapterID);
    } catch (e) {
      _errorMessage = 'Error adding note: $e';
      notifyListeners();
    }
  }

  // Update an existing note
  Future<void> updateNote(String chapterID, Note note) async {
    try {
      await _noteService.updateNote(chapterID,  note);
      await fetchNotesForChapter(chapterID);
    } catch (e) {
      _errorMessage = 'Error updating note: $e';
      notifyListeners();
    }
  }

  // Delete a note from a chapter
  Future<void> deleteNote(String chapterID, String noteID) async {
    try {
      await _noteService.deleteNote(chapterID, noteID);
      await fetchNotesForChapter(chapterID);
    } catch (e) {
      _errorMessage = 'Error deleting note: $e';
      notifyListeners();
    }
  }

  // Delete a chapter (including its notes)
  Future<void> deleteChapter(String chapterID) async {
    try {
      await _noteService.deleteChapter(chapterID);
      await fetchChapters();
    } catch (e) {
      _errorMessage = 'Error deleting chapter: $e';
      notifyListeners();
    }
  }

  // Calculate progress for a chapter
  Future<double> calculateProgressByChapter(String chapterID) async {
    try {
      final progress = await _noteProgressService.getProgress("1", chapterID);
      final notes = await _noteService.getNotesForChapter(chapterID);

      if (progress == null || notes.isEmpty) return 0.0;

      int completedCount = notes
          .where((note) => progress.progress[note.noteID] == "Completed")
          .length;

      return completedCount / notes.length;
    } catch (e) {
      _errorMessage = 'Error calculating progress: $e';
      notifyListeners();
      return 0.0;
    }
  }

  // Load data
  Future<void> loadData() async {
    try {
      await _noteService.loadData();
      _noteProgressService.addSampleProgressData();
    } catch (e) {
      _errorMessage = 'Error loading initial data: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<void> calculateAllProgress() async {
    for (var chapter in chapters) {
      if (chapter.chapterID != null) {
        // Use the chapterID only if it is not null
        progressMap[chapter.chapterID!] =
            await calculateProgressByChapter(chapter.chapterID!);
      }
    }
  }
}
