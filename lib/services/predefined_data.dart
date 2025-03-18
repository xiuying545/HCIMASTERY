import 'package:fyp1/model/note.dart';
import 'package:fyp1/model/quiz.dart';
import 'package:fyp1/services/chapter_service.dart';

Future<void> loadData() async {
  List<Chapter> hciChapters = [
    Chapter(
      chapterName: "Reka Bentuk Interaksi",
      notes: [
        // Nota 1: Pengenalan kepada Reka Bentuk Interaksi
        Note(
          title: "Apa Itu Reka Bentuk Interaksi?",
          content:
              "Reka bentuk interaksi merujuk kepada proses mereka bentuk cara pengguna berinteraksi dengan produk atau sistem, seperti aplikasi atau laman web. Ia melibatkan susun atur elemen seperti teks, gambar, butang, dan menu untuk memastikan pengguna dapat berinteraksi dengan mudah dan selesa. Contohnya, antara muka WhatsApp dan Instagram direka dengan paparan yang ringkas dan intuitif.",
        ),

// Nota 2: Kepentingan Reka Bentuk Interaksi
        Note(
          title: "Kenapa Reka Bentuk Interaksi Penting?",
          content:
              "Reka bentuk interaksi yang baik memastikan produk mudah digunakan, menarik, dan memenuhi keperluan pengguna. Contohnya, mesin ATM dan sistem penempahan tiket tren memerlukan reka bentuk yang intuitif supaya pengguna tidak keliru semasa menggunakannya. Reka bentuk yang baik juga meningkatkan kepuasan pengguna dan mengurangkan kesilapan semasa interaksi.",
        ),

// Nota 3: Prinsip Reka Bentuk Interaksi
        Note(
          title: "5 Prinsip Reka Bentuk Interaksi",
          content:
              "Terdapat 5 prinsip utama dalam reka bentuk interaksi: (1) **Konsistensi** - elemen serupa berfungsi dengan cara yang sama, (2) **Kebolehan Membuat Pemerhatian** - elemen interaksi mudah dikenal pasti, (3) **Kebolehan Dipelajari** - sistem mudah difahami dan digunakan, (4) **Kebolehan Dijangka** - pengguna boleh meramalkan hasil tindakan mereka, dan (5) **Maklum Balas** - sistem memberikan maklumat tentang hasil tindakan pengguna.",
        ),

// Nota 4: Contoh Aplikasi dengan Reka Bentuk Interaksi yang Baik
        Note(
          title: "Contoh Aplikasi dengan Reka Bentuk Interaksi yang Baik",
          content:
              "Contoh aplikasi dengan reka bentuk interaksi yang baik termasuk Instagram, WhatsApp, dan sistem penempahan tiket MAS. Aplikasi ini mempunyai paparan yang ringkas, menu yang mudah difahami, dan memberikan maklum balas yang jelas kepada pengguna. Contohnya, Instagram membolehkan pengguna berkomunikasi dan mengikuti perkembangan isu dengan mudah.",
        ),

// Nota 5: Proses Reka Bentuk Interaksi
        Note(
          title: "4 Langkah dalam Proses Reka Bentuk Interaksi",
          content:
              "Proses reka bentuk interaksi terdiri daripada 4 langkah: (1) **Mewujudkan Keperluan** - kenal pasti keperluan pengguna, (2) **Mereka Bentuk Alternatif** - hasilkan beberapa cadangan reka bentuk, (3) **Membina Prototaip** - buat gambaran awal produk untuk dinilai, dan (4) **Membuat Penilaian** - nilai reka bentuk berdasarkan maklum balas pengguna. Contohnya, dalam pembangunan 'Program Mengira Dua Nombor', keperluan pengguna dikenal pasti terlebih dahulu sebelum reka bentuk alternatif dihasilkan.",
        ),

// Nota 6: Kepentingan Konsistensi dalam Reka Bentuk
        Note(
          title: "Kenapa Konsistensi Penting dalam Reka Bentuk?",
          content:
              "Konsistensi memastikan elemen-elemen dalam sistem berfungsi dengan cara yang sama. Contohnya, butang 'Close' pada Microsoft Windows sentiasa terletak di penjuru kanan atas. Jika elemen-elemen ini dialihkan tanpa sebab, pengguna akan merasa keliru. Konsistensi membantu pengguna merasa selesa dan mudah menggunakan sistem.",
        ),

// Nota 7: Kebolehan Membuat Pemerhatian
        Note(
          title: "Apa Itu Kebolehan Membuat Pemerhatian?",
          content:
              "Kebolehan membuat pemerhatian merujuk kepada bagaimana pengguna dapat mengenal pasti elemen interaksi seperti butang dan menu dengan mudah. Contohnya, antara muka Facebook yang kerap dikemas kini memerlukan pengguna mempelajari semula kedudukan butang interaksi. Jika butang sukar ditemui, pengguna akan merasa tidak selesa.",
        ),

// Nota 8: Kebolehan Dipelajari
        Note(
          title: "Apa Itu Kebolehan Dipelajari?",
          content:
              "Kebolehan dipelajari merujuk kepada seberapa mudah pengguna baru memahami dan menggunakan sistem. Contohnya, aplikasi WhatsApp mudah dipelajari kerana pengguna hanya perlu menggunakannya sekali untuk memahami cara ia berfungsi. Ini menjadikan pengguna lebih yakin dan selesa menggunakan aplikasi tersebut.",
        ),

// Nota 9: Kebolehan Dijangka
        Note(
          title: "Apa Itu Kebolehan Dijangka?",
          content:
              "Kebolehan dijangka merujuk kepada bagaimana pengguna boleh meramalkan apa yang akan berlaku selepas mereka melakukan sesuatu tindakan. Contohnya, apabila pengguna menekan ikon emoji di WhatsApp, mereka tahu bahawa senarai emoji akan dipaparkan. Kebolehan dijangka ini membuatkan pengguna merasa lebih yakin dan selesa menggunakan sistem tersebut.",
        ),

// Nota 10: Maklum Balas dalam Reka Bentuk Interaksi
        Note(
          title: "Kenapa Maklum Balas Penting dalam Reka Bentuk Interaksi?",
          content:
              "Maklum balas memberikan pengguna maklumat tentang hasil tindakan mereka. Contohnya, apabila pengguna menekan butang 'Public' di Facebook, sistem akan memaparkan pilihan yang berkaitan. Tanpa maklum balas, pengguna mungkin merasa keliru dan tidak pasti tentang tindakan mereka. Maklum balas yang baik juga termasuk paparan 'loading' yang memberitahu pengguna bahawa sistem sedang memproses arahan mereka.",
        ),
      ],
    ),
    Chapter(
      chapterName: "Paparan dan Reka Bentuk Skrin",
      notes: [
        // Tajuk 1: Pengenalan kepada Paparan dan Reka Bentuk Skrin
        Note(
          title: "Apa Itu Paparan dan Reka Bentuk Skrin?",
          content:
              "Paparan dan reka bentuk skrin adalah elemen penting dalam pembangunan aplikasi atau sistem. Ia melibatkan susun atur teks, butang, menu, dan gambar pada skrin untuk memastikan pengguna dapat berinteraksi dengan mudah dan selesa. Contohnya, antara muka WhatsApp dan Instagram direka dengan paparan yang ringkas dan intuitif, menjadikannya mudah digunakan oleh semua lapisan masyarakat.",
        ),
        Note(
          title: "Kenapa Reka Bentuk Skrin Penting?",
          content:
              "Reka bentuk skrin yang baik memastikan aplikasi atau sistem mudah digunakan, menarik, dan memenuhi keperluan pengguna. Contohnya, mesin ATM dan sistem penempahan tiket tren memerlukan reka bentuk skrin yang intuitif supaya pengguna tidak keliru semasa menggunakannya. Reka bentuk yang baik juga meningkatkan kepuasan pengguna dan mengurangkan kesilapan semasa interaksi.",
        ),

// Tajuk 2: Proses Reka Bentuk Interaksi
        Note(
          title: "4 Langkah Reka Bentuk Interaksi",
          content:
              "Proses reka bentuk interaksi terdiri daripada 4 langkah utama: (1) **Mewujudkan Keperluan** - kenal pasti apa yang pengguna perlukan, (2) **Mereka Bentuk Alternatif** - hasilkan beberapa cadangan reka bentuk, (3) **Membina Prototaip** - buat gambaran awal produk untuk dinilai, dan (4) **Membuat Penilaian** - nilai reka bentuk berdasarkan maklum balas pengguna. Contohnya, dalam pembangunan 'Program Mengira Dua Nombor', keperluan pengguna dikenal pasti terlebih dahulu sebelum reka bentuk alternatif dihasilkan.",
        ),
        Note(
          title: "Contoh Proses Reka Bentuk",
          content:
              "Contoh proses reka bentuk interaksi boleh dilihat dalam pembangunan aplikasi seperti Instagram. Pereka bentuk mengenal pasti keperluan pengguna untuk berkongsi gambar dan video, menghasilkan beberapa reka bentuk alternatif, membina prototaip, dan membuat penilaian berdasarkan maklum balas pengguna. Hasilnya, Instagram menjadi aplikasi yang mudah digunakan dan digemari ramai.",
        ),

// Tajuk 3: Mengenal Pasti Keperluan Pengguna
        Note(
          title: "Kenapa Perlu Kenal Pasti Keperluan Pengguna?",
          content:
              "Mengenal pasti keperluan pengguna adalah langkah pertama dalam reka bentuk interaksi. Ini membantu pereka bentuk memahami apa yang pengguna perlukan dan bagaimana produk dapat menyelesaikan masalah mereka. Contohnya, dalam pembangunan 'Program Mengira Dua Nombor', keperluan utama adalah membantu murid darjah tiga melakukan pengiraan matematik dengan mudah.",
        ),
        Note(
          title: "Kaedah Mengumpul Maklumat Pengguna",
          content:
              "Maklumat keperluan pengguna boleh dikumpul melalui beberapa kaedah seperti: (1) **Borang Soal Selidik** - untuk mengumpul maklum balas secara bertulis, (2) **Temu Ramah** - berbincang secara langsung dengan pengguna, dan (3) **Pemerhatian** - melihat bagaimana pengguna menggunakan produk sedia ada. Contohnya, pereka bentuk boleh menemu ramah guru dan murid untuk memahami keperluan mereka dalam 'Program Mengira Dua Nombor'.",
        ),

// Tajuk 4: Mereka Bentuk Alternatif
        Note(
          title: "Apa Itu Reka Bentuk Alternatif?",
          content:
              "Reka bentuk alternatif adalah beberapa cadangan reka bentuk yang dihasilkan berdasarkan keperluan pengguna. Contohnya, dalam pembangunan 'Program Mengira Dua Nombor', dua reka bentuk alternatif dihasilkan dengan susun atur dan warna yang berbeza. Pengguna kemudian dipilih untuk menilai reka bentuk ini dan memberikan maklum balas.",
        ),
        Note(
          title: "Contoh Reka Bentuk Alternatif",
          content:
              "Contoh reka bentuk alternatif untuk 'Program Mengira Dua Nombor': (1) **Reka Bentuk 1** - warna latar belakang kuning dan butang operasi berwarna biru, (2) **Reka Bentuk 2** - warna latar belakang kelabu cair dan butang operasi berwarna hijau. Pengguna memilih Reka Bentuk 2 kerana susun aturnya lebih mudah difahami.",
        ),

// Tajuk 5: Membina Prototaip
        Note(
          title: "Apa Itu Prototaip?",
          content:
              "Prototaip adalah gambaran awal produk yang digunakan untuk mendapatkan maklum balas pengguna sebelum produk sebenar dibangunkan. Prototaip boleh dihasilkan menggunakan kertas, kadbod, atau perisian komputer. Contohnya, prototaip 'Program Mengira Dua Nombor' dibangunkan menggunakan Java NetBeans untuk menguji fungsi dan susun atur sebelum dilancarkan.",
        ),
        Note(
          title: "Contoh Pembinaan Prototaip",
          content:
              "Langkah-langkah membina prototaip 'Program Mengira Dua Nombor': (1) Buka projek baharu dalam Java NetBeans, (2) Tambah label dan medan teks untuk input nombor, (3) Tambah butang kawalan untuk operasi matematik (tambah, tolak, darab, bahagi), dan (4) Sesuaikan warna dan susun atur berdasarkan maklum balas pengguna.",
        ),

// Tajuk 6: Penilaian Reka Bentuk
        Note(
          title: "Kenapa Perlu Penilaian Reka Bentuk?",
          content:
              "Penilaian reka bentuk dilakukan untuk memastikan produk memenuhi keperluan pengguna dan mudah digunakan. Contohnya, dalam penilaian 'Program Mengira Dua Nombor', 95.1% pengguna memberikan maklum balas positif terhadap reka bentuk skrin. Penilaian ini membantu pereka bentuk memahami tahap kepuasan pengguna dan membuat penambahbaikan jika diperlukan.",
        ),
        Note(
          title: "Contoh Instrumen Penilaian",
          content:
              "Contoh instrumen penilaian untuk 'Program Mengira Dua Nombor' termasuk kriteria seperti: (1) Reka bentuk skrin mudah dan ringkas, (2) Pemilihan warna dan ikon yang bersesuaian, (3) Sistem navigasi yang mudah difahami, (4) Butang kawalan operasi matematik berfungsi dengan baik, dan (5) Butang 'Reset' dan 'Keluar' berfungsi seperti yang dijangka.",
        ),

// Tajuk 7: Kesimpulan
        Note(
          title: "Kepentingan Reka Bentuk Interaksi",
          content:
              "Reka bentuk interaksi yang baik memastikan produk mudah digunakan, menarik, dan memenuhi keperluan pengguna. Contohnya, Instagram dan sistem penempahan tiket MAS berjaya kerana reka bentuknya yang mesra pengguna. Proses reka bentuk yang melibatkan pengguna dari awal hingga akhir dapat meningkatkan kepuasan pengguna dan memastikan produk berjaya dalam pasaran.",
        ),
        Note(
          title: "Langkah Seterusnya",
          content:
              "Langkah seterusnya dalam reka bentuk interaksi termasuk teruskan penambahbaikan berdasarkan maklum balas pengguna, kembangkan produk dengan menambah ciri-ciri baru yang relevan, dan pastikan produk sentiasa dikemas kini mengikut keperluan semasa.",
        ),
      ],
    ),
  ];

 
}

