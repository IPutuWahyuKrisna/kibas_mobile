import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
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
      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['status'] == 'success') {
          final List<dynamic> data = responseData['data'] ?? [];
          final loadedJenis =
              data.map((item) => JenisPengaduanModel.fromJson(item)).toList();

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

  void submitComplaint() async {
    isLoadingJenisPengaduan = true;
    if (selectedImage == null || selectedJenis == null) {
      CustomSnackBar.show(
        context,
        'Lengkapi gambar dan jenis pengaduan',
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
      isLoadingJenisPengaduan = false;
    } catch (e) {
      setState(() {
        isLoadingJenisPengaduan = false;
        isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mendapatkan lokasi: $e")),
      );
    }
  }

  Widget _buildLoadingIndicator() => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
          ],
        ),
      );

  Widget _loadingIndicator() => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
          ],
        ),
      );

  Widget _buildErrorView() => Center(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Buat Pengaduan',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.blue[400],
      ),
      body: BlocConsumer<ComplaintUsersBloc, ComplaintUsersState>(
        listener: (context, state) {
          if (state is PostComplaintSuccess) {
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
          if ((state is ComplaintUsersLoading && isSubmitting) ||
              isLoadingJenisPengaduan) {
            return _buildLoadingIndicator();
          }

          if (errorMessage != null || jenisPengaduanList.isEmpty) {
            return _buildErrorView();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                DropdownButtonFormField<JenisPengaduanModel>(
                  isExpanded: true,
                  initialValue: selectedJenis,
                  items: jenisPengaduanList.map((jenis) {
                    return DropdownMenuItem<JenisPengaduanModel>(
                      value: jenis,
                      child: Text(jenis.nama),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectedJenis = value),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: selectedImage == null
                      ? const Center(child: Icon(Icons.camera_alt, size: 40))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.file(selectedImage!,
                              fit: BoxFit.cover, width: double.infinity),
                        ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: pickImage, child: const Text('Camera')),
                    ElevatedButton(
                        onPressed: pickImageGalery,
                        child: const Text('Galeri')),
                  ],
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: "Simpan",
                  onPressed: submitComplaint,
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
