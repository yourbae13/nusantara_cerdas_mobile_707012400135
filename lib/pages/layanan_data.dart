class Layanan {
  const Layanan({
    required this.nama,
    required this.bidang,
    required this.dinas,
    required this.jam,
    required this.keterangan,
  });

  final String nama;
  final String bidang;
  final String dinas;
  final String jam;
  final String keterangan;
}

const dataLayanan = <String, List<Layanan>>{
  'Perizinan': [
    Layanan(
      nama: 'Izin Usaha',
      bidang: 'Perizinan',
      dinas: 'Dinas Penanaman Modal',
      jam: '08.00 - 15.00',
      keterangan: 'Pengurusan izin usaha mikro dan kecil.',
    ),
    Layanan(
      nama: 'Izin Mendirikan Bangunan',
      bidang: 'Perizinan',
      dinas: 'Dinas Pekerjaan Umum',
      jam: '08.00 - 14.00',
      keterangan: 'Persetujuan bangunan gedung dan renovasi.',
    ),
    Layanan(
      nama: 'Izin Keramaian',
      bidang: 'Perizinan',
      dinas: 'Satpol PP',
      jam: '08.00 - 16.00',
      keterangan: 'Izin penyelenggaraan acara di ruang publik.',
    ),
  ],
  'Kesehatan': [
    Layanan(
      nama: 'Pendaftaran Puskesmas',
      bidang: 'Kesehatan',
      dinas: 'Dinas Kesehatan',
      jam: '07.00 - 12.00',
      keterangan: 'Pendaftaran antrean berobat secara daring.',
    ),
    Layanan(
      nama: 'Imunisasi Anak',
      bidang: 'Kesehatan',
      dinas: 'Dinas Kesehatan',
      jam: '08.00 - 11.00',
      keterangan: 'Jadwal dan pendaftaran imunisasi dasar.',
    ),
    Layanan(
      nama: 'Ambulans Gawat Darurat',
      bidang: 'Kesehatan',
      dinas: 'Dinas Kesehatan',
      jam: '24 jam',
      keterangan: 'Permintaan ambulans untuk kondisi darurat.',
    ),
  ],
  'Transportasi': [
    Layanan(
      nama: 'Jadwal Bus Kota',
      bidang: 'Transportasi',
      dinas: 'Dinas Perhubungan',
      jam: '05.00 - 21.00',
      keterangan: 'Informasi rute dan jadwal bus kota.',
    ),
    Layanan(
      nama: 'Uji Kir Kendaraan',
      bidang: 'Transportasi',
      dinas: 'Dinas Perhubungan',
      jam: '08.00 - 15.00',
      keterangan: 'Pendaftaran uji berkala kendaraan bermotor.',
    ),
    Layanan(
      nama: 'Izin Trayek',
      bidang: 'Transportasi',
      dinas: 'Dinas Perhubungan',
      jam: '08.00 - 14.00',
      keterangan: 'Pengajuan izin trayek angkutan umum.',
    ),
  ],
};

List<Layanan> get semuaLayanan => [
  for (final daftar in dataLayanan.values) ...daftar,
];
