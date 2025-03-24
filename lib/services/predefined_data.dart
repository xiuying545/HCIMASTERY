// import 'package:fyp1/model/note.dart';
// import 'package:fyp1/model/quiz.dart';
// import 'package:fyp1/services/note_service.dart';
//   Future<void> loadData() async {
//   List<Chapter> hciChapters = [
//     Chapter(
//       chapterName: "Reka Bentuk Interaksi",
//       notes: [
//         // Nota 1: Pengenalan kepada Reka Bentuk Interaksi
//         Note(
//           title: "Apa Itu Reka Bentuk Interaksi?",
//           content:
//               "Reka bentuk interaksi merujuk kepada proses mereka bentuk cara pengguna berinteraksi dengan produk atau sistem, seperti aplikasi atau laman web. Ia melibatkan susun atur elemen seperti teks, gambar, butang, dan menu untuk memastikan pengguna dapat berinteraksi dengan mudah dan selesa. Contohnya, antara muka WhatsApp dan Instagram direka dengan paparan yang ringkas dan intuitif. **Tambah Point:** Reka bentuk interaksi juga mengambil kira aspek psikologi pengguna seperti kebiasaan, jangkaan, dan keselesaan.",
//         ),

//         // Nota 2: Prinsip Reka Bentuk Interaksi
//         Note(
//           title: "5 Prinsip Reka Bentuk Interaksi",
//           content:
//               "Terdapat 5 prinsip utama dalam reka bentuk interaksi: (1) **Konsistensi** - elemen serupa berfungsi dengan cara yang sama, (2) **Kebolehan Membuat Pemerhatian** - elemen interaksi mudah dikenal pasti, (3) **Kebolehan Dipelajari** - sistem mudah difahami dan digunakan, (4) **Kebolehan Dijangka** - pengguna boleh meramalkan hasil tindakan mereka, dan (5) **Maklum Balas** - sistem memberikan maklumat tentang hasil tindakan pengguna. **Tambah Point:** Prinsip ini membantu mengurangkan beban kognitif pengguna dan meningkatkan pengalaman pengguna secara keseluruhan.",
//         ),

//         // Nota 3: Proses Reka Bentuk Interaksi
//         Note(
//           title: "4 Langkah dalam Proses Reka Bentuk Interaksi",
//           content:
//               "Proses reka bentuk interaksi terdiri daripada 4 langkah: (1) **Mewujudkan Keperluan** - kenal pasti keperluan pengguna, (2) **Mereka Bentuk Alternatif** - hasilkan beberapa cadangan reka bentuk, (3) **Membina Prototaip** - buat gambaran awal produk untuk dinilai, dan (4) **Membuat Penilaian** - nilai reka bentuk berdasarkan maklum balas pengguna. Contohnya, dalam pembangunan 'Program Mengira Dua Nombor', keperluan pengguna dikenal pasti terlebih dahulu sebelum reka bentuk alternatif dihasilkan. **Tambah Point:** Penglibatan pengguna dalam setiap langkah memastikan produk akhir memenuhi keperluan sebenar mereka.",
//         ),
//       ],
//     ),
//     Chapter(
//       chapterName: "Paparan dan Reka Bentuk Skrin",
//       notes: [
//         // Nota 1: Pengenalan kepada Paparan dan Reka Bentuk Skrin
//         Note(
//           title: "Apa Itu Paparan dan Reka Bentuk Skrin?",
//           content:
//               "Paparan dan reka bentuk skrin adalah elemen penting dalam pembangunan aplikasi atau sistem. Ia melibatkan susun atur teks, butang, menu, dan gambar pada skrin untuk memastikan pengguna dapat berinteraksi dengan mudah dan selesa. Contohnya, antara muka WhatsApp dan Instagram direka dengan paparan yang ringkas dan intuitif, menjadikannya mudah digunakan oleh semua lapisan masyarakat. **Tambah Point:** Reka bentuk skrin yang baik juga mengambil kira faktor aksesibiliti seperti saiz fon, kontras warna, dan susun atur yang mesra pengguna.",
//         ),

//         // Nota 2: Proses Reka Bentuk Interaksi
//         Note(
//           title: "4 Langkah Reka Bentuk Interaksi",
//           content:
//               "Proses reka bentuk interaksi terdiri daripada 4 langkah utama: (1) **Mewujudkan Keperluan** - kenal pasti apa yang pengguna perlukan, (2) **Mereka Bentuk Alternatif** - hasilkan beberapa cadangan reka bentuk, (3) **Membina Prototaip** - buat gambaran awal produk untuk dinilai, dan (4) **Membuat Penilaian** - nilai reka bentuk berdasarkan maklum balas pengguna. Contohnya, dalam pembangunan 'Program Mengira Dua Nombor', keperluan pengguna dikenal pasti terlebih dahulu sebelum reka bentuk alternatif dihasilkan. **Tambah Point:** Penggunaan alat seperti wireframe dan mockup dapat memudahkan proses mereka bentuk alternatif.",
//         ),

