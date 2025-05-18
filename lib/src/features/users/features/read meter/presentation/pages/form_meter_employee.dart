import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../component/snack_bar.dart';
import '../../../../../../config/theme/index_style.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../bloc/read_meter_bloc.dart';

class FormMeterEmployee extends StatefulWidget {
  const FormMeterEmployee({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FormMeterEmployeeState createState() => _FormMeterEmployeeState();
}

class _FormMeterEmployeeState extends State<FormMeterEmployee> {
  final TextEditingController noRekeningController = TextEditingController();
  final TextEditingController angkaFinalController = TextEditingController();
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool isSubmitting = false;

  /// 🔹 Fungsi untuk memilih gambar dari galeri
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
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

  /// 🔹 Fungsi untuk mengirim data ke Bloc
  void submit() {
    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih gambar terlebih dahulu!")),
      );
      return;
    }

    if (noRekeningController.text.isEmpty ||
        angkaFinalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Harap isi semua bidang terlebih dahulu!")),
      );
      return;
    }
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final noSambungan = "${user?.pelanggan?.noPelanggan}";

    context.read<ReadMeterBloc>().add(PostMeterRequested(
          imageFile: selectedImage!,
          noRekening: noSambungan,
          angkaFinal: angkaFinalController.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          'Baca Meter Mandiri',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.blue[400],
      ),
      body: BlocConsumer<ReadMeterBloc, ReadMeterState>(
        listener: (context, state) {
          if (state is PostMeterSuccess) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              CustomSnackBar.show(context, state.message,
                  backgroundColor: Colors.green);
            });
            setState(() {
              isSubmitting = false;
              selectedImage = null;
              noRekeningController.clear();
              angkaFinalController.clear();
            });
            Future.delayed(const Duration(seconds: 2), () {
              // ignore: use_build_context_synchronously
              Navigator.pop(context, true);
            });
          } else if (state is PostMeterFailure) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              CustomSnackBar.show(context, "Gagal menambah data baca meter",
                  backgroundColor: Colors.red);
            });
            setState(() {
              isSubmitting = false;
            });
          }
        },
        builder: (context, state) {
          return Column(
            children: [
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
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                textAlign: TextAlign.left,
                                'Angka Meter',
                                style: TextStyle(
                                  color: ColorConstants.blackColorPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 3),
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: ColorConstants.backgroundColor),
                                child: Center(
                                  child: TextFormField(
                                    controller: angkaFinalController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Masukan angka',
                                    ),
                                    style: TypographyStyle.bodyLight
                                        .copyWith(color: Colors.black),
                                    // const TextStyle(
                                    //     fontSize: 16,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
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
                                            color: ColorConstants
                                                .greyColorsecondary,
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
                                            color: ColorConstants
                                                .greyColorsecondary,
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
                        ],
                      ),
                      const SizedBox(height: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: isSubmitting ? null : submit,
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  isSubmitting
                                      ? Colors.grey
                                      : Colors.blue[400]),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                            child: isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text(
                                    'Simpan',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                          ),
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
