import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../component/index_component.dart';
import '../../../../../../component/snack_bar.dart';
import '../../../../../../config/theme/index_style.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../bloc/read_meter_bloc.dart';

class FormMeterEmployee extends StatefulWidget {
  const FormMeterEmployee({super.key});

  @override
  _FormMeterEmployeeState createState() => _FormMeterEmployeeState();
}

class _FormMeterEmployeeState extends State<FormMeterEmployee> {
  final TextEditingController angkaFinalController = TextEditingController();
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> pickImageGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void submit() {
    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih gambar terlebih dahulu!")),
      );
      return;
    }

    if (angkaFinalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Harap isi semua bidang terlebih dahulu!")),
      );
      return;
    }

    if (angkaFinalController.text.length > 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Angka maksimal hanya 4 digit!")),
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
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final token = user?.token ?? "";

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
              context.read<ReadMeterBloc>().add(GetListMeterEvent(token));
            });

            setState(() {
              selectedImage = null;
              angkaFinalController.clear();
            });

            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pop(context, true);
            });
          } else if (state is PostMeterFailure) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              CustomSnackBar.show(context, state.error,
                  backgroundColor: Colors.red);
            });
          }
        },
        builder: (context, state) {
          if (state is PostMeterLoading) {
            return const Center(child: CircularProgressIndicator());
          }

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Angka Meter',
                            style: TextStyle(
                              color: ColorConstants.blackColorPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
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
                                  hintText: 'Masukkan angka',
                                ),
                                style: TypographyStyle.bodyLight
                                    .copyWith(color: Colors.black),
                              ),
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
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  pickImageGallery();
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
                                      "Galeri",
                                      style: TypographyStyle.captionsBold
                                          .copyWith(
                                              color: ColorConstants
                                                  .blackColorPrimary),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          PrimaryButton(
                            label: "Simpan",
                            onPressed: submit,
                            height: 45,
                            width: MediaQuery.of(context).size.width,
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
