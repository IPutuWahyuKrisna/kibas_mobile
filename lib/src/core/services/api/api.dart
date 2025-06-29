class ApiEndpoint {
  static const String baseUrl = 'https://kibas.tirtadanuarta.com/api/v2';

  //Authentication
  static const register = '$baseUrl/register';
  static const login = '$baseUrl/login';

  //Pengaduan Pelanggan
  static const getPengaduanDetail = '$baseUrl/pengaduan';
  static const getAllPengaduan = '$baseUrl/pengaduan/all';
  static const postPengaduan = '$baseUrl/pengaduan';
  static const putPengaduan = '$baseUrl/pengaduan/update';
  static const getJenisPengaduan = '$baseUrl/jenis-pengaduan';

  // Bacameter Pelanggan
  static const getReadMeter = '$baseUrl/bacameter';
  static const postReadMeter = '$baseUrl/bacameter';

  //Tagihan Pelanggan
  static const getTagihan = '$baseUrl/tagihan/all';

  //Pengumuman Pelanggan
  static const getMyPengumuman = '$baseUrl/pengumuman/all';
  static const getAllPengumuman = '$baseUrl/pengumuman/general';

  //Pengmuman Pegawai
  static const getPengaduanPegawai = '$baseUrl/pengaduan/pelanggan';
  static const putPengaduanPegawai = '$baseUrl/pengaduan/pelanggan/update';

  static const logOut = '$baseUrl/logout';
  static const userProfile = '${baseUrl}users/profile';
  static const deleteComplaint = '$baseUrl/pengaduan/';
  static const getArea = '$baseUrl/pegawai-area';
  static const getKecamata = '$baseUrl/kecamatan';
  static const getAreaRegist = '$baseUrl/area';
  static const getGolongan = '$baseUrl/golongan';
  static const getKelurahan = '$baseUrl/kelurahan';
  static const getRayon = '$baseUrl/rayon';
  static const putUsers = '$baseUrl/update-profile';
  static const getRekening = '$baseUrl/rekening?pelanggan_id=';
  static const detailRekening = '$baseUrl/rekening/';
  static const postRekening = '$baseUrl/rekening';
}
