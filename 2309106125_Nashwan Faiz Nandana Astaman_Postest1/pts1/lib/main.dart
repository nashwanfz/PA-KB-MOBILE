import 'dart:io';

// Enum untuk kategori makanan
enum KategoriMakanan {
  makananUtama,
  makananPembuka,
  makananPenutup,
  minuman,
  cemilan
}

// Class untuk merepresentasikan bahan makanan
class Bahan {
  String nama;
  String jumlah;
  String? satuan; // Nullable dengan Null Safety

  Bahan({
    required this.nama,
    required this.jumlah,
    this.satuan,
  });

  @override
  String toString() {
    // Null Conditional dan Ternary Operator
    String hasil = '$jumlah ${satuan?.isNotEmpty == true ? satuan! : ''} $nama'.trim();
    return hasil;
  }
}

// Class untuk merepresentasikan resep makanan
class Resep {
  String nama;
  KategoriMakanan kategori;
  List<Bahan> bahan;
  List<String> langkah;
  int? waktuMasak; // Nullable dengan Null Safety
  String? tingkatKesulitan; // Nullable dengan Null Safety

  Resep({
    required this.nama,
    required this.kategori,
    required this.bahan,
    required this.langkah,
    this.waktuMasak,
    this.tingkatKesulitan,
  });

  // Method untuk menampilkan kategori dalam bahasa Indonesia
  String get namaKategori {
    switch (kategori) {
      case KategoriMakanan.makananUtama:
        return 'Makanan Utama';
      case KategoriMakanan.makananPembuka:
        return 'Makanan Pembuka';
      case KategoriMakanan.makananPenutup:
        return 'Makanan Penutup';
      case KategoriMakanan.minuman:
        return 'Minuman';
      case KategoriMakanan.cemilan:
        return 'Cemilan';
    }
  }

  void tampilkanResep() {
    print('\n${'=' * 50}');
    print('RESEP: ${nama.toUpperCase()}');
    print('${'=' * 50}');
    print('Kategori: $namaKategori');
    
    String waktuText = waktuMasak?.toString() ?? 'Tidak ditentukan';
    print('Waktu Masak: ${waktuMasak != null ? '$waktuText menit' : waktuText}');
    print('Tingkat Kesulitan: ${tingkatKesulitan ?? 'Tidak ditentukan'}');
    
    print('\nBAHAN-BAHAN:');
    for (int i = 0; i < bahan.length; i++) {
      print('${i + 1}. ${bahan[i]}');
    }
    
    print('\nLANGKAH-LANGKAH:');
    for (int i = 0; i < langkah.length; i++) {
      print('${i + 1}. ${langkah[i]}');
    }
    print('${'=' * 50}');
  }
}

// Class untuk mengelola koleksi resep
class ManajerResep {
  List<Resep> _daftarResep = [];

  void tambahResep(Resep resep) {
    _daftarResep.add(resep);
    print('✓ Resep "${resep.nama}" berhasil ditambahkan!');
  }

  void tampilkanSemuaResep() {
    _daftarResep.isEmpty 
        ? print('Belum ada resep yang tersimpan.')
        : _tampilkanDaftarResep();
  }

  void _tampilkanDaftarResep() {
    print('\n📖 DAFTAR RESEP MAKANAN');
    print('${'=' * 40}');
    for (int i = 0; i < _daftarResep.length; i++) {
      final resep = _daftarResep[i];
      print('${i + 1}. ${resep.nama} (${resep.namaKategori})');
      print('   Waktu: ${resep.waktuMasak != null ? '${resep.waktuMasak} menit' : 'Tidak ditentukan'}');
    }
    print('${'=' * 40}');
  }

  Resep? cariResepBerdasarkanNama(String nama) {
  try {
    return _daftarResep.firstWhere(
      (resep) => resep.nama.toLowerCase().contains(nama.toLowerCase()),
    );
  } catch (e) {
    return null;
  }
}



  List<Resep> cariResepBerdasarkanKategori(KategoriMakanan kategori) {
    return _daftarResep.where((resep) => resep.kategori == kategori).toList();
  }

  bool hapusResep(String nama) {
    final resep = cariResepBerdasarkanNama(nama);
    if (resep != null) {
      _daftarResep.remove(resep);
      return true;
    }
    return false;
  }

  int get jumlahResep => _daftarResep.length;
}

