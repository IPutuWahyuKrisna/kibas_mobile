import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import '../../../../../../component/snack_bar.dart';
import '../../../../../../component/index_component.dart';
import '../../domain/entities/complaint_entity.dart';
import '../bloc/complaint_bloc.dart';

class PostComplaintEmployeePage extends StatefulWidget {
  final ComplaintEmployee complaint;

  const PostComplaintEmployeePage({super.key, required this.complaint});

  @override
  State<PostComplaintEmployeePage> createState() =>
      _PostComplaintEmployeePageState();
}

class _PostComplaintEmployeePageState extends State<PostComplaintEmployeePage> {
  final TextEditingController catatanController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool isSubmitting = false;

  Future<void> pickImageFromCamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  Future<void> pickImageFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  void submitComplaint() {
    if (selectedImage == null || catatanController.text.isEmpty) {
      CustomSnackBar.show(context, "Lengkapi foto dan catatan!",
          backgroundColor: Colors.orange);
      return;
    }
    print(widget.complaint.pengaduanId);
    setState(() => isSubmitting = true);

    context.read<ComplaintBloc>().add(
          SubmitComplaintEvent(
            pengaduanId: widget.complaint.pengaduanId,
            buktiFotoSelesai: selectedImage!,
            catatan: catatanController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Selesaikan Pengaduan",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[400],
      ),
      body: BlocConsumer<ComplaintBloc, ComplaintState>(
        listener: (context, state) {
          if (state is ComplaintSubmittedSuccess) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              CustomSnackBar.show(context, state.message,
                  backgroundColor: Colors.green);
            });
            Navigator.pop(context, true);
          } else if (state is ComplaintError) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              CustomSnackBar.show(context, state.message,
                  backgroundColor: Colors.red);
            });
            setState(() => isSubmitting = false);
          }
        },
        builder: (context, state) {
          if (state is ComplaintSubmitting || isSubmitting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.complaint.jenisPengaduan,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tanggal pengaduan: $widget.complaint.tanggalPengaduan',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${DateFormat("d MMMM yyyy").format(DateTime.parse("${widget.complaint.tanggalPengaduan}"))}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                    image: widget.complaint.linkUrl != "-"
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.complaint.linkUrl),
                          )
                        : const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              "assets/image.png",
                            ),
                          ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: catatanController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Catatan Penyelesaian',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: selectedImage == null
                      ? const Center(child: Icon(Icons.image, size: 50))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(selectedImage!, fit: BoxFit.cover),
                        ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: pickImageFromCamera,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text("Kamera"),
                    ),
                    ElevatedButton.icon(
                      onPressed: pickImageFromGallery,
                      icon: const Icon(Icons.photo),
                      label: const Text("Galeri"),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                PrimaryButton(
                  label: "Kirim Penyelesaian",
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  onPressed: submitComplaint,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
