import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../component/snack_bar.dart';
import '../../../../../../config/routes/router.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../bloc/complaint_usres_bloc.dart';

class ComplaintListUsersPage extends StatefulWidget {
  const ComplaintListUsersPage({super.key});

  @override
  State<ComplaintListUsersPage> createState() => _ComplaintListUsersPageState();
}

class _ComplaintListUsersPageState extends State<ComplaintListUsersPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final token = user?.token ?? "";

    // Fetch data ulang saat halaman muncul kembali
    context.read<ComplaintUsersBloc>().add(FetchAllComplaintsUsersEvent(token));
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocListener<ComplaintUsersBloc, ComplaintUsersState>(
        listener: (context, state) {
          if (state is PostComplaintSuccess ||
              state is DeleteComplaintSuccess ||
              state is PutComplaintSuccess) {
            // Jika ada perubahan data, fetch ulang daftar pengaduan
            final userService = coreInjection<UserLocalStorageService>();
            final user = userService.getUser();
            final token = user?.token ?? "";
            context
                .read<ComplaintUsersBloc>()
                .add(FetchAllComplaintsUsersEvent(token));
          }
        },
        child: BlocBuilder<ComplaintUsersBloc, ComplaintUsersState>(
          builder: (context, state) {
            if (state is ComplaintUsersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AllComplaintsUsersLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  final userService = coreInjection<UserLocalStorageService>();
                  final user = userService.getUser();
                  final token = user?.token ?? "";
                  context
                      .read<ComplaintUsersBloc>()
                      .add(FetchAllComplaintsUsersEvent(token));
                  // Opsional: tambahkan delay agar animasi refresh terlihat
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: ListView.builder(
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
                              '/dashboard_user/list_complaint_users/detail_complaint_users/${complaint.id}');
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
                                        complaint.keluhan,
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
                                        color: statusColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 10),
                                        child: Text(
                                          statusText,
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
                                            style:
                                                TextStyle(color: Colors.grey)),
                                        Text('Nama Pelanggan ',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                        Text('Tanggal Keluhan ',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: Text(': ${complaint.keluhan}',
                                              style: const TextStyle(
                                                  color: Colors.black)),
                                        ),
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
                ),
              );
            } else if (state is ComplaintUsersError) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Menggunakan pushNamed agar dapat menunggu nilai balik (return value)
          final result = await context.pushNamed(RouteNames.postComplaint);
          // ADDED: Jika nilai balik adalah true, refresh daftar pengaduan
          if (result == true) {
            final userService = coreInjection<UserLocalStorageService>();
            final user = userService.getUser();
            final token = user?.token ?? "";
            // ignore: use_build_context_synchronously
            context
                .read<ComplaintUsersBloc>()
                .add(FetchAllComplaintsUsersEvent(token));
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
