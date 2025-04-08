import 'dart:async';
import 'package:fyp1/model/note.dart';
import 'package:fyp1/model/note_progress.dart';
import 'package:fyp1/services/note_progress_service.dart';
import 'package:fyp1/services/note_service.dart';
import 'package:fyp1/view_model/base_view_model.dart';

class NoteViewModel extends BaseViewModel {
  final ChapterService _noteService = ChapterService();
  final NoteProgressService _noteProgressService = NoteProgressService();

  List<Chapter> _chapters = [];
  List<Note> _notes = [];
  final Map<String, List<Note>> _notesByChapter = {};
  final List<NoteProgress> _studentProgress = [];
  late String _userId;
  String _chapterId = "";
  final Map<String, Timer> _debounceTimers = {};

  // Getters
  List<Chapter> get chapters => _chapters;
  List<Note> get notes => _notes;
  List<NoteProgress> get studentProgress => _studentProgress;
  String get chapterId => _chapterId;

  @override
  void dispose() {
    for (var timer in _debounceTimers.values) {
      timer.cancel();
    }

    for (var entry in _debounceTimers.entries) {
      saveUpdatedNoteToFirestore(_notesByChapter[entry.key]!, entry.key);
    }
    super.dispose();
  }

  Future<void> setupChapterData(String userId) async {
    _userId = userId;
    if (_chapters.isNotEmpty) return;
    await fetchChapters();
    await fetchProgress();
  }

  Future<void> setupChapterDataAdmin() async {
    if (_chapters.isNotEmpty) return;
    await fetchChapters();
  }

  Future<void> fetchNotesForChapter(String chapterID,
      {bool refresh = false}) async {

    _chapterId = chapterID;
    if (!refresh && _notesByChapter.containsKey(chapterID)) {
      _notes = _notesByChapter[chapterID]!;
      notifyListeners();
      return;
    }
    setLoading(true);
    _notes = await _noteService.getNotesForChapter(chapterID);
    _notes.sort((a, b) => a.order.compareTo(b.order));
    _notesByChapter[chapterID] = _notes;
    setLoading(false);
  }

  Future<void> updateNoteOrder(
      List<Note> updatedNotes, String chapterId) async {
    for (int i = 0; i < updatedNotes.length; i++) {
      _notes[i].order = i;
    }
    _notes = updatedNotes;
    notifyListeners();
    _debounceTimers[chapterId]?.cancel();
    _debounceTimers[chapterId] = Timer(const Duration(seconds: 10),
        () => saveUpdatedNoteToFirestore(updatedNotes, chapterId));
  }

  Future<void> saveUpdatedNoteToFirestore(
      List<Note> updatedNotes, String chapterId) async {
    await _noteService.updateNoteOrder(updatedNotes, chapterId);
  }

  Future<void> fetchChapters() async {
    setLoading(true);
    _chapters = await _noteService.getChapters();
    setLoading(false);
  }

  Future<void> fetchProgress() async {
    setLoading(true);
    List<Future<NoteProgress?>> progressFutures = _chapters
        .map((chapter) =>
            _noteProgressService.getProgress(_userId, chapter.chapterID!))
        .toList();
    _studentProgress
        .addAll((await Future.wait(progressFutures)).whereType<NoteProgress>());
    setLoading(false);
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
              (totalNotes > 0) ? ((completedCount / totalNotes)) : 0.0;
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
    _chapterId = noteProgress.chapterID;
    await _noteProgressService.addOrUpdateProgress(noteProgress);
    int index = _studentProgress
        .indexWhere((progress) => progress.chapterID == noteProgress.chapterID);
    if (index != -1) {
      _studentProgress[index] = noteProgress;
    } else {
      _studentProgress.add(noteProgress);
    }
  }

  Future<Note?> getNoteById(String chapterID, String noteID) async {
    return await tryFunction<Note?>(() async {
      setLoading(true);
      Note? note = await _noteService.getNoteById(chapterID, noteID);
      setLoading(false);
      return note;
    });
  }

  Future<void> addChapter(Chapter chapter) async {
    await tryFunction(() async {
      await _noteService.addChapter(chapter);
      await fetchChapters();
    });
  }

  Future<void> deleteChapter(String chapterID) async {
    await tryFunction(() async {
      await _noteService.deleteChapter(chapterID);
      await fetchChapters();
    });
  }

  Future<void> updateChapterName(
      String chapterID, String newChapterName) async {
    await tryFunction(() async {
      await _noteService.updateChapterName(chapterID, newChapterName);
      await fetchChapters();
    });
  }

  Future<void> addNoteToChapter(String chapterID, Note note) async {
    await tryFunction(() async {
      await _noteService.addNoteToChapter(chapterID, note);
      await fetchNotesForChapter(chapterID, refresh: true);
    });
  }

  Future<void> updateNote(String chapterID, Note note) async {
    await _noteService.updateNote(chapterID, note);
    await fetchNotesForChapter(chapterID, refresh: true);
  }

  Future<void> deleteNote(String chapterID, String noteID) async {
    await tryFunction(() async {
      await _noteService.deleteNote(chapterID, noteID);
      await fetchNotesForChapter(chapterID, refresh: true);
    });
  }
}