// Class utama aplikasi
class AplikasiResep {
  final ManajerResep _manajerResep = ManajerResep();

  void jalankan() {
    _inisialisasiDataContoh();
    print('🍽  SELAMAT DATANG DI APLIKASI RESEP MAKANAN  🍽');
    
    while (true) {
      _tampilkanMenu();
      final pilihan = _bacaInput('Pilih menu (1-6): ');
      
      switch (pilihan) {
        case '1':
          _tambahResepBaru();
          break;
        case '2':
          _manajerResep.tampilkanSemuaResep();
          break;
        case '3':
          _cariResep();
          break;
        case '4':
          _tampilkanResepBerdasarkanKategori();
          break;
        case '5':
          _hapusResep();
          break;
        case '6':
          print('Terima kasih telah menggunakan aplikasi resep makanan! 👋');
          exit(0);
        default:
          print('❌ Pilihan tidak valid! Silakan coba lagi.');
      }
      
      print('\nTekan Enter untuk melanjutkan...');
      stdin.readLineSync();
    }
  }

  void _tampilkanMenu() {
    print('\n📋 MENU UTAMA');
    print('${'=' * 30}');
    print('1. Tambah Resep Baru');
    print('2. Tampilkan Semua Resep');
    print('3. Cari Resep');
    print('4. Resep Berdasarkan Kategori');
    print('5. Hapus Resep');
    print('6. Keluar');
    print('${'=' * 30}');
  }

  String _bacaInput(String prompt) {
    stdout.write(prompt);
    return stdin.readLineSync() ?? '';
  }

  void _tambahResepBaru() {
    print('\n📝 TAMBAH RESEP BARU');
    print('${'=' * 25}');
    
    final nama = _bacaInput('Nama resep: ');
    if (nama.isEmpty) {
      print('❌ Nama resep tidak boleh kosong!');
      return;
    }

    print('\nPilih kategori:');
    final kategoris = KategoriMakanan.values;
    for (int i = 0; i < kategoris.length; i++) {
      print('${i + 1}. ${_getNamaKategori(kategoris[i])}');
    }
    
    final pilihanKategori = _bacaInput('Pilih kategori (1-${kategoris.length}): ');
    final indexKategori = int.tryParse(pilihanKategori);
    
    final kategori = (indexKategori != null && indexKategori > 0 && indexKategori <= kategoris.length)
        ? kategoris[indexKategori - 1]
        : KategoriMakanan.makananUtama;

    final List<Bahan> bahan = [];
    print('\nMasukkan bahan (ketik "selesai" untuk mengakhiri):');
    while (true) {
      final inputBahan = _bacaInput('Nama bahan: ');
      if (inputBahan.toLowerCase() == 'selesai') break;
      
      final jumlah = _bacaInput('Jumlah: ');
      final satuan = _bacaInput('Satuan (opsional): ');
      final satuanFinal = satuan.isEmpty ? null : satuan;
      
      bahan.add(Bahan(nama: inputBahan, jumlah: jumlah, satuan: satuanFinal));
    }

    final List<String> langkah = [];
    print('\nMasukkan langkah-langkah (ketik "selesai" untuk mengakhiri):');
    while (true) {
      final inputLangkah = _bacaInput('Langkah: ');
      if (inputLangkah.toLowerCase() == 'selesai') break;
      langkah.add(inputLangkah);
    }

    final inputWaktu = _bacaInput('Waktu masak dalam menit (opsional): ');
    final waktuMasak = inputWaktu.isNotEmpty ? int.tryParse(inputWaktu) : null;

    final tingkatKesulitan = _bacaInput('Tingkat kesulitan (opsional): ');
    final tingkatFinal = tingkatKesulitan.isEmpty ? null : tingkatKesulitan;

    final resep = Resep(
      nama: nama,
      kategori: kategori,
      bahan: bahan,
      langkah: langkah,
      waktuMasak: waktuMasak,
      tingkatKesulitan: tingkatFinal,
    );

    _manajerResep.tambahResep(resep);
  }

  void _cariResep() {
    final nama = _bacaInput('\n🔍 Masukkan nama resep yang dicari: ');
    final resep = _manajerResep.cariResepBerdasarkanNama(nama);
    
    if (resep != null) {
      resep.tampilkanResep();
    } else {
      print('❌ Resep tidak ditemukan!');
    }
  }