//         // Nota 3: Kepentingan Reka Bentuk Skrin
//         Note(
//           title: "Kenapa Reka Bentuk Skrin Penting?",
//           content:
//               "Reka bentuk skrin yang baik memastikan aplikasi atau sistem mudah digunakan, menarik, dan memenuhi keperluan pengguna. Contohnya, mesin ATM dan sistem penempahan tiket tren memerlukan reka bentuk skrin yang intuitif supaya pengguna tidak keliru semasa menggunakannya. Reka bentuk yang baik juga meningkatkan kepuasan pengguna dan mengurangkan kesilapan semasa interaksi. **Tambah Point:** Reka bentuk skrin yang baik juga boleh meningkatkan kadar pengekalan pengguna dan mengurangkan kos sokongan pelanggan.",
//         ),
//       ],
//     ),
//   ];
// //  for (Chapter chapter in hciChapters) {
// //     await addChapter(chapter); // Use the existing addChapter function
// //   }
 
// }

// // Predefined quizzes to load into the database
// Future<void> predefinedQuizzes() async {
//   List<Quiz> predefinedQuizList = [
//     Quiz(
//       chapter: "YVZsodXv0iQ1fkdZ7dhZ",
//       question: 'Apakah yang dimaksudkan dengan reka bentuk interaksi?',
//       options: [
//         'Proses mereka bentuk cara pengguna berinteraksi dengan sistem',
//         'Proses meningkatkan kelajuan sistem',
//         'Proses menambah bilangan ciri dalam sistem',
//         'Proses mengurangkan kos pembangunan'
//       ],
//       answer: 0,
//     ),
//     Quiz(
//       chapter: "YVZsodXv0iQ1fkdZ7dhZ",
//       question: 'Apakah kepentingan reka bentuk interaksi?',
//       options: [
//         'Meningkatkan kelajuan sistem',
//         'Memudahkan interaksi pengguna dengan sistem',
//         'Mengurangkan kos pembangunan',
//         'Menambah bilangan ciri sistem'
//       ],
//       answer: 1,
//     ),
//     Quiz(
//       chapter: "YVZsodXv0iQ1fkdZ7dhZ",
//       question: 'Berapakah prinsip utama dalam reka bentuk interaksi?',
//       options: ['3', '4', '5', '6'],
//       answer: 2,
//     ),
//     Quiz(
//       chapter: "YVZsodXv0iQ1fkdZ7dhZ",
//       question:
//           'Apakah prinsip reka bentuk interaksi yang memastikan elemen serupa berfungsi dengan cara yang sama?',
//       options: [
//         'Kebolehan Dipelajari',
//         'Konsistensi',
//         'Maklum Balas',
//         'Kebolehan Dijangka'
//       ],
//       answer: 1,
//     ),
//     Quiz(
//       chapter: "YVZsodXv0iQ1fkdZ7dhZ",
//       question:
//           'Apakah yang dimaksudkan dengan "kebolehan dipelajari" dalam reka bentuk interaksi?',
//       options: [
//         'Seberapa pantas pengguna boleh melakukan tugas',
//         'Seberapa mudah pengguna baru memahami dan menggunakan sistem',
//         'Bilangan ciri yang terdapat dalam sistem',
//         'Kos pembangunan sistem'
//       ],
//       answer: 1,
//     ),
//     Quiz(
//       chapter: "YVZsodXv0iQ1fkdZ7dhZ",
//       question:
//           'Apakah contoh maklum balas yang baik dalam reka bentuk interaksi?',
//       options: [
//         'Paparan "loading" semasa sistem memproses arahan',
//         'Paparan iklan yang tidak diperlukan',
//         'Tiada maklum balas selepas tindakan pengguna',
//         'Paparan yang terlalu terang'
//       ],
//       answer: 0,
//     ),
//     Quiz(
//       chapter: "YVZsodXv0iQ1fkdZ7dhZ",
//       question: 'Apakah langkah pertama dalam proses reka bentuk interaksi?',
//       options: [
//         'Membina prototaip',
//         'Mewujudkan keperluan pengguna',
//         'Membuat penilaian',
//         'Mereka bentuk alternatif'
//       ],
//       answer: 1,
//     ),
//     Quiz(
//       chapter: "YVZsodXv0iQ1fkdZ7dhZ",
//       question:
//           'Apakah yang dimaksudkan dengan "kebolehan dijangka" dalam reka bentuk interaksi?',
//       options: [
//         'Pengguna boleh meramalkan apa yang akan berlaku selepas tindakan mereka',
//         'Sistem boleh berfungsi tanpa sebarang input pengguna',
//         'Pengguna perlu mempelajari sistem secara mendalam',
//         'Sistem mempunyai banyak ciri yang rumit'
//       ],
//       answer: 0,
//     ),
//     Quiz(
//       chapter: "YVZsodXv0iQ1fkdZ7dhZ",
//       question:
//           'Apakah contoh produk interaktif yang menggunakan reka bentuk skrin yang baik?',
//       options: [
//         'Mesin ATM',
//         'Papan kekunci mekanikal',
//         'Tetikus tanpa wayar',
//         'Pencetak 3D'
//       ],
//       answer: 0,
//     ),
//     Quiz(
//       chapter: "CtGwccnQVc38I9UeX5cb",
//       question: 'Apakah yang dimaksudkan dengan reka bentuk interaksi?',
//       options: [
//         'Proses mereka bentuk cara pengguna berinteraksi dengan sistem',
//         'Proses meningkatkan kelajuan sistem',
//         'Proses menambah bilangan ciri dalam sistem',
//         'Proses mengurangkan kos pembangunan'
//       ],
//       answer: 0,
//     ),
//     Quiz(
//       chapter: "CtGwccnQVc38I9UeX5cb",
//       question:
//           'Apakah contoh aplikasi dengan reka bentuk interaksi yang baik?',
//       options: ['Terminal', 'Instagram', 'Command Prompt', 'Linux Shell'],
//       answer: 1,
//     ),
//     Quiz(
//       chapter: "CtGwccnQVc38I9UeX5cb",
//       question: 'Apakah kepentingan reka bentuk interaksi?',
//       options: [
//         'Meningkatkan kelajuan sistem',
//         'Memudahkan interaksi pengguna dengan sistem',
//         'Mengurangkan kos pembangunan',
//         'Menambah bilangan ciri sistem'
//       ],
//       answer: 1,
//     ),
//     Quiz(
//       chapter: "CtGwccnQVc38I9UeX5cb",
//       question: 'Berapakah prinsip utama dalam reka bentuk interaksi?',
//       options: ['3', '4', '5', '6'],
//       answer: 2,
//     ),
//     Quiz(
//       chapter: "CtGwccnQVc38I9UeX5cb",
//       question:
//           'Apakah prinsip reka bentuk interaksi yang memastikan elemen serupa berfungsi dengan cara yang sama?',
//       options: [
//         'Kebolehan Dipelajari',
//         'Konsistensi',
//         'Maklum Balas',
//         'Kebolehan Dijangka'
//       ],
//       answer: 1,
//     ),
//     Quiz(
//       chapter: "CtGwccnQVc38I9UeX5cb",
//       question:
//           'Apakah yang dimaksudkan dengan "kebolehan dipelajari" dalam reka bentuk interaksi?',
//       options: [
//         'Seberapa pantas pengguna boleh melakukan tugas',
//         'Seberapa mudah pengguna baru memahami dan menggunakan sistem',
//         'Bilangan ciri yang terdapat dalam sistem',
//         'Kos pembangunan sistem'
//       ],
//       answer: 1,
//     ),
//     Quiz(
//       chapter: "CtGwccnQVc38I9UeX5cb",
//       question:
//           'Apakah contoh maklum balas yang baik dalam reka bentuk interaksi?',
//       options: [
//         'Paparan "loading" semasa sistem memproses arahan',
//         'Paparan iklan yang tidak diperlukan',
//         'Tiada maklum balas selepas tindakan pengguna',
//         'Paparan yang terlalu terang'
//       ],
//       answer: 0,
//     ),
//     Quiz(
//       chapter: "CtGwccnQVc38I9UeX5cb",
//       question: 'Apakah langkah pertama dalam proses reka bentuk interaksi?',
//       options: [
//         'Membina prototaip',
//         'Mewujudkan keperluan pengguna',
//         'Membuat penilaian',
//         'Mereka bentuk alternatif'
//       ],
//       answer: 1,
//     ),
//     Quiz(
//       chapter: "CtGwccnQVc38I9UeX5cb",
//       question:
//           'Apakah yang dimaksudkan dengan "kebolehan dijangka" dalam reka bentuk interaksi?',
//       options: [
//         'Pengguna boleh meramalkan apa yang akan berlaku selepas tindakan mereka',
//         'Sistem boleh berfungsi tanpa sebarang input pengguna',
//         'Pengguna perlu mempelajari sistem secara mendalam',
//         'Sistem mempunyai banyak ciri yang rumit'
//       ],
//       answer: 0,
//     ),
//     Quiz(
//       chapter: "CtGwccnQVc38I9UeX5cb",
//       question:
//           'Apakah contoh produk interaktif yang menggunakan reka bentuk skrin yang baik?',
//       options: [
//         'Mesin ATM',
//         'Papan kekunci mekanikal',
//         'Tetikus tanpa wayar',
//         'Pencetak 3D'
//       ],
//       answer: 0,
//     ),
//   ];
//   ChapterService chapterService = ChapterService();
//   for (Quiz quiz in predefinedQuizList) {
//     await chapterService.addQuizToChapter(quiz.chapter, quiz);
//   }
// }
