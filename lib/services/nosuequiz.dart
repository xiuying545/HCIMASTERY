import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp1/model/quiz.dart';

class QuizService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addQuiz(Quiz quiz) async {
    DocumentReference docRef = await _db.collection('Quiz').add(quiz.toJson());
    print('Quiz added with ID: ${docRef.id}'); // Log the ID of the added quiz
  }

  Future<List<Quiz>> getQuizzesByChapter(String chapter) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('Quiz')
          .where("chapter", isEqualTo: chapter)
          .get();

      List<Quiz> quizList = querySnapshot.docs.map((doc) {
        var quizData = Quiz.fromJson(doc.data() as Map<String, dynamic>);

        // Assign the document ID to the quizzID field
        quizData.quizzID = doc.id;

        return quizData;
      }).toList();

      print('Fetched quizzes: ${quizList.length}');
      return quizList;
    } catch (e) {
      print('Error fetching quizzes: $e');
      return [];
    }
  }

  Future<Quiz> getQuizzById(String quizId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _db.collection('Quiz').doc(quizId).get();

      print('Fetched quiz with ID: $quizId');
      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        return Quiz.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      } else {
        print('Quiz not found or data is null.');
        // Return a default Quiz object if not found
        return Quiz(
          quizzID: quizId,
          chapter: 'Default Chapter',
          question: 'Default Question',
          options: ['Option A', 'Option B', 'Option C', 'Option D'],
          answer: 0,
        );
      }
    } catch (e) {
      print('Error fetching quiz: $e');
      // Return a default Quiz object in case of an error
      return Quiz(
        quizzID: quizId,
        chapter: 'Error fetching quiz',
        question: 'Error fetching quiz',
        options: [],
        answer: 0,
      );
    }
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
    await addQuiz(quiz);
  }
}
}