  void _tampilkanResepBerdasarkanKategori() {
    print('\n📂 PILIH KATEGORI:');
    final kategoris = KategoriMakanan.values;
    for (int i = 0; i < kategoris.length; i++) {
      print('${i + 1}. ${_getNamaKategori(kategoris[i])}');
    }
    
    final pilihan = _bacaInput('Pilih kategori (1-${kategoris.length}): ');
    final index = int.tryParse(pilihan);
    
    if (index != null && index > 0 && index <= kategoris.length) {
      final kategori = kategoris[index - 1];
      final resepKategori = _manajerResep.cariResepBerdasarkanKategori(kategori);
      
      resepKategori.isEmpty 
          ? print('❌ Tidak ada resep dalam kategori ${_getNamaKategori(kategori)}')
          : _tampilkanDaftarResepKategori(resepKategori, kategori);
    } else {
      print('❌ Pilihan tidak valid!');
    }
  }

  void _tampilkanDaftarResepKategori(List<Resep> resep, KategoriMakanan kategori) {
    print('\n📋 RESEP KATEGORI: ${_getNamaKategori(kategori).toUpperCase()}');
    print('${'=' * 40}');
    for (int i = 0; i < resep.length; i++) {
      print('${i + 1}. ${resep[i].nama}');
    }
    print('${'=' * 40}');
    
    final pilihan = _bacaInput('Pilih resep untuk melihat detail (0 untuk kembali): ');
    final index = int.tryParse(pilihan);
    
    if (index != null && index > 0 && index <= resep.length) {
      resep[index - 1].tampilkanResep();
    }
  }

  void _hapusResep() {
    final nama = _bacaInput('\n🗑  Masukkan nama resep yang akan dihapus: ');
    final berhasil = _manajerResep.hapusResep(nama);
    berhasil 
        ? print('✓ Resep berhasil dihapus!')
        : print('❌ Resep tidak ditemukan!');
  }

  String _getNamaKategori(KategoriMakanan kategori) {
    switch (kategori) {
      case KategoriMakanan.makananUtama:
        return 'Makanan Utama';
      case KategoriMakanan.makananPembuka:
        return 'Makanan Pembuka';
      case KategoriMakanan.makananPenutup:
        return 'Makanan Penutup';
      case KategoriMakanan.minuman:
        return 'Minuman';
      case KategoriMakanan.cemilan:
        return 'Cemilan';
    }
  }

