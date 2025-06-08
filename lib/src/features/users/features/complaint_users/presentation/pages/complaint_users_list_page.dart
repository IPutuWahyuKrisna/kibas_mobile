import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kibas_mobile/src/config/theme/index_style.dart';
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
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final token = user?.token ?? "";
    final namaPelanggan = user!.pelanggan?.namaPelanggan ?? "";
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
                  context
                      .read<ComplaintUsersBloc>()
                      .add(FetchAllComplaintsUsersEvent(token));
                  // Opsional: tambahkan delay agar animasi refresh did
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  itemCount: state.complaints.length,
                  itemBuilder: (context, index) {
                    final complaint = state.complaints[index];

                    // Menentukan teks dan warna status

                    Color statusColor;

                    switch (complaint.status.toLowerCase()) {
                      case 'pending':
                        statusColor = Colors.orangeAccent;
                        break;
                      case 'proses':
                        statusColor = Colors.lightBlue;
                        break;
                      case 'selesai':
                        statusColor = Colors.teal;
                        break;
                      default:
                        statusColor = Colors.grey;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: InkWell(
                        onTap: () {
                          context.go(
                              '/dashboard_user/list_complaint_users/detail_complaint_users/${complaint.id}');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: ColorConstants.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      complaint.jenisPengaduan,
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
                                        complaint.status,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                  'Pada tanggal ${DateFormat("d MMMM yyyy").format(DateTime.parse("${complaint.tanggalPengaduan}"))} anda $namaPelanggan melakukan pengaduan terkait keluhan karena ${complaint.jenisPengaduan}',
                                  style:
                                      TypographyStyle.subTitleMedium.copyWith(
                                    color: ColorConstants.greyColorsecondary,
                                  )),
                              const SizedBox(height: 10),
                              Text('Petugas yang di tugaskan adalah ',
                                  style:
                                      TypographyStyle.subTitleMedium.copyWith(
                                    color: ColorConstants.greyColorsecondary,
                                  )),
                            ],
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
              return const Center(child: Text('Tidak ada data.'));
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
