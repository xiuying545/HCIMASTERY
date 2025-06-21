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
          chapterName: chapterData['chapterName'] ?? "Something went wrong",
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
      chapterName: 'Asas Reka Bentuk Interaksi',
      notes: [
        Note(
          title: 'Pengenalan kepada Reka Bentuk Interaksi',
          content: '''
🖥️ Reka bentuk interaksi ialah proses merancang antara muka pengguna (UI) supaya penggunaan sistem menjadi mudah, efisien dan menyeronokkan.

📌 Komponen utama:
📐 Reka bentuk merujuk kepada susun atur elemen seperti teks, gambar dan butang dalam skrin sistem
🤝 Interaksi merujuk kepada cara pengguna melakukan tindakan seperti menekan butang, meleret skrin atau memasukkan data

🎯 Kepentingan reka bentuk interaksi:
👀 Menarik perhatian pengguna dengan reka bentuk yang moden dan kemas
😌 Memberi keselesaan dan kepuasan kepada pengguna sepanjang penggunaan
🔁 Galakkan pengguna terus menggunakan aplikasi secara berulang kerana pengalaman positif
📈 Meningkatkan kadar penggunaan aplikasi dan sokongan pengguna dalam jangka panjang

📱 Contoh aplikasi mesra pengguna:
💬 WhatsApp: Komunikasi cepat dan ringkas
📸 Instagram: Paparan visual yang menarik dan navigasi mudah
🍟 Kiosk McDonald’s: Tempahan tanpa bantuan staf, sesuai untuk semua golongan

🧩 Dunia sebenar:
⬆️ Butang lif direka agar mudah ditekan oleh orang tua atau OKU
🏧 ATM yang memberi mesej “Sila tunggu” atau “Sila ambil kad anda” memberi kepastian kepada pengguna''',
          order: 0,
        ),
        Note(
          
          title: 'Lima Prinsip Reka Bentuk Interaksi',
          content: '''
✅ 5 prinsip utama dalam reka bentuk interaksi berkualiti:

1️⃣ Konsistensi
🧭 Pastikan elemen sentiasa berada di lokasi yang sama untuk elakkan kekeliruan
📘 Contoh: Butang tutup (X) sentiasa di penjuru kanan atas pada sistem Windows

2️⃣ Pemerhatian (Visibility)
👁️ Elemen penting seperti ikon dan butang mesti kelihatan jelas supaya mudah dikenali
📝 Contoh: Ikon Like dan Comment di Facebook yang mudah difahami oleh semua peringkat umur

3️⃣ Boleh Dipelajari (Learnability)
📚 Sistem harus senang difahami walaupun kali pertama digunakan
📱 Contoh: Pengguna WhatsApp biasanya boleh memahami fungsi utama hanya dalam beberapa minit

4️⃣ Kebolehan Menjangka (Predictability)
🔮 Pengguna dapat menjangka hasil tindakan sebelum klik sesuatu elemen
📎 Contoh: Menekan ikon "Share" akan memaparkan pilihan perkongsian

5️⃣ Maklum Balas (Feedback)
💬 Sistem perlu memberikan tindak balas selepas pengguna melakukan tindakan supaya mereka tahu sistem berfungsi
📤 Contoh: “Borang dihantar dengan berjaya” selepas tekan butang Submit

🌟 Semua prinsip ini perlu digabungkan dalam reka bentuk untuk menjamin pengalaman pengguna yang positif, mudah dan selesa.
''',
          order: 1,
        ),
        Note(
          title: 'Keperluan Interaksi Manusia dan Komputer',
          content: '''
👨‍💻 Dahulu hanya pakar boleh guna komputer. Sekarang, semua lapisan masyarakat menggunakan komputer, maka reka bentuk sistem mesti mesra pengguna.

📌 Mengapa interaksi manusia-komputer penting?
🚀 Permintaan pasaran terhadap sistem yang mudah dan tahan lama semakin meningkat
⚡ Reka bentuk yang baik meningkatkan produktiviti kerana pengguna tidak perlu belajar lama
☎️ Reka bentuk yang mesra pengguna mengurangkan kos bantuan dan sokongan teknikal
🧱 Reka bentuk awal yang jelas mengelakkan penambahan fungsi tidak perlu yang membazir kos
📱 Reka bentuk interaktif membuka peluang untuk memperluas pengalaman pengguna seperti dalam e-wallet, sistem tempahan dan pembelajaran
🌐 Sistem sekarang juga membolehkan pengguna berinteraksi antara satu sama lain (pengkomputeran sosial)

📊 Penilaian sistem boleh dilakukan melalui soal selidik (Skala Likert / Guttman) bagi menilai aspek kefahaman, visual dan maklum balas

🧪 Contoh dunia sebenar:
📂 Ikon folder dalam komputer membantu pengguna memahami fungsi seperti menyimpan dokumen
🏧 ATM tanpa mesej atau bunyi boleh menyebabkan pengguna keliru sama ada transaksi berjaya atau tidak
''',
          order: 2,
        ),
      ],
    );

    await chapterService.addChapter(bab1);

    // ---------------------- Bab 2 ----------------------
    Chapter bab2 = Chapter(
      chapterName: 'Reka Bentuk Skrin dan Penilaian Produk',
      notes: [
        Note(
          title: 'Proses Reka Bentuk Interaksi',
          content: '''
📲 Reka bentuk interaksi membolehkan aplikasi lebih mudah digunakan dan berkesan.

📌 Empat langkah utama:

1️⃣ Mengenal pasti keperluan pengguna
🎯 Siapa pengguna? Masalah yang ingin diselesaikan? Apa fungsi yang mereka perlukan?
📋 Kaedah seperti soal selidik, pemerhatian dan temu bual boleh digunakan

2️⃣ Membangunkan reka bentuk alternatif
✏️ Beberapa lakaran dibuat untuk paparan yang berbeza
📐 Reka bentuk dibandingkan dari segi susun atur, warna dan fungsi
🖼️ Contoh: storyboard, wireframe, lukisan tangan

3️⃣ Membina prototaip interaksi
📄 Prototip ialah gambaran awal aplikasi yang boleh diuji
💻 Boleh dibina menggunakan alat seperti Figma, Canva, PowerPoint atau NetBeans
👥 Pengguna sasaran boleh memberi komen selepas mencuba

4️⃣ Membuat penilaian
📋 Penilaian dilakukan dengan analisis tingkah laku pengguna, soal selidik atau kaedah A/B testing
📈 Penambahbaikan dilakukan berdasarkan data yang dikumpul

🔁 Proses ini diulang sehingga reka bentuk terbaik diperoleh

''',
          order: 0,
        ),
        Note(
          title: 'Penghasilan Prototaip Paparan Skrin',
          content: '''
🎯 Prototaip ialah model awal reka bentuk paparan skrin yang digunakan untuk tunjuk aliran sistem dan mendapatkan maklum balas awal.

📌 Kepentingan prototaip:
💬 Uji konsep dan reka bentuk sebelum kod sebenar dibina
🪞 Lihat paparan dan susunan sebenar sistem
🎨 Ubah warna, saiz ikon atau butang sebelum muktamadkan

📐 Alat popular untuk bina prototaip:
🖼️ Figma – reka bentuk interaktif dan boleh klik
📊 PowerPoint – sesuai untuk lakaran susun atur
🎨 Canva – alat reka bentuk visual yang mudah digunakan pelajar

📝 Langkah umum bina prototaip:
1️⃣ Buat lakaran aliran pengguna berdasarkan fungsi
2️⃣ Lukis skrin berdasarkan aktiviti utama pengguna
3️⃣ Letakkan komponen penting seperti butang, label dan kotak input
4️⃣ Uji bersama pengguna sasaran untuk dapatkan maklum balas
5️⃣ Analisis komen pengguna dan baiki reka bentuk jika perlu
6️⃣ Sediakan versi akhir untuk dibangunkan oleh pembangun sistem

📈 Kelebihan prototaip:
⚡ Cepat dan murah untuk diuji
💰 Jimat masa pembangunan
📣 Dapat sokongan awal daripada pihak berkepentingan (stakeholder)

🎓 Pelajar boleh belajar banyak perkara melalui proses bina prototaip seperti empati pengguna, logik susun atur dan kefahaman interaksi asas.
''',
          order: 1,
        ),
        Note(
          title: 'Penilaian Kuantitatif dan Penambahbaikan',
          content: '''
📊 Penilaian kuantitatif menggunakan data dan statistik untuk menilai keberkesanan sesuatu reka bentuk sistem.

📋 Elemen yang biasa dinilai:
🎨 Warna dan ikon – adakah menarik dan sesuai
📍 Navigasi – mudah atau memeningkan
🔠 Bahasa – senang faham atau terlalu teknikal
🔘 Fungsi butang – adakah memberi respon atau tidak

📌 Contoh instrumen:
📈 Skala Likert dari 1 hingga 5 (Sangat Tidak Setuju hingga Amat Setuju)
✅ Soalan Ya atau Tidak
⏱️ Ujian masa – berapa lama pengguna siapkan sesuatu tugas

📈 Contoh dapatan penilaian:
🧪 95% pengguna faham fungsi butang utama
🎨 87% pengguna suka tema warna pastel
📘 75% minta tambahan panduan atau ikon bantuan

🔧 Penambahbaikan berdasarkan dapatan:
🎛️ Tukar butang kepada dropdown / toggle jika terlalu banyak pilihan
📚 Tambah tutorial ringkas semasa kali pertama buka aplikasi
🎨 Gunakan kombinasi warna yang lembut dan tidak mencolok
🧠 Letakkan ikon bantuan kecil untuk pengguna baru

🌟 Penilaian kuantitatif penting untuk menjadikan aplikasi lebih baik dari masa ke masa dan kekal relevan dengan keperluan pengguna sebenar.
''',
          order: 2,
        ),
      ],
    );

    await chapterService.addChapter(bab2);
  }

  Future<void> predefinedQuizzes() async {
    List<Quiz> predefinedQuizList = [
      // ✅ BAB 1: Asas Reka Bentuk Interaksi (ID: uclPBPs29jlu69ghUziE)
      Quiz(
        chapter: "uclPBPs29jlu69ghUziE",
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
        chapter: "uclPBPs29jlu69ghUziE",
        question: 'Yang manakah contoh antara muka baris arahan?',
        options: [
          'Microsoft Word',
          'Terminal',
          'Adobe Photoshop',
          'Pelayar Web'
        ],
        answer: 1,
      ),
      Quiz(
        chapter: "uclPBPs29jlu69ghUziE",
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
        chapter: "uclPBPs29jlu69ghUziE",
        question: 'Prinsip manakah menekankan kepelbagaian keperluan pengguna?',
        options: [
          'Kebolehgunaan',
          'Kebolehcapaian',
          'Pengalaman pengguna',
          'Faktor manusia'
        ],
        answer: 1,
      ),
      Quiz(
        chapter: "uclPBPs29jlu69ghUziE",
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
        chapter: "uclPBPs29jlu69ghUziE",
        question:
            'Jenis ujian manakah melibatkan pemerhatian terhadap pengguna sebenar?',
        options: [
          'Ujian unit',
          'Ujian integrasi',
          'Ujian kebolehgunaan',
          'Ujian sistem'
        ],
        answer: 2,
      ),
      Quiz(
        chapter: "uclPBPs29jlu69ghUziE",
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
        chapter: "uclPBPs29jlu69ghUziE",
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
        chapter: "uclPBPs29jlu69ghUziE",
        question: 'Prinsip manakah memastikan fungsi penting mudah dicapai?',
        options: ['Hierarki', 'Kebolehlihatan', 'Afodans', 'Konsistensi'],
        answer: 1,
      ),
      Quiz(
        chapter: "uclPBPs29jlu69ghUziE",
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
        chapter: "opjtGlgnqBU4GaxqdOSG",
        question: 'Apakah langkah pertama dalam proses reka bentuk interaksi?',
        options: [
          'Bina prototaip',
          'Bangunkan elemen UI',
          'Ujian pengguna',
          'Kenal pasti keperluan pengguna'
        ],
        answer: 3,
      ),
      Quiz(
        chapter: "opjtGlgnqBU4GaxqdOSG",
        question:
            'Kaedah manakah digunakan untuk mendapatkan maklum balas awal pengguna?',
        options: [
          'Debugging',
          'Tinjauan atau temu bual',
          'Ujian unit',
          'Pengekodan'
        ],
        answer: 1,
      ),
      Quiz(
        chapter: "opjtGlgnqBU4GaxqdOSG",
        question: 'Apakah tujuan lakaran reka bentuk alternatif?',
        options: [
          'Untuk mengelirukan pengguna',
          'Untuk tambah masa pembangunan',
          'Untuk teroka pelbagai idea reka bentuk',
          'Untuk finalkan UI'
        ],
        answer: 2,
      ),
      Quiz(
        chapter: "opjtGlgnqBU4GaxqdOSG",
        question: 'Contoh prototaip berketepatan rendah ialah...',
        options: [
          'Laman web interaktif',
          'Aplikasi siap kod',
          'Lakaran atas kertas',
          'Animasi 3D'
        ],
        answer: 2,
      ),
      Quiz(
        chapter: "opjtGlgnqBU4GaxqdOSG",
        question: 'Apakah yang perlu ada dalam prototaip kalkulator?',
        options: [
          'Skema pangkalan data',
          'Butang Reset dan Keluar',
          'Sistem log masuk',
          'Tetapan firewall'
        ],
        answer: 1,
      ),
      Quiz(
        chapter: "opjtGlgnqBU4GaxqdOSG",
        question: 'Apakah yang diukur dalam penilaian kuantitatif?',
        options: [
          'Suka pengguna',
          'Warna UI',
          'Metrik statistik kebolehgunaan',
          'Animasi UI'
        ],
        answer: 2,
      ),
      Quiz(
        chapter: "opjtGlgnqBU4GaxqdOSG",
        question:
            'Mengapa maklum balas pengguna penting selepas ujian prototaip?',
        options: [
          'Untuk lancar awal',
          'Untuk baiki isu reka bentuk',
          'Untuk kecilkan saiz aplikasi',
          'Untuk tambah ciri tidak berkaitan'
        ],
        answer: 1,
      ),
      Quiz(
        chapter: "opjtGlgnqBU4GaxqdOSG",
        question: 'Yang manakah BUKAN komponen paparan UI?',
        options: [
          'Medan input',
          'Butang keluar',
          'Suis elektrik',
          'Menu operasi'
        ],
        answer: 2,
      ),
      Quiz(
        chapter: "opjtGlgnqBU4GaxqdOSG",
        question: 'Platform manakah digunakan untuk hasilkan UI dalam Java?',
        options: ['Flutter', 'NetBeans', 'Visual Basic', 'Python IDLE'],
        answer: 1,
      ),
      Quiz(
        chapter: "opjtGlgnqBU4GaxqdOSG",
        question:
            'Berapa orang pengguna yang menilai “Program Mengira Dua Nombor”?',
        options: ['5', '15', '20', '25'],
        answer: 3,
      ),
    ];

    for (Quiz quiz in predefinedQuizList) {
      await addQuizToChapter(quiz.chapter, quiz);
    }
  }
}
