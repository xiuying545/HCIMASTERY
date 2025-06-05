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
      title: 'Topik 1.1: Pengenalan kepada Reka Bentuk Interaksi',
      content: '''
Reka bentuk interaksi ialah proses merancang antara muka dan pengalaman pengguna supaya manusia dapat berinteraksi dengan sistem seperti aplikasi, laman web atau mesin dengan mudah, efisien dan menyeronokkan.

Reka bentuk = Susun atur elemen (teks, gambar, butang).  
Interaksi = Tindakan pengguna semasa menggunakan sistem.

Mengapa penting?
- Menarik perhatian pengguna
- Memberi keselesaan dan kepuasan
- Mempengaruhi keputusan untuk terus menggunakan sistem

Contoh aplikasi mesra interaksi:
- WhatsApp: Chat mudah dan cepat
- Instagram: Paparan menarik, menu jelas
- Tiket MAS: Sistem tempahan mudah difahami

Contoh dunia sebenar:
- Kiosk pesanan McDonald's membolehkan pesanan pantas tanpa bantuan staf''',
      order: 0,
    ),
    Note(
      title: 'Topik 1.2: Lima Prinsip Reka Bentuk Interaksi',
      content: '''
Reka bentuk interaksi berkualiti mematuhi lima prinsip utama:

1. Konsistensi
   - Elemen UI perlu kekal pada tempat sama.
   - Contoh: Butang "Close" di penjuru kanan atas di Windows.

2. Kebolehan membuat pemerhatian
   - Pengguna mesti boleh kenal pasti butang dan fungsi dengan mudah.
   - Contoh: Butang Like di Facebook.

3. Boleh dipelajari
   - Aplikasi mudah difahami walaupun hanya digunakan sekali.
   - Contoh: WhatsApp – sekali guna, terus tahu fungsi utama.

4. Kebolehan menjangka
   - Pengguna boleh jangka apa akan berlaku sebelum klik.
   - Contoh: Ikon emoji di WhatsApp buka senarai emoji.

5. Maklum balas
   - Sistem perlu beri respon kepada tindakan pengguna.
   - Contoh: Facebook paparkan pilihan selepas klik butang ‘Post’.

Kelima-lima prinsip ini bertindak bersama untuk menjadikan sistem mudah, efisien dan menyeronokkan.

Contoh dunia sebenar:
- Grab menunjukkan maklumat pemandu dan ETA selepas buat tempahan''',
      order: 1,
    ),
    Note(
      title: 'Topik 1.3: Keperluan Interaksi Manusia dan Komputer',
      content: '''
Dulu hanya pakar guna komputer, kini semua orang boleh. Oleh itu, interaksi perlu:
- Mudah
- Intuitif
- Semula jadi

Mengapa penting?

1. Permintaan pasaran tinggi
   - Produk perlu selamat, mesra pengguna dan tahan lama.

2. Meningkatkan produktiviti
   - Sistem mudah digunakan → hasil kerja lebih cepat.

3. Mengurangkan kos selepas jualan
   - Kurang keperluan bantuan pengguna → jimat kos.

4. Mengurangkan kos pembangunan
   - Elakkan ciri tidak perlu yang membazir sumber.

5. Mengembangkan aktiviti & pengalaman pengguna
   - Contoh: E-wallet membantu rekod kewangan secara digital.

6. Pengkomputeran sosial
   - Interaksi dengan manusia lain melalui sistem (contoh: TikTok, WeChat).

Contoh dunia sebenar:
- Ikon folder di komputer: mudah difahami seperti folder sebenar.
- ATM tanpa maklum balas boleh mengelirukan pengguna.

Penilaian produk:
- Guna soal selidik (Skala Likert / Guttman)
- Contoh: Facebook dinilai dari segi maklum balas, kebolehan belajar dan lain-lain.

Soal selidik membantu kenal pasti aspek perlu ditambah baik untuk tingkatkan pengalaman pengguna.''',
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
Dalam dunia moden, aplikasi dan perisian digunakan oleh semua orang. Oleh itu, reka bentuk skrin mestilah mesra pengguna, menarik dan mudah digunakan.

📌 Empat langkah utama dalam proses reka bentuk interaksi:

1. Mengenal pasti keperluan pengguna
- Siapa pengguna?
- Masalah apa yang ingin diselesaikan?
- Fungsi apa yang mereka mahu?
- Kaedah: soal selidik, temu bual, kajian tindakan, maklum balas

2. Membangunkan reka bentuk alternatif
- Lakaran beberapa pilihan reka bentuk
- Contoh: storyboard, lakaran atas kertas, inspirasi dari produk sedia ada
- Diterangkan dari segi konsep (fungsi) dan fizikal (warna, ikon, susunan)

3. Membina prototaip interaksi
- Gambaran awal sistem
- Boleh dilukis tangan atau bina dengan perisian (NetBeans, Figma)
- Diuji oleh pengguna untuk maklum balas

4. Membuat penilaian terhadap reka bentuk
- Ukur keberkesanan sistem berdasarkan tingkah laku pengguna
- Guna penilaian kuantitatif (data) atau heuristik (pengalaman)
- Contoh: navigasi jelas, warna sesuai, respon cepat

🧠 *Kesimpulan:* Reka bentuk interaksi bukan satu proses sekali buat — ia perlu melalui proses berulang sehingga capai hasil terbaik.

Contoh aplikasi: sistem “Program Mengira Dua Nombor” digunakan untuk demonstrasi langkah-langkah ini.
''',
      order: 0,
    ),
    Note(
      title: 'Topik 2.2: Penghasilan Prototaip Paparan Skrin',
      content: '''
Prototaip ialah gambaran awal paparan skrin sebelum produk sebenar dibina. Ia membolehkan pengguna memahami aliran sistem dan memberi maklum balas awal.

📌 Ciri-ciri prototaip:
- Jelas, mudah difahami
- Menunjukkan fungsi sebenar
- Boleh diuji dengan pengguna
- Boleh dibuat atas kertas atau dengan perisian

🎨 Contoh alat: Java NetBeans, PowerPoint, Figma

📋 Langkah membina prototaip dalam NetBeans:
1. Gunakan jForm dan tambah jLabel untuk tajuk dan label input
2. Tambah jTextField untuk data input/output
3. Tambah jButton untuk operasi matematik (+, –, ×, ÷), Reset dan Keluar
4. Sesuaikan warna latar dan teks, guna warna pastel yang sesuai

📊 Contoh:
Program Mengira Dua Nombor
- Dua reka bentuk dilukis, pengguna pilih yang terbaik
- Reka bentuk alternatif dinilai oleh 20 pengguna (guru + murid)
- Maklum balas digunakan untuk penambahbaikan reka bentuk

💬 Komen pengguna:
- Warna kuning terlalu terang → tukar ke kelabu gelap
- Butang “Reset” dan “Keluar” perlu diasingkan
- Tajuk perlu di tengah atas dan teks warna hitam

Prototaip akhir dipilih berdasarkan dapatan penilaian dan ditambah baik sesuai dengan maklum balas.
''',
      order: 1,
    ),
    Note(
      title: 'Topik 2.3: Penilaian Kuantitatif dan Penambahbaikan',
      content: '''
Penilaian kuantitatif ialah proses mengumpul data dari pengguna untuk menilai keberkesanan reka bentuk dari segi angka dan peratusan.

📊 Instrumen penilaian dibina berdasarkan:
- Reka bentuk skrin (warna, susun atur, ikon)
- Navigasi dan interaktiviti
- Kesalahan ejaan, kefahaman bahasa
- Fungsi butang (Reset, Keluar, Operasi)

📋 Contoh skala:
- Skala Likert: 5 (Amat Setuju) hingga 1 (Sangat Tidak Setuju)
- Jawapan Ya / Tidak

🧪 Kajian kes:
Program Mengira Dua Nombor
- Soal selidik diberi kepada 25 pengguna (guru & murid)
- 95.1% pengguna puas hati dengan reka bentuk akhir

💡 Cadangan penambahbaikan:
1. Tambah operasi baru seperti kuasa dua, punca kuasa dua
2. Tukar butang kepada dropdown / radio button
3. Kombinasi warna pastel untuk visual lebih mesra
4. Tambah tutorial ringkas atau ikon bantuan

📈 Penilaian berterusan penting untuk memastikan sistem terus relevan dan memenuhi keperluan pengguna masa kini.

Contoh dunia sebenar:
- Shopee dan Netflix menggunakan penilaian A/B untuk pilih reka bentuk terbaik.
''',
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
