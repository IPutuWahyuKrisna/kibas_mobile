import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../component/basic_form_small.dart';
import '../../../../../../component/snack_bar.dart';
import '../../../../../../config/routes/router.dart';
import '../../../../../../config/theme/index_style.dart';
import '../../../../../../core/services/complaint_users_services.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../../data/models/put_complaint_model.dart';
import '../bloc/complaint_usres_bloc.dart';

class ComplaintDetailUsersPage extends StatelessWidget {
  final int id;

  const ComplaintDetailUsersPage({super.key, required this.id});

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "Hapus Pengaduan",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: const Text(
          "Apakah Anda yakin ingin menghapus pengaduan ini?",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Batal",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              // Kirim event delete ke Bloc
              context.read<ComplaintUsersBloc>().add(DeleteComplaintEvent(id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  /// Fungsi untuk menampilkan form edit dari bawah secara asinkron dan mengembalikan nilai jika sukses
  Future<bool?> _showEditComplaintForm(
      BuildContext context, int id, String keluhan) async {
    final TextEditingController keluhanController =
        TextEditingController(text: keluhan);
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final idPelanggan = user!.pelanggan!.id;

    final result = await showModalBottomSheet<bool>(
      backgroundColor: ColorConstants.backgroundColor,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BlocProvider.value(
          value:
              context.read<ComplaintUsersBloc>(), // Pakai Bloc yang sudah ada
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Edit Pengaduan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                BasicFormSmall(
                  label: "Keluhan",
                  hintText: "Masukan keluhan anda",
                  inputType: TextInputType.text,
                  controller: keluhanController,
                ),
                const SizedBox(height: 20),
                BlocConsumer<ComplaintUsersBloc, ComplaintUsersState>(
                  listener: (context, state) {
                    if (state is PutComplaintSuccess) {
                      // Kembali dengan nilai true agar parent tahu edit sukses
                      Navigator.pop(context, true);
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        CustomSnackBar.show(context, state.message,
                            backgroundColor: Colors.green);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                      // Opsi: refresh detail di sini jika diperlukan
                      final token = user.token;
                      context.read<ComplaintUsersBloc>().add(
                            FetchComplaintDetailUsersEvent(token, id),
                          );
                    } else if (state is ComplaintUsersError) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        CustomSnackBar.show(context, state.message,
                            backgroundColor: Colors.red);
                      });
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: state is ComplaintUsersLoading
                          ? null
                          : () {
                              final updatedComplaint = PutComplaintModel(
                                id: id,
                                keluhan: keluhanController.text,
                                pelangganId: idPelanggan,
                              );
                              context.read<ComplaintUsersBloc>().add(
                                    SubmitPutComplaintEvent(
                                        putComplaint: updatedComplaint),
                                  );
                            },
                      child: state is ComplaintUsersLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              "Simpan Perubahan",
                              style: TypographyStyle.bodySemiBold.copyWith(
                                  color: ColorConstants.backgroundColor),
                            ),
                    );
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final token = user?.token ?? "";

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text(
          'Detail Pengaduan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.blue[400],
      ),
      body: BlocProvider(
        create: (context) => complaintUsersInjec<ComplaintUsersBloc>()
          ..add(FetchComplaintDetailUsersEvent(token, id)),
        child: BlocConsumer<ComplaintUsersBloc, ComplaintUsersState>(
          listener: (context, state) {
            if (state is DeleteComplaintSuccess) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                CustomSnackBar.show(context, state.message,
                    backgroundColor: Colors.green);
              });
              Navigator.pop(context, true);
            } else if (state is PutComplaintSuccess) {
              // Jika edit sukses, form bottom sheet sudah menutup dengan nilai true.
              // Di sini bisa ditambahkan aksi lain jika diperlukan.
              SchedulerBinding.instance.addPostFrameCallback((_) {
                CustomSnackBar.show(context, state.message,
                    backgroundColor: Colors.green);
              });
              context.goNamed(RouteNames.dashboardUser);
            }
          },
          builder: (context, state) {
            if (state is ComplaintUsersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ComplaintDetailUsersLoaded) {
              final complaint = state.complaint;
              final date = complaint.createdAt;
              final judul = complaint.keluhan;

              String statusText;
              Color statusColor;

              switch (complaint.status) {
                case 1:
                  statusText = "Menunggu";
                  statusColor = Colors.blue;
                  break;
                case 2:
                  statusText = "Proses";
                  statusColor = Colors.amber;
                  break;
                case 3:
                  statusText = "Selesai";
                  statusColor = Colors.green;
                  break;
                default:
                  statusText = "Tidak Diketahui";
                  statusColor = Colors.grey;
              }

              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
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
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(19),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(judul,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text('Tanggal Lapor: ',
                                          style: TextStyle(color: Colors.grey)),
                                      Text("$date",
                                          style: const TextStyle(
                                              color: Colors.grey)),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text('Status: ',
                                          style: TextStyle(color: Colors.grey)),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: statusColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          statusText,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Tombol Edit & Hapus di Bawah
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Tombol Edit
                          ElevatedButton(
                            onPressed: () async {
                              // Panggil fungsi edit dan tunggu hasilnya
                              final result = await _showEditComplaintForm(
                                  context, id, complaint.keluhan);
                              if (result == true) {
                                // Jika edit sukses, refresh detail pengaduan
                                // ignore: use_build_context_synchronously
                                context.read<ComplaintUsersBloc>().add(
                                      FetchComplaintDetailUsersEvent(token, id),
                                    );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Edit",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),

                          /// Tombol Hapus
                          ElevatedButton(
                            onPressed: () {
                              _showDeleteConfirmation(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Hapus",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('Tidak ada data.'));
            }
          },
        ),
      ),
    );
  }
}
