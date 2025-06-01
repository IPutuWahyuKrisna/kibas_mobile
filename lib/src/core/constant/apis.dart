class ApiUrls {
  static const baseURL = 'https://kibas.tirtadanuarta.com/api/v2';

  //Authentication
  static const register = '$baseURL/register';
  static const login = '$baseURL/login';

  //Pengaduan Pelanggan
  static const getPengaduanDetail = '$baseURL/pengaduan';
  static const getAllPengaduan = '$baseURL/pengaduan/all';
  static const postPengaduan = '$baseURL/pengaduan';
  static const putPengaduan = '$baseURL/pengaduan/update';
  static const getJenisPengaduan = '$baseURL/jenis-pengaduan';

  // Bacameter Pelanggan
  static const getReadMeter = '$baseURL/bacameter';
  static const postReadMeter = '$baseURL/bacameter';

  //Tagihan Pelanggan
  static const getTagihan = '$baseURL/tagihan/all';

  //Pengumuman Pelanggan
  static const getMyPengumuman = '$baseURL/pengumuman/all';
  static const getAllPengumuman = '$baseURL/pengumuman/general';

  //Pengmuman Pegawai
  static const getPengaduanPegawai = '$baseURL/pengaduan/pelanggan';
  static const putPengaduanPegawai = '$baseURL/pengaduan/pelanggan/update';

  static const logOut = '$baseURL/logout';
  static const userProfile = '${baseURL}users/profile';
  static const deleteComplaint = '$baseURL/pengaduan/';
  static const getArea = '$baseURL/pegawai-area';
  static const getKecamata = '$baseURL/kecamatan';
  static const getAreaRegist = '$baseURL/area';
  static const getGolongan = '$baseURL/golongan';
  static const getKelurahan = '$baseURL/kelurahan';
  static const getRayon = '$baseURL/rayon';
  static const putUsers = '$baseURL/update-profile';
  static const getRekening = '$baseURL/rekening?pelanggan_id=';
  static const detailRekening = '$baseURL/rekening/';
  static const postRekening = '$baseURL/rekening';
}
