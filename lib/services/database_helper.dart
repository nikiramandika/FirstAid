import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/first_aid_data.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'first_aid.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE first_aid_data(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        treatment TEXT,
        warnings TEXT,
        symptoms TEXT,
        iconName TEXT,
        priority INTEGER DEFAULT 1,
        videoUrl TEXT,
        illustrationUrl TEXT
      )
    ''');

    // Insert initial data
    await _insertInitialData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE first_aid_data ADD COLUMN videoUrl TEXT');
      await db.execute('ALTER TABLE first_aid_data ADD COLUMN illustrationUrl TEXT');
    }
  }

  Future<void> _insertInitialData(Database db) async {
    final List<Map<String, dynamic>> initialData = [
      // Pendarahan
      {
        'category': 'Pendarahan',
        'title': 'Peringatan Kebersihan',
        'description': 'Waspadai risiko infeksi silang saat menangani luka terbuka',
        'treatment': 'Selalu cuci tangan Anda sebelum dan sesudah perawatan\nJika memungkinkan, kenakan sarung tangan sekali pakai\nPastikan luka terbuka ditutup dengan plester\nUsahakan untuk tidak menyentuh luka atau balutan\nBuanglah limbah apa pun',
        'warnings': 'Risiko infeksi silang saat menangani luka terbuka',
        'symptoms': '',
        'iconName': 'clean_hands',
        'priority': 1,
        'videoUrl': '',
        'illustrationUrl': '',
      },
      {
        'category': 'Pendarahan',
        'title': 'Pendarahan Parah',
        'description': 'Mengontrol pendarahan dengan memberikan tekanan langsung pada luka',
        'treatment': 'Mengontrol pendarahan dengan memberikan tekanan langsung pada luka\nHubungi PHC 119 untuk ambulans\nPasang balutan dengan kuat untuk mengontrol pendarahan\nCegah/tangani syok dengan membaringkan korban dengan kaki terangkat\nJika korban mengalami cedera kepala, baringkan korban dan angkat sedikit kepala dan bahunya',
        'warnings': 'Jangan terlalu ketat sehingga membatasi sirkulasi',
        'symptoms': 'Darah keluar dari luka, korban mungkin mengalami syok',
        'iconName': 'blood_drop',
        'priority': 1,
        'videoUrl': '',
        'illustrationUrl': '',
      },
      {
        'category': 'Pendarahan',
        'title': 'Pendarahan Kecil',
        'description': 'Penanganan luka ringan dan pendarahan minor',
        'treatment': 'Jika kotor, bersihkan luka dengan air mengalir\nTepuk-tepuk luka hingga kering menggunakan bahan steril\nTutup luka sepenuhnya dengan bahan steril\nMenopang area yang cedera\nBersihkan area di sekitarnya dan oleskan balutan perekat steril',
        'warnings': 'Sarankan korban untuk menemui dokter jika ada risiko infeksi',
        'symptoms': 'Luka kecil, pendarahan ringan',
        'iconName': 'bandage',
        'priority': 2,
        'videoUrl': '',
        'illustrationUrl': '',
      },
      
      // Tulang dan Otot
      {
        'category': 'Tulang dan Otot',
        'title': 'Patah Tulang',
        'description': 'Penanganan patah tulang dan cedera tulang',
        'treatment': 'Sangga anggota tubuh\nImobilisasi\nKendalikan pendarahan tanpa menekan tulang yang menonjol\nLindungi dari infeksi\nHubungi PHC 119\nObati syok',
        'warnings': 'Jangan pindahkan korban kecuali dalam keadaan darurat',
        'symptoms': 'Nyeri/nyeri tekan, pembengkakan, memar, jangkauan gerakan yang tidak wajar, imobilitas, kebisingan/perasaan kisi-kisi, kelainan bentuk, kehilangan daya, shock, tungkai bengkok, luka dengan tulang yang menonjol',
        'iconName': 'bone',
        'priority': 1,
        'videoUrl': '',
        'illustrationUrl': '',
      },
      {
        'category': 'Tulang dan Otot',
        'title': 'Keseleo',
        'description': 'Penanganan keseleo dan cedera otot',
        'treatment': 'Istirahatkan bagian cedera\nKompres es 10 menit\nBeri dukungan nyaman\nTinggikan cedera\nMinta nasihat medis',
        'warnings': 'Jangan memijat area yang cedera',
        'symptoms': 'Rasa sakit/nyeri yang parah, pembengkakan, memar, kesulitan menggerakkan bagian yang terpengaruh',
        'iconName': 'muscle',
        'priority': 2,
        'videoUrl': '',
        'illustrationUrl': '',
      },
      {
        'category': 'Tulang dan Otot',
        'title': 'Cedera Tulang Belakang',
        'description': 'Penanganan cedera tulang belakang yang serius',
        'treatment': 'Hubungi PHC 119\nSangga kepala & leher\nJangan pindahkan kecuali darurat\nDukung dengan mantel digulung di sisi leher\nPantau korban\nPertahankan jalan napas',
        'warnings': 'JANGAN pindahkan korban kecuali dalam keadaan darurat mutlak',
        'symptoms': 'Nyeri leher/tulang belakang, pembengkakan, memar, bentuk punggung tidak alami, kontrol anggota tubuh yang buruk, sensasi berkurang/tidak biasa, kesulitan bernapas, kehilangan kontrol usus/kandung kemih',
        'iconName': 'spine',
        'priority': 1,
        'videoUrl': '',
        'illustrationUrl': '',
      },
      
      // Luka Bakar
      {
        'category': 'Luka Bakar',
        'title': 'Luka Bakar Umum',
        'description': 'Penanganan luka bakar pada umumnya',
        'treatment': 'Biarkan pakaian yang menempel tetap di tempatnya kecuali terkontaminasi kimia\nRendam di air dingin/mengalir minimal 20 menit\nLepas perhiasan atau pakaian ketat\nTutup dengan balutan steril atau cling film\nHubungi PHC 119 jika perlu',
        'warnings': 'Jangan lepaskan apapun yang menempel, jangan mendinginkan berlebihan, jangan pakai lotion/salep/krim, jangan pakai pembalut berperekat, jangan pecahkan lepuh',
        'symptoms': 'Kulit kemerahan, lepuh, nyeri, pembengkakan',
        'iconName': 'burn',
        'priority': 1,
        'videoUrl': '',
        'illustrationUrl': '',
      },
      {
        'category': 'Luka Bakar',
        'title': 'Luka Bakar Wajah/Mulut',
        'description': 'Penanganan luka bakar pada wajah dan mulut',
        'treatment': 'Hubungi 999/112\nJaga jalan napas\nLonggarkan pakaian di leher\nBerikan es atau air dingin\nPantau karena dapat menyebabkan kesulitan bernapas',
        'warnings': 'Waspadai kesulitan bernapas',
        'symptoms': 'Luka bakar pada wajah, bibir, atau mulut',
        'iconName': 'face',
        'priority': 1,
        'videoUrl': '',
        'illustrationUrl': '',
      },
      {
        'category': 'Luka Bakar',
        'title': 'Luka Bakar Tubuh/Mata',
        'description': 'Penanganan luka bakar pada tubuh dan mata',
        'treatment': 'Siram dengan air mengalir hingga ambulans tiba\nLepas pakaian terkontaminasi dengan hati-hati\nUntuk mata: irigasi kedua sisi kelopak, minta lepas lensa kontak, pastikan air mengalir menjauhi wajah',
        'warnings': 'Untuk mata, jangan menggosok atau menekan',
        'symptoms': 'Luka bakar pada tubuh atau mata',
        'iconName': 'eye',
        'priority': 1,
        'videoUrl': '',
        'illustrationUrl': '',
      },
      
      // Cedera Kepala
      {
        'category': 'Cedera Kepala',
        'title': 'Gegar Otak',
        'description': 'Penanganan gegar otak ringan',
        'treatment': 'Pantau korban\nJangan biarkan kembali beraktivitas sebelum dinilai medis\nCari bantuan jika gejala memburuk\nIstirahat total',
        'warnings': 'Perlakukan semua cedera kepala dengan serius. Asumsikan cedera leher juga.',
        'symptoms': 'Pukulan di kepala, sakit kepala, pusing, kehilangan memori, kebingungan',
        'iconName': 'head',
        'priority': 1,
        'videoUrl': '',
        'illustrationUrl': '',
      },
      {
        'category': 'Cedera Kepala',
        'title': 'Kompresi Otak',
        'description': 'Penanganan kompresi otak yang serius',
        'treatment': 'Segera hubungi PHC 119\nJangan biarkan korban tidur\nPantau tingkat kesadaran\nJaga jalan napas',
        'warnings': 'Kondisi yang sangat serius, memerlukan perhatian medis segera',
        'symptoms': 'Sakit kepala meningkat, tidak responsif, pupil tidak sama, kelemahan di satu sisi, muntah, mengantuk',
        'iconName': 'brain',
        'priority': 1,
        'videoUrl': '',
        'illustrationUrl': '',
      },
      {
        'category': 'Cedera Kepala',
        'title': 'Patah Tulang Tengkorak',
        'description': 'Penanganan patah tulang tengkorak',
        'treatment': 'Segera hubungi PHC 119\nJangan memindahkan korban\nJaga kepala dan leher tetap stabil\nPantau jalan napas',
        'warnings': 'Jangan membersihkan cairan yang keluar dari hidung/telinga',
        'symptoms': 'Luka/memar kepala, kebocoran cairan hidung/telinga, deformitas',
        'iconName': 'skull',
        'priority': 1,
        'videoUrl': '',
        'illustrationUrl': '',
      },
      
      // Keracunan
      {
        'category': 'Keracunan',
        'title': 'Keracunan Tertelan',
        'description': 'Penanganan keracunan melalui mulut',
        'treatment': 'Cari tahu racun yang tertelan\nSimpan kemasan\nBeri air/susu jika bibir terbakar\nJangan buat muntah\nHubungi PHC 119',
        'warnings': 'Jangan membuat korban muntah kecuali diinstruksikan oleh petugas medis',
        'symptoms': 'Mual, muntah, sakit perut, pusing, kesadaran menurun',
        'iconName': 'poison',
        'priority': 1,
        'videoUrl': '',
        'illustrationUrl': '',
      },
      {
        'category': 'Keracunan',
        'title': 'Keracunan Kulit',
        'description': 'Penanganan keracunan melalui kulit',
        'treatment': 'Cuci dengan air mengalir 20 menit\nLepas pakaian terkontaminasi\nHindari percikan\nHubungi PHC 119',
        'warnings': 'Jangan menggosok area yang terkontaminasi',
        'symptoms': 'Kulit kemerahan, terbakar, gatal, lepuh',
        'iconName': 'skin',
        'priority': 2,
        'videoUrl': '',
        'illustrationUrl': '',
      },
      {
        'category': 'Keracunan',
        'title': 'Keracunan Obat-obatan',
        'description': 'Penanganan overdosis obat',
        'treatment': 'Cari tahu obat yang dikonsumsi\nJangan buat muntah\nHubungi PHC 119\nSimpan muntahan untuk petugas',
        'warnings': 'Jangan memberikan makanan atau minuman',
        'symptoms': 'Mual, muntah, pusing, kesadaran menurun, pupil melebar atau menyempit',
        'iconName': 'pill',
        'priority': 1,
        'videoUrl': '',
        'illustrationUrl': '',
      },
      
      // Kejang
      {
        'category': 'Kejang',
        'title': 'Kejang Ketidakhadiran',
        'description': 'Penanganan kejang ringan tanpa kehilangan kesadaran total',
        'treatment': 'Tidak ada penanganan segera selain memastikan korban aman\nPantau durasi kejang\nCatat frekuensi kejadian',
        'warnings': 'Waspadai jika kejang berlangsung lama atau berulang',
        'symptoms': 'Kehilangan kesadaran beberapa detik, gerakan aneh, tidak responsif sementara',
        'iconName': 'seizure',
        'priority': 2,
        'videoUrl': '',
        'illustrationUrl': '',
      },
      {
        'category': 'Kejang',
        'title': 'Kejang Kejang',
        'description': 'Penanganan kejang epilepsi yang serius',
        'treatment': 'Kosongkan area sekitar korban\nLindungi kepala\nLonggarkan pakaian\nJangan masukkan benda ke mulut\nJangan tahan tubuh\nPeriksa pernapasan setelah kejang berhenti\nHubungi PHC 119 jika kejang >5 menit, cedera, tidak responsif, atau kejang pertama kali',
        'warnings': 'Jangan memasukkan benda apapun ke mulut korban',
        'symptoms': 'Tubuh kaku, jatuh, kesulitan bernapas, rahang terkatup, kehilangan kontrol usus, pulih dalam beberapa menit',
        'iconName': 'epilepsy',
        'priority': 1,
        'videoUrl': '',
        'illustrationUrl': '',
      },
    ];

    for (var data in initialData) {
      await db.insert('first_aid_data', data);
    }
  }

  Future<List<FirstAidData>> getAllData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('first_aid_data', orderBy: 'priority ASC, title ASC');
    return List.generate(maps.length, (i) => FirstAidData.fromMap(maps[i]));
  }

  Future<List<FirstAidData>> getDataByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'first_aid_data',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'priority ASC, title ASC',
    );
    return List.generate(maps.length, (i) => FirstAidData.fromMap(maps[i]));
  }

  Future<List<String>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'first_aid_data',
      distinct: true,
      columns: ['category'],
      orderBy: 'category ASC',
    );
    return maps.map((map) => map['category'] as String).toList();
  }

  Future<FirstAidData?> getDataById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'first_aid_data',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return FirstAidData.fromMap(maps.first);
    }
    return null;
  }

  Future<List<FirstAidData>> searchData(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'first_aid_data',
      where: 'title LIKE ? OR description LIKE ? OR symptoms LIKE ? OR treatment LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%'],
      orderBy: 'priority ASC, title ASC',
    );
    return List.generate(maps.length, (i) => FirstAidData.fromMap(maps[i]));
  }

  Future<int> insertData(FirstAidData data) async {
    final db = await database;
    return await db.insert('first_aid_data', data.toMap()..remove('id'));
  }

  Future<int> updateData(FirstAidData data) async {
    final db = await database;
    return await db.update(
      'first_aid_data',
      data.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  Future<int> deleteData(int id) async {
    final db = await database;
    return await db.delete('first_aid_data', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> upsertData(FirstAidData data) async {
    final updated = await updateData(data);
    if (updated == 0) {
      await dbInsertWithId(data);
    }
  }

  Future<void> dbInsertWithId(FirstAidData data) async {
    final db = await database;
    await db.insert(
      'first_aid_data',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> replaceAll(List<FirstAidData> list) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('first_aid_data');
      for (final item in list) {
        await txn.insert('first_aid_data', item.toMap());
      }
    });
  }
} 