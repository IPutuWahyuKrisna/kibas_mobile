import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../component/snack_bar.dart';
import '../../../../../../core/services/complaint_services.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../bloc/complaint_bloc.dart';

class ComplaintDetailPage extends StatelessWidget {
  final int id;

  const ComplaintDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final token = user?.token ?? "";
    // 🟢 Log cek

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
        create: (context) => complaintInjec<ComplaintBloc>()
          ..add(FetchComplaintDetailEvent(token, id)),
        child: BlocBuilder<ComplaintBloc, ComplaintState>(
          builder: (context, state) {
            if (state is ComplaintLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ComplaintDetailLoaded) {
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
              return SingleChildScrollView(
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(judul,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: statusColor, // Warna sesuai status
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 10),
                                      child: Text(
                                        statusText, // Teks sesuai status
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text('Tanggal Lapor: ',
                                      style: TextStyle(color: Colors.grey)),
                                  Text("$date",
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                ],
                              ),
                              const Row(
                                children: [
                                  Text('Tanggal Konfirmasi: ',
                                      style: TextStyle(color: Colors.grey)),
                                  Text('2024-01-02',
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ComplaintError) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                CustomSnackBar.show(context, state.message,
                    backgroundColor: Colors.red);
              });
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Tidak ada data.'));
            }
          },
        ),
      ),
    );
  }
}
