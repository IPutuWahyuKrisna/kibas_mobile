import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../component/snack_bar.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/services/rekening_injec.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../bloc/rekening_bloc.dart';

class RekeningListPage extends StatefulWidget {
  final int pelangganId;
  const RekeningListPage({super.key, required this.pelangganId});

  @override
  State<RekeningListPage> createState() => _RekeningListPageState();
}

class _RekeningListPageState extends State<RekeningListPage> {
  @override
  void initState() {
    super.initState();
    context.read<RekeningBloc>().add(FetchRekeningEvent(widget.pelangganId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => rekeningInjec<RekeningBloc>()
        ..add(FetchRekeningEvent(widget.pelangganId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Daftar Rekening Pelanggan"),
          backgroundColor: Colors.blue[400],
          elevation: 0,
        ),
        body: BlocBuilder<RekeningBloc, RekeningState>(
          builder: (context, state) {
            if (state is RekeningLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RekeningLoaded) {
              if (state.rekeningList.isEmpty) {
                return const Center(
                  child: Text(
                    "Anda belum memiliki rekening terdaftar.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  // Memicu event refresh untuk mengambil data terbaru
                  context
                      .read<RekeningBloc>()
                      .add(FetchRekeningEvent(widget.pelangganId));
                  // Tunggu sampai proses refresh selesai, misalnya 1 detik
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: state.rekeningList.length,
                  itemBuilder: (context, index) {
                    final rekening = state.rekeningList[index];
                    return GestureDetector(
                      onTap: () {
                        final path =
                            '/dashboard_user/rekening/${widget.pelangganId}/detail/${rekening.id}';
                        context.go(path);
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(
                            "No. Rekening: ${rekening.noRekening}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Pelanggan ID: ${rekening.pelangganId}"),
                              Text(
                                  "Lokasi: (${rekening.lat}, ${rekening.lng})"),
                              Text(
                                "Terdaftar: ${rekening.createdAt != null ? rekening.createdAt.toString() : 'Tidak Ada Data'}",
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is RekeningError) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                CustomSnackBar.show(context, state.message,
                    backgroundColor: Colors.red);
              });
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else {
              return const Center(child: Text("Belum ada data rekening."));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final userService = coreInjection<UserLocalStorageService>();
            final user = userService.getUser();
            final idUsers = user!.pelanggan?.id ?? "";
            // Gunakan push agar menunggu nilai balik dari halaman posting
            final result = await context
                .push("/dashboard_user/rekening/$idUsers/post_rekening");
            if (result == true) {
              // Jika halaman post mengembalikan true, refresh data
              // ignore: use_build_context_synchronously
              context
                  .read<RekeningBloc>()
                  .add(FetchRekeningEvent(widget.pelangganId));
            }
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