// Predefined quizzes to load into the database
Future<void> predefinedQuizzes() async {
  List<Quiz> predefinedQuizList = [
    Quiz(
      chapter: "YVZsodXv0iQ1fkdZ7dhZ",
      question: 'Apakah yang dimaksudkan dengan reka bentuk interaksi?',
      options: [
        'Proses mereka bentuk cara pengguna berinteraksi dengan sistem',
        'Proses meningkatkan kelajuan sistem',
        'Proses menambah bilangan ciri dalam sistem',
        'Proses mengurangkan kos pembangunan'
      ],
      answer: 0,
    ),
    Quiz(
      chapter: "YVZsodXv0iQ1fkdZ7dhZ",
      question: 'Apakah kepentingan reka bentuk interaksi?',
      options: [
        'Meningkatkan kelajuan sistem',
        'Memudahkan interaksi pengguna dengan sistem',
        'Mengurangkan kos pembangunan',
        'Menambah bilangan ciri sistem'
      ],
      answer: 1,
    ),
    Quiz(
      chapter: "YVZsodXv0iQ1fkdZ7dhZ",
      question: 'Berapakah prinsip utama dalam reka bentuk interaksi?',
      options: ['3', '4', '5', '6'],
      answer: 2,
    ),
    Quiz(
      chapter: "YVZsodXv0iQ1fkdZ7dhZ",
      question:
          'Apakah prinsip reka bentuk interaksi yang memastikan elemen serupa berfungsi dengan cara yang sama?',
      options: [
        'Kebolehan Dipelajari',
        'Konsistensi',
        'Maklum Balas',
        'Kebolehan Dijangka'
      ],
      answer: 1,
    ),
    Quiz(
      chapter: "YVZsodXv0iQ1fkdZ7dhZ",
      question:
          'Apakah yang dimaksudkan dengan "kebolehan dipelajari" dalam reka bentuk interaksi?',
      options: [
        'Seberapa pantas pengguna boleh melakukan tugas',
        'Seberapa mudah pengguna baru memahami dan menggunakan sistem',
        'Bilangan ciri yang terdapat dalam sistem',
        'Kos pembangunan sistem'
      ],
      answer: 1,
    ),
    Quiz(
      chapter: "YVZsodXv0iQ1fkdZ7dhZ",
      question:
          'Apakah contoh maklum balas yang baik dalam reka bentuk interaksi?',
      options: [
        'Paparan "loading" semasa sistem memproses arahan',
        'Paparan iklan yang tidak diperlukan',
        'Tiada maklum balas selepas tindakan pengguna',
        'Paparan yang terlalu terang'
      ],
      answer: 0,
    ),
    Quiz(
      chapter: "YVZsodXv0iQ1fkdZ7dhZ",
      question: 'Apakah langkah pertama dalam proses reka bentuk interaksi?',
      options: [
        'Membina prototaip',
        'Mewujudkan keperluan pengguna',
        'Membuat penilaian',
        'Mereka bentuk alternatif'
      ],
      answer: 1,
    ),
    Quiz(
      chapter: "YVZsodXv0iQ1fkdZ7dhZ",
      question:
          'Apakah yang dimaksudkan dengan "kebolehan dijangka" dalam reka bentuk interaksi?',
      options: [
        'Pengguna boleh meramalkan apa yang akan berlaku selepas tindakan mereka',
        'Sistem boleh berfungsi tanpa sebarang input pengguna',
        'Pengguna perlu mempelajari sistem secara mendalam',
        'Sistem mempunyai banyak ciri yang rumit'
      ],
      answer: 0,
    ),
    Quiz(
      chapter: "YVZsodXv0iQ1fkdZ7dhZ",
      question:
          'Apakah contoh produk interaktif yang menggunakan reka bentuk skrin yang baik?',
      options: [
        'Mesin ATM',
        'Papan kekunci mekanikal',
        'Tetikus tanpa wayar',
        'Pencetak 3D'
      ],
      answer: 0,
    ),
    Quiz(
      chapter: "CtGwccnQVc38I9UeX5cb",
      question: 'Apakah yang dimaksudkan dengan reka bentuk interaksi?',
      options: [
        'Proses mereka bentuk cara pengguna berinteraksi dengan sistem',
        'Proses meningkatkan kelajuan sistem',
        'Proses menambah bilangan ciri dalam sistem',
        'Proses mengurangkan kos pembangunan'
      ],
      answer: 0,
    ),
    Quiz(
      chapter: "CtGwccnQVc38I9UeX5cb",
      question:
          'Apakah contoh aplikasi dengan reka bentuk interaksi yang baik?',
      options: ['Terminal', 'Instagram', 'Command Prompt', 'Linux Shell'],
      answer: 1,
    ),
    Quiz(
      chapter: "CtGwccnQVc38I9UeX5cb",
      question: 'Apakah kepentingan reka bentuk interaksi?',
      options: [
        'Meningkatkan kelajuan sistem',
        'Memudahkan interaksi pengguna dengan sistem',
        'Mengurangkan kos pembangunan',
        'Menambah bilangan ciri sistem'
      ],
      answer: 1,
    ),
    Quiz(
      chapter: "CtGwccnQVc38I9UeX5cb",
      question: 'Berapakah prinsip utama dalam reka bentuk interaksi?',
      options: ['3', '4', '5', '6'],
      answer: 2,
    ),
    Quiz(
      chapter: "CtGwccnQVc38I9UeX5cb",
      question:
          'Apakah prinsip reka bentuk interaksi yang memastikan elemen serupa berfungsi dengan cara yang sama?',
      options: [
        'Kebolehan Dipelajari',
        'Konsistensi',
        'Maklum Balas',
        'Kebolehan Dijangka'
      ],
      answer: 1,
    ),
    Quiz(
      chapter: "CtGwccnQVc38I9UeX5cb",
      question:
          'Apakah yang dimaksudkan dengan "kebolehan dipelajari" dalam reka bentuk interaksi?',
      options: [
        'Seberapa pantas pengguna boleh melakukan tugas',
        'Seberapa mudah pengguna baru memahami dan menggunakan sistem',
        'Bilangan ciri yang terdapat dalam sistem',
        'Kos pembangunan sistem'
      ],
      answer: 1,
    ),
    Quiz(
      chapter: "CtGwccnQVc38I9UeX5cb",
      question:
          'Apakah contoh maklum balas yang baik dalam reka bentuk interaksi?',
      options: [
        'Paparan "loading" semasa sistem memproses arahan',
        'Paparan iklan yang tidak diperlukan',
        'Tiada maklum balas selepas tindakan pengguna',
        'Paparan yang terlalu terang'
      ],
      answer: 0,
    ),
    Quiz(
      chapter: "CtGwccnQVc38I9UeX5cb",
      question: 'Apakah langkah pertama dalam proses reka bentuk interaksi?',
      options: [
        'Membina prototaip',
        'Mewujudkan keperluan pengguna',
        'Membuat penilaian',
        'Mereka bentuk alternatif'
      ],
      answer: 1,
    ),
    Quiz(
      chapter: "CtGwccnQVc38I9UeX5cb",
      question:
          'Apakah yang dimaksudkan dengan "kebolehan dijangka" dalam reka bentuk interaksi?',
      options: [
        'Pengguna boleh meramalkan apa yang akan berlaku selepas tindakan mereka',
        'Sistem boleh berfungsi tanpa sebarang input pengguna',
        'Pengguna perlu mempelajari sistem secara mendalam',
        'Sistem mempunyai banyak ciri yang rumit'
      ],
      answer: 0,
    ),
    Quiz(
      chapter: "CtGwccnQVc38I9UeX5cb",
      question:
          'Apakah contoh produk interaktif yang menggunakan reka bentuk skrin yang baik?',
      options: [
        'Mesin ATM',
        'Papan kekunci mekanikal',
        'Tetikus tanpa wayar',
        'Pencetak 3D'
      ],
      answer: 0,
    ),
  ];
  ChapterService chapterService = ChapterService();
  for (Quiz quiz in predefinedQuizList) {
    await chapterService.addQuizToChapter(quiz.chapter, quiz);
  }
}
