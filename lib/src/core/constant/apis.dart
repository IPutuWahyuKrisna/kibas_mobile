class ApiUrls {
  static const baseURL = 'https://kibas.tirtadanuarta.com/api/v1';
  static const register = '$baseURL/register';
  static const userProfile = '${baseURL}users/profile';
  static const login = '$baseURL/login';
  static const logOut = '$baseURL/logout';
  static const allAnnounsment = '$baseURL/pengumuman-all';
  static const readMeterGet = '$baseURL/baca-meter';
  static const readMeterPost = '$baseURL/baca-meter';
  static const complaint = '$baseURL/pengaduan';
  static const postComplaint = '$baseURL/pengaduan';
  static const deleteComplaint = '$baseURL/pengaduan/';
  static const getArea = '$baseURL/pegawai-area';
  static const getKecamata = '$baseURL/kecamatan';
  static const getAreaRegist = '$baseURL/area';
  static const getGolongan = '$baseURL/golongan';
  static const getKelurahan = '$baseURL/kelurahan';
  static const getRayon = '$baseURL/rayon';
  static const putUsers = '$baseURL/update-profile';
  static const putComplaint = '$baseURL/pengaduan/';
  static const getRekening = '$baseURL/rekening?pelanggan_id=';
  static const detailRekening = '$baseURL/rekening/';
  static const postRekening = '$baseURL/rekening';
}