  void _inisialisasiDataContoh() {
    // Makanan Utama
    final resep1 = Resep(
      nama: 'Nasi Goreng Spesial',
      kategori: KategoriMakanan.makananUtama,
      bahan: [
        Bahan(nama: 'Nasi putih', jumlah: '3', satuan: 'piring'),
        Bahan(nama: 'Telur ayam', jumlah: '2', satuan: 'butir'),
        Bahan(nama: 'Bawang merah', jumlah: '5', satuan: 'siung'),
        Bahan(nama: 'Kecap manis', jumlah: '2', satuan: 'sdm'),
      ],
      langkah: [
        'Panaskan minyak dalam wajan',
        'Tumis bawang merah hingga harum',
        'Masukkan telur, orak-arik',
        'Tambahkan nasi, aduk rata',
        'Beri kecap manis dan bumbu lainnya',
        'Aduk hingga semua tercampur rata'
      ],
      waktuMasak: 15,
      tingkatKesulitan: 'Mudah',
    );

    final resep2 = Resep(
      nama: 'Sate Ayam Madura',
      kategori: KategoriMakanan.makananUtama,
      bahan: [
        Bahan(nama: 'Daging ayam', jumlah: '500', satuan: 'gram'),
        Bahan(nama: 'Tusuk sate', jumlah: '20', satuan: 'batang'),
        Bahan(nama: 'Kacang tanah goreng', jumlah: '200', satuan: 'gram'),
        Bahan(nama: 'Kecap manis', jumlah: '4', satuan: 'sdm'),
      ],
      langkah: [
        'Potong daging ayam kecil-kecil',
        'Tusukkan ke batang sate',
        'Haluskan kacang tanah untuk bumbu',
        'Panggang sate hingga matang',
        'Sajikan dengan bumbu kacang dan kecap'
      ],
      waktuMasak: 25,
      tingkatKesulitan: 'Sedang',
    );

    // Minuman
    final resep3 = Resep(
      nama: 'Es Teh Manis',
      kategori: KategoriMakanan.minuman,
      bahan: [
        Bahan(nama: 'Teh celup', jumlah: '2', satuan: 'kantong'),
        Bahan(nama: 'Gula pasir', jumlah: '3', satuan: 'sdm'),
        Bahan(nama: 'Air panas', jumlah: '200', satuan: 'ml'),
        Bahan(nama: 'Es batu', jumlah: 'secukupnya'),
      ],
      langkah: [
        'Seduh teh celup dengan air panas',
        'Tambahkan gula, aduk rata',
        'Biarkan hingga dingin',
        'Tambahkan es batu',
        'Siap disajikan'
      ],
      waktuMasak: 5,
      tingkatKesulitan: 'Sangat Mudah',
    );

    final resep4 = Resep(
      nama: 'Jus Alpukat',
      kategori: KategoriMakanan.minuman,
      bahan: [
        Bahan(nama: 'Alpukat matang', jumlah: '2', satuan: 'buah'),
        Bahan(nama: 'Susu kental manis', jumlah: '3', satuan: 'sdm'),
        Bahan(nama: 'Air', jumlah: '100', satuan: 'ml'),
        Bahan(nama: 'Es batu', jumlah: 'secukupnya'),
      ],
      langkah: [
        'Keruk alpukat masukkan ke blender',
        'Tambahkan susu kental manis dan air',
        'Blender hingga halus',
        'Tuang ke gelas dan tambahkan es batu'
      ],
      waktuMasak: 7,
      tingkatKesulitan: 'Mudah',
    );

    // Makanan Pembuka
    final resep5 = Resep(
      nama: 'Sup Jagung',
      kategori: KategoriMakanan.makananPembuka,
      bahan: [
        Bahan(nama: 'Jagung manis', jumlah: '2', satuan: 'buah'),
        Bahan(nama: 'Wortel', jumlah: '1', satuan: 'buah'),
        Bahan(nama: 'Kaldu ayam', jumlah: '500', satuan: 'ml'),
      ],
      langkah: [
        'Iris wortel dan pipil jagung',
        'Rebus kaldu ayam',
        'Masukkan wortel dan jagung',
        'Masak hingga matang',
        'Sajikan hangat'
      ],
      waktuMasak: 20,
      tingkatKesulitan: 'Mudah',
    );

    // Makanan Penutup
    final resep6 = Resep(
      nama: 'Puding Coklat',
      kategori: KategoriMakanan.makananPenutup,
      bahan: [
        Bahan(nama: 'Bubuk agar-agar coklat', jumlah: '1', satuan: 'bungkus'),
        Bahan(nama: 'Gula pasir', jumlah: '100', satuan: 'gram'),
        Bahan(nama: 'Susu cair', jumlah: '500', satuan: 'ml'),
      ],
      langkah: [
        'Campur bubuk agar, gula, dan susu',
        'Masak hingga mendidih',
        'Tuang ke cetakan',
        'Biarkan hingga dingin dan mengeras',
        'Sajikan'
      ],
      waktuMasak: 15,
      tingkatKesulitan: 'Mudah',
    );

    // Cemilan
    final resep7 = Resep(
      nama: 'Pisang Goreng',
      kategori: KategoriMakanan.cemilan,
      bahan: [
        Bahan(nama: 'Pisang kepok', jumlah: '5', satuan: 'buah'),
        Bahan(nama: 'Tepung terigu', jumlah: '100', satuan: 'gram'),
        Bahan(nama: 'Air', jumlah: '100', satuan: 'ml'),
        Bahan(nama: 'Minyak goreng', jumlah: 'secukupnya'),
      ],
      langkah: [
        'Kupas pisang dan belah dua',
        'Buat adonan tepung dan air',
        'Celupkan pisang ke adonan',
        'Goreng hingga kecokelatan',
        'Sajikan hangat'
      ],
      waktuMasak: 10,
      tingkatKesulitan: 'Mudah',
    );

    _manajerResep.tambahResep(resep1);
    _manajerResep.tambahResep(resep2);
    _manajerResep.tambahResep(resep3);
    _manajerResep.tambahResep(resep4);
    _manajerResep.tambahResep(resep5);
    _manajerResep.tambahResep(resep6);
    _manajerResep.tambahResep(resep7);
  }
}

void main() {
  final app = AplikasiResep();
  app.jalankan();
}
