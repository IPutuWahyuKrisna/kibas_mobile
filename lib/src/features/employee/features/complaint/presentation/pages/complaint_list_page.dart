import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kibas_mobile/src/core/services/complaint_services.dart';
import '../../../../../../component/snack_bar.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../bloc/complaint_bloc.dart';

class ComplaintListPage extends StatelessWidget {
  const ComplaintListPage({super.key});

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
          'Daftar Pengaduan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.blue[400],
      ),
      body: BlocProvider(
        create: (context) => complaintInjec<ComplaintBloc>()
          ..add(FetchAllComplaintsEvent(token)),
        child: BlocBuilder<ComplaintBloc, ComplaintState>(
          builder: (context, state) {
            if (state is ComplaintLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AllComplaintsLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: state.complaints.length,
                itemBuilder: (context, index) {
                  final complaint = state.complaints[index];

                  // Menentukan teks dan warna status
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

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: InkWell(
                      onTap: () {
                        context.go(
                            '/dashboard_employee/list_complaint/detail_complaint/${complaint.id}');
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      complaint.keluhan, // Menampilkan keluhan
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
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
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Keluhan ',
                                          style: TextStyle(color: Colors.grey)),
                                      Text('Nama Pelanggan ',
                                          style: TextStyle(color: Colors.grey)),
                                      Text('Tanggal Keluhan ',
                                          style: TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(': ${complaint.keluhan}',
                                          style: const TextStyle(
                                              color: Colors.black)),
                                      Text(': ${complaint.namaPelanggan}',
                                          style: const TextStyle(
                                              color: Colors.black)),
                                      Text(
                                          ': ${complaint.createdAt ?? "Tidak Ada Data"}',
                                          style: const TextStyle(
                                              color: Colors.black)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
