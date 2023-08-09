class TablesDB {
  static const String _mPetugas =
      "CREATE TABLE m_petugas (idpetugas INTEGER PRIMARY KEY,namapetugas TEXT ,password TEXT ,level INTEGER ,access_token TEXT ,refresh_token TEXT ,expired TEXT)";

  static const String _unit = "CREATE TABLE unit ("
      "kodewilayah TEXT PRIMARY KEY,"
      "nama TEXT ,"
      "gps_l TEXT ,"
      "gps_b TEXT )";

  static const String _pembacaan =
      "CREATE TABLE pembacaan (idbaca INTEGER PRIMARY KEY,blth TEXT NOT NULL,nosal TEXT NOT NULL,nama TEXT,alamat TEXT,tarif TEXT, no_hp TEXT,keterangan TEXT,jadwal_baca TEXT,jadwal_baca_int INTEGER DEFAULT 0,tanggal_baca TEXT,tanggal_baca_int INTEGER DEFAULT 0,koderbm TEXT,koderbm_urut INTEGER DEFAULT 0,kodewilayah TEXT,stan_lalu INTEGER DEFAULT 0,stan_ini INTEGER DEFAULT 0,stan_pakai INTEGER DEFAULT 0,stan_pakai_rata INTEGER DEFAULT 0,lbkb_utama TEXT,lbkb_a TEXT,lbkb_b TEXT,lbkb_c TEXT,gps_lat TEXT,gps_long TEXT,rc TEXT,message TEXT,status_sisipan INTEGER DEFAULT 0,status_baca INTEGER DEFAULT 0,status_pengiriman INTEGER DEFAULT 0,UNIQUE(blth, nosal) ON CONFLICT REPLACE)";

  static const String _msetting =
      "CREATE TABLE m_setting (id TEXT PRIMARY KEY, value TEXT)";

  static const String _foto = "CREATE TABLE foto ("
      "idfoto INTEGER PRIMARY KEY AUTOINCREMENT,"
      "nosal TEXT,"
      "koderbm TEXT,"
      "blth TEXT,"
      "tipe_foto INTEGER,"
      "location TEXT,"
      "nama_foto TEXT,"
      "keterangan TEXT,"
      "jenis_foto TEXT,"
      "status_pengiriman INTEGER DEFAULT 0,"
      "rc TEXT,"
      "message TEXT)";

  static const String _mRbm = "CREATE TABLE m_rbm ("
      "idrbm INTEGER PRIMARY KEY AUTOINCREMENT,"
      "blth TEXT,"
      "koderbm TEXT,"
      "alamat TEXT,"
      "jadwal_baca TEXT,"
      "jadwal_baca_int INTEGER,"
      "jml_plg INTEGER DEFAULT 0,"
      "jml_baca INTEGER DEFAULT 0,"
      "jml_data_terkirim INTEGER DEFAULT 0,"
      "jml_foto_terkirim INTEGER DEFAULT 0,"
      "UNIQUE(blth, koderbm) ON CONFLICT REPLACE)";

  static const String _mLbkb = "CREATE TABLE m_lbkb ("
      "idlbkb INTEGER PRIMARY KEY,"
      "nama_lbkb TEXT NOT NULL)";

  static const String _insertPetugas =
      "INSERT OR IGNORE INTO m_petugas (idpetugas, namapetugas) VALUES (1, 'sholeh')";

  final _listTables = [
    _mPetugas,
    _pembacaan,
    _msetting,
    _foto,
    _mRbm,
    _mLbkb,
    _insertPetugas,
    _unit,
  ];

  List<String> getTables() {
    return _listTables;
  }
}
