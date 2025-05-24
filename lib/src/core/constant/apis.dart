class ApiUrls {
  static const baseURL = 'https://kibas.tirtadanuarta.com/api/v2';

  //Authentication
  static const register = '$baseURL/register';
  static const login = '$baseURL/login';
  static const logOut = '$baseURL/logout';

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
  static const getMyPengumuman = '$baseURL/pengumuman';
  static const getAllPengumuman = '$baseURL/pengumuman/all';
  static const getPengumumanArea = '$baseURL/pengumuman/all';
  static const getPengumumanKecamatan = '$baseURL/pengumuman/all';
  static const getPengumumanKelurahan = '$baseURL/pengumuman/all';
  static const getPengumumanRayon = '$baseURL/pengumuman/all';

  static const userProfile = '${baseURL}users/profile';
  static const allAnnounsment = '$baseURL/pengumuman-all';
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
