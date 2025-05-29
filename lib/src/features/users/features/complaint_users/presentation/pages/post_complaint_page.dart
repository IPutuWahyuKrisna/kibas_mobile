import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kibas_mobile/src/config/theme/colors.dart';
import 'package:kibas_mobile/src/config/theme/index_style.dart';
import 'package:kibas_mobile/src/core/constant/apis.dart';
import '../../../../../../component/index_component.dart';
import '../../../../../../component/snack_bar.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../../data/models/jenis_pengaduan.dart';
import '../bloc/complaint_usres_bloc.dart';

class PostComplaintPage extends StatefulWidget {
  const PostComplaintPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PostComplaintPageState createState() => _PostComplaintPageState();
}

class _PostComplaintPageState extends State<PostComplaintPage> {
  final TextEditingController complaintController = TextEditingController();
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool isSubmitting = false;
  bool isLoadingJenisPengaduan = true;
  String? errorMessage;

  List<JenisPengaduanModel> jenisPengaduanList = [];
  JenisPengaduanModel? selectedJenis;

  @override
  void initState() {
    super.initState();
    fetchJenisPengaduan();
  }

  /// 🔹 Fungsi untuk memilih gambar dari galeri
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Layanan lokasi dinonaktifkan.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Izin lokasi ditolak.');
      }
    }

    return await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high));
  }

  Future<void> fetchJenisPengaduan() async {
    setState(() {
      isLoadingJenisPengaduan = true;
      errorMessage = null;
    });
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final token = user?.token ?? "";
    try {
      final response = await Dio().get(
        ApiUrls.getJenisPengaduan,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print('Raw response: ${response.data}');
      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData is! Map<String, dynamic>) {
          throw Exception('Format response tidak valid');
        }

        if (responseData['status'] == 'success') {
          final List<dynamic> data = responseData['data'] ?? [];

          if (data.isEmpty) {
            setState(() {
              errorMessage = 'Tidak ada data jenis pengaduan tersedia';
              isLoadingJenisPengaduan = false;
            });
            return;
          }

          final List<JenisPengaduanModel> loadedJenis = [];

          for (var item in data) {
            try {
              loadedJenis.add(JenisPengaduanModel.fromJson(item));
            } catch (e) {
              debugPrint('Gagal memparsing item: $e');
            }
          }

          setState(() {
            jenisPengaduanList = loadedJenis;
            selectedJenis = loadedJenis.isNotEmpty ? loadedJenis.first : null;
            isLoadingJenisPengaduan = false;
          });
        } else {
          setState(() {
            errorMessage = responseData['message'] ??
                "Gagal mengambil data jenis pengaduan";
            isLoadingJenisPengaduan = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Gagal mengambil data (${response.statusCode})";
          isLoadingJenisPengaduan = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Terjadi kesalahan: ${e.toString()}";
        isLoadingJenisPengaduan = false;
      });
      debugPrint('Error fetchJenisPengaduan: $e');
    }
  }

  Future<void> pickImageGalery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  /// 🔹 Fungsi untuk mengirim data ke Bloc
  void submitComplaint() async {
    if (selectedImage == null) {
      CustomSnackBar.show(
        context,
        'Peringatan\nSilahkan pilih gambar terlebih dahulu',
        backgroundColor: Colors.orange,
      );
      return;
    }

    if (selectedJenis == null) {
      CustomSnackBar.show(
        context,
        'Peringatan\ntolong pilih jenis pengaduan',
        backgroundColor: Colors.orange,
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final position = await getCurrentLocation();
      context.read<ComplaintUsersBloc>().add(
            SubmitComplaintEvent(
              image: selectedImage!,
              complaint: complaintController.text,
              latitude: position.latitude,
              longitude: position.longitude,
              jenisPengaduan: selectedJenis!.id,
            ),
          );
    } catch (e) {
      setState(() {
        isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mendapatkan lokasi: $e")),
      );
    }
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Memuat jenis pengaduan...'),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 50),
          const SizedBox(height: 20),
          Text(errorMessage ?? 'Terjadi kesalahan',
              style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: fetchJenisPengaduan,
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          'Buat Pengaduan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.blue[400],
      ),
      body: BlocConsumer<ComplaintUsersBloc, ComplaintUsersState>(
        listener: (context, state) {
          if (state is PostComplaintSuccess) {
            // Tampilkan pesan sukses dan reset UI
            SchedulerBinding.instance.addPostFrameCallback((_) {
              CustomSnackBar.show(context, state.message,
                  backgroundColor: Colors.green);
            });
            setState(() {
              isSubmitting = false;
              selectedImage = null;
              complaintController.clear();
            });

            Navigator.pop(context, true);
          } else if (state is ComplaintUsersError) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              CustomSnackBar.show(context, state.message,
                  backgroundColor: Colors.red);
            });
            setState(() {
              isSubmitting = false;
            });
          }
        },
        builder: (context, state) {
          if (isLoadingJenisPengaduan) {
            return _buildLoadingIndicator();
          }

          if (errorMessage != null) {
            return _buildErrorView();
          }

          if (jenisPengaduanList.isEmpty) {
            return _buildErrorView();
          }

          return Column(
            children: [
              /// 🔹 Header Styling
              Container(
                height: 35,
                decoration: BoxDecoration(color: Colors.blue[400]),
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[50],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(80),
                      topRight: Radius.circular(80),
                    ),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      /// 🔹 Input untuk Jenis Pengaduan
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Jenis Pengaduan',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<JenisPengaduanModel>(
                            isExpanded: true,
                            value: selectedJenis,
                            items: jenisPengaduanList.map((jenis) {
                              return DropdownMenuItem<JenisPengaduanModel>(
                                value: jenis,
                                child: Text(jenis.nama),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedJenis = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// 🔹 Upload Gambar
                      Container(
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: selectedImage == null
                            ? const Center(
                                child: Icon(Icons.camera_alt, size: 40),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                      ),
                      const SizedBox(height: 10),

                      /// 🔹 Tombol Upload dari Galeri
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                pickImage();
                              },
                              child: Container(
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                    color: ColorConstants.whiteColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color:
                                            ColorConstants.greyColorsecondary,
                                        width: 0.5)),
                                child: Center(
                                  child: Text(
                                    "Camera",
                                    style: TypographyStyle.captionsBold
                                        .copyWith(
                                            color: ColorConstants
                                                .blackColorPrimary),
                                  ),
                                ),
                              )),
                          GestureDetector(
                              onTap: () {
                                pickImageGalery();
                              },
                              child: Container(
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                    color: ColorConstants.whiteColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color:
                                            ColorConstants.greyColorsecondary,
                                        width: 0.5)),
                                child: Center(
                                  child: Text(
                                    "Galery",
                                    style: TypographyStyle.captionsBold
                                        .copyWith(
                                            color: ColorConstants
                                                .blackColorPrimary),
                                  ),
                                ),
                              )),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// 🔹 Tombol Simpan
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          PrimaryButton(
                            label: "Simpan",
                            onPressed: () {
                              submitComplaint();
                            },
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            isLoading: state is ComplaintUsersLoading,
                            enabled: state is! ComplaintUsersLoading,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
