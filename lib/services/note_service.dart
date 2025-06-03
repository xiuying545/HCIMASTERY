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

  Future<int> getNoteCountForChapter(String chapterID) async {
    try {
      AggregateQuerySnapshot query = await _db
          .collection('Chapters')
          .doc(chapterID)
          .collection('Notes')
          .count()
          .get();

      return query.count ?? 0;
    } catch (e) {
      print('Error getting note count: $e');
      return 0;
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

  //update note order
  Future<void> updateNoteOrder(List<Note> notes, String chapterId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    WriteBatch batch = firestore.batch();

    for (int i = 0; i < notes.length; i++) {
      DocumentReference docRef = firestore
          .collection('Chapters')
          .doc(chapterId)
          .collection('Notes')
          .doc(notes[i].noteID);

      batch.update(docRef, {'order': i});
    }

    await batch.commit();
    print("✅ Note order updated successfully!");
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

      QuerySnapshot quizSnapshot = await _db
          .collection('Chapters')
          .doc(chapterID)
          .collection('Quizzes')
          .get();

      for (var doc in quizSnapshot.docs) {
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

  Future<void> addHCIMasteryChaptersContent() async {
  final ChapterService chapterService = ChapterService();

  // ---------------------- Bab 1 ----------------------
  Chapter bab1 = Chapter(
    chapterName: 'Bab 1: Asas Reka Bentuk Interaksi',
    notes: [
      Note(
        title: 'Topik 1.1: Apakah Itu Reka Bentuk Interaksi?',
        content: '''
Reka bentuk interaksi ialah proses mencipta pengalaman pengguna yang membolehkan mereka berinteraksi dengan produk seperti aplikasi, laman web atau sistem.

Contoh aplikasi:
- WhatsApp: Hantar mesej hanya dengan satu klik.
- Instagram: Mudah untuk menyukai dan berkongsi gambar.

Reka bentuk yang baik membantu pengguna dari pelbagai lapisan umur dan kemahiran teknologi.''',
        order: 0,
      ),
      Note(
        title: 'Topik 1.2: Lima Prinsip Reka Bentuk Interaksi',
        content: '''
1. Konsistensi – Susun atur tidak berubah-ubah.
2. Pemerhatian – Fungsi mudah dikenali walaupun pertama kali guna.
3. Boleh Dipelajari – Senang digunakan walaupun sekali guna.
4. Menjangka – Pengguna tahu apa yang akan berlaku selepas klik.
5. Maklum Balas – Aplikasi beri respon selepas tindakan pengguna.

Contoh: WhatsApp, Facebook, TikTok.''',
        order: 1,
      ),
      Note(
        title: 'Topik 1.3: Keperluan Interaksi Manusia dan Komputer',
        content: '''
Interaksi penting kerana:
- Permintaan pasaran yang tinggi
- Meningkatkan produktiviti
- Mengurangkan kos pembangunan dan pembaikan

Contoh: Ikon folder digital = folder fizikal di pejabat.''',
        order: 2,
      ),
    ],
  );

  await chapterService.addChapter(bab1);

  // ---------------------- Bab 2 ----------------------
  Chapter bab2 = Chapter(
    chapterName: 'Bab 2: Reka Bentuk Skrin dan Penilaian Produk',
    notes: [
      Note(
        title: 'Topik 2.1: Proses Reka Bentuk Interaksi',
        content: '''
Langkah-langkah:
1. Mengenal pasti keperluan pengguna
2. Membangun reka bentuk alternatif
3. Membina prototaip
4. Menjalankan penilaian

Contoh aplikasi: Program Mengira Dua Nombor untuk murid.''',
        order: 0,
      ),
      Note(
        title: 'Topik 2.2: Penghasilan Prototaip Paparan Skrin',
        content: '''
Prototaip = gambaran awal produk.

Boleh dihasilkan atas kertas atau perisian seperti Java NetBeans. Gunakan warna pastel, butang mesra pengguna dan tajuk jelas.''',
        order: 1,
      ),
      Note(
        title: 'Topik 2.3: Penilaian Kuantitatif dan Penambahbaikan',
        content: '''
Guna soal selidik Ya/Tidak atau Skala Likert.

Contoh: 95.1% pengguna puas hati dengan Program Mengira Dua Nombor.

Penambahbaikan seperti menukar warna dan susun atur disarankan.''',
        order: 2,
      ),
    ],
  );

  await chapterService.addChapter(bab2);
}

Future<void> predefinedQuizzes() async {
  List<Quiz> predefinedQuizList = [
    // ✅ BAB 1: Asas Reka Bentuk Interaksi (ID: EKQFdEhoLcutidZuRBBX)
    Quiz(
      chapter: "EKQFdEhoLcutidZuRBBX",
      question: 'Apakah tujuan utama antara muka pengguna (UI)?',
      options: [
        'Untuk melakukan pengiraan',
        'Untuk mengurus sumber sistem',
        'Untuk memudahkan interaksi pengguna dengan sistem',
        'Untuk menyimpan data'
      ],
      answer: 2,
    ),
    Quiz(
      chapter: "EKQFdEhoLcutidZuRBBX",
      question: 'Yang manakah contoh antara muka baris arahan?',
      options: ['Microsoft Word', 'Terminal', 'Adobe Photoshop', 'Pelayar Web'],
      answer: 1,
    ),
    Quiz(
      chapter: "EKQFdEhoLcutidZuRBBX",
      question: 'Apa maksud “maklum balas” dalam HCI?',
      options: [
        'Tindak balas pengguna terhadap sistem',
        'Tindak balas sistem terhadap tindakan pengguna',
        'Cadangan reka bentuk daripada pengguna',
        'Hasil ujian pengguna'
      ],
      answer: 1,
    ),
    Quiz(
      chapter: "EKQFdEhoLcutidZuRBBX",
      question: 'Prinsip manakah menekankan kepelbagaian keperluan pengguna?',
      options: ['Kebolehgunaan', 'Kebolehcapaian', 'Pengalaman pengguna', 'Faktor manusia'],
      answer: 1,
    ),
    Quiz(
      chapter: "EKQFdEhoLcutidZuRBBX",
      question: 'Apa itu wireframe dalam reka bentuk UI?',
      options: [
        'Gambaran visual penuh antara muka',
        'Pelan awal antara muka secara ringkas',
        'Reka bentuk akhir aplikasi',
        'Prototaip yang digunakan untuk ujian pengguna'
      ],
      answer: 1,
    ),
    Quiz(
      chapter: "EKQFdEhoLcutidZuRBBX",
      question: 'Jenis ujian manakah melibatkan pemerhatian terhadap pengguna sebenar?',
      options: ['Ujian unit', 'Ujian integrasi', 'Ujian kebolehgunaan', 'Ujian sistem'],
      answer: 2,
    ),
    Quiz(
      chapter: "EKQFdEhoLcutidZuRBBX",
      question: 'Apakah maksud “beban kognitif”?',
      options: [
        'Jumlah maklumat yang boleh diproses oleh pengguna',
        'Usaha fizikal untuk menggunakan sistem',
        'Kesukaran belajar antara muka baharu',
        'Masa yang diambil untuk melengkapkan tugas'
      ],
      answer: 0,
    ),
    Quiz(
      chapter: "EKQFdEhoLcutidZuRBBX",
      question: 'Apa itu “model mental” dalam HCI?',
      options: [
        'Gambaran pengguna tentang bagaimana sistem berfungsi',
        'Reka bentuk fizikal sistem',
        'Struktur dalaman sistem',
        'Dokumentasi sistem perisian'
      ],
      answer: 0,
    ),
    Quiz(
      chapter: "EKQFdEhoLcutidZuRBBX",
      question: 'Prinsip manakah memastikan fungsi penting mudah dicapai?',
      options: ['Hierarki', 'Kebolehlihatan', 'Afodans', 'Konsistensi'],
      answer: 1,
    ),
    Quiz(
      chapter: "EKQFdEhoLcutidZuRBBX",
      question: 'Cara biasa untuk meningkatkan pengalaman pengguna ialah?',
      options: [
        'Menambah kerumitan sistem',
        'Kurangkan maklum balas pengguna',
        'Permudahkan navigasi',
        'Hadkan pilihan pengguna'
      ],
      answer: 2,
    ),

    // ✅ BAB 2: Reka Bentuk Skrin dan Penilaian Produk (Tukar ID sebenar di bawah!)
    Quiz(
      chapter: "UYTe8nJ8BKVv6Rq2D3Yu",
      question: 'Apakah langkah pertama dalam proses reka bentuk interaksi?',
      options: ['Bina prototaip', 'Bangunkan elemen UI', 'Ujian pengguna', 'Kenal pasti keperluan pengguna'],
      answer: 3,
    ),
    Quiz(
      chapter: "UYTe8nJ8BKVv6Rq2D3Yu",
      question: 'Kaedah manakah digunakan untuk mendapatkan maklum balas awal pengguna?',
      options: ['Debugging', 'Tinjauan atau temu bual', 'Ujian unit', 'Pengekodan'],
      answer: 1,
    ),
    Quiz(
      chapter: "UYTe8nJ8BKVv6Rq2D3Yu",
      question: 'Apakah tujuan lakaran reka bentuk alternatif?',
      options: ['Untuk mengelirukan pengguna', 'Untuk tambah masa pembangunan', 'Untuk teroka pelbagai idea reka bentuk', 'Untuk finalkan UI'],
      answer: 2,
    ),
    Quiz(
      chapter: "UYTe8nJ8BKVv6Rq2D3Yu",
      question: 'Contoh prototaip berketepatan rendah ialah...',
      options: ['Laman web interaktif', 'Aplikasi siap kod', 'Lakaran atas kertas', 'Animasi 3D'],
      answer: 2,
    ),
    Quiz(
      chapter: "UYTe8nJ8BKVv6Rq2D3Yu",
      question: 'Apakah yang perlu ada dalam prototaip kalkulator?',
      options: ['Skema pangkalan data', 'Butang Reset dan Keluar', 'Sistem log masuk', 'Tetapan firewall'],
      answer: 1,
    ),
    Quiz(
      chapter: "UYTe8nJ8BKVv6Rq2D3Yu",
      question: 'Apakah yang diukur dalam penilaian kuantitatif?',
      options: ['Suka pengguna', 'Warna UI', 'Metrik statistik kebolehgunaan', 'Animasi UI'],
      answer: 2,
    ),
    Quiz(
      chapter: "UYTe8nJ8BKVv6Rq2D3Yu",
      question: 'Mengapa maklum balas pengguna penting selepas ujian prototaip?',
      options: ['Untuk lancar awal', 'Untuk baiki isu reka bentuk', 'Untuk kecilkan saiz aplikasi', 'Untuk tambah ciri tidak berkaitan'],
      answer: 1,
    ),
    Quiz(
      chapter: "UYTe8nJ8BKVv6Rq2D3Yu",
      question: 'Yang manakah BUKAN komponen paparan UI?',
      options: ['Medan input', 'Butang keluar', 'Suis elektrik', 'Menu operasi'],
      answer: 2,
    ),
    Quiz(
      chapter: "UYTe8nJ8BKVv6Rq2D3Yu",
      question: 'Platform manakah digunakan untuk hasilkan UI dalam Java?',
      options: ['Flutter', 'NetBeans', 'Visual Basic', 'Python IDLE'],
      answer: 1,
    ),
    Quiz(
      chapter: "UYTe8nJ8BKVv6Rq2D3Yu",
      question: 'Berapa orang pengguna yang menilai “Program Mengira Dua Nombor”?',
      options: ['5', '15', '20', '25'],
      answer: 3,
    ),
  ];

  for (Quiz quiz in predefinedQuizList) {
    await addQuizToChapter(quiz.chapter, quiz);
  }
}

}
