import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../component/snack_bar.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/services/rekening_injec.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../bloc/rekening_bloc.dart';

class RekeningDetailPage extends StatefulWidget {
  final int rekeningId;
  const RekeningDetailPage({super.key, required this.rekeningId});

  @override
  State<RekeningDetailPage> createState() => _RekeningDetailPageState();
}

class _RekeningDetailPageState extends State<RekeningDetailPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<RekeningBloc>()
        .add(FetchRekeningDetailEvent(widget.rekeningId));
  }

  Future<void> _refreshDetail() async {
    context
        .read<RekeningBloc>()
        .add(FetchRekeningDetailEvent(widget.rekeningId));
    // Optional delay for refresh indicator animation
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => rekeningInjec<RekeningBloc>()
        ..add(FetchRekeningDetailEvent(widget.rekeningId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Detail Rekening"),
          backgroundColor: Colors.blue[400],
          elevation: 0,
        ),
        body: BlocBuilder<RekeningBloc, RekeningState>(
          builder: (context, state) {
            if (state is RekeningDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RekeningDetailLoaded) {
              final rekening = state.rekeningDetail;
              return RefreshIndicator(
                onRefresh: _refreshDetail,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("No. Rekening: ${rekening.noRekening}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text("Pelanggan ID: ${rekening.pelangganId}"),
                            Text("Area ID: ${rekening.areaId}"),
                            Text("Kelurahan ID: ${rekening.kelurahanId}"),
                            Text("Kecamatan ID: ${rekening.kecamatanId}"),
                            Text("Golongan ID: ${rekening.golonganId}"),
                            Text("Rayon ID: ${rekening.rayonId}"),
                            Text("Lokasi: (${rekening.lat}, ${rekening.lng})"),
                            // Tambahkan padding ekstra agar tombol overlay tidak menutupi konten
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                      // Tombol Edit di posisi bawah
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: ElevatedButton(
                          onPressed: () async {
                            final editRekeningId = widget.rekeningId;
                            final userService =
                                coreInjection<UserLocalStorageService>();
                            final user = userService.getUser();
                            final idUsers = user!.pelanggan?.id ?? "";
                            // Gunakan push agar bisa menunggu nilai balik dari halaman edit
                            final result = await context.push(
                                '/dashboard_user/rekening/$idUsers/detail/$editRekeningId/edit/$editRekeningId');
                            // Jika nilai balik adalah true, refresh detail rekening
                            if (result == true) {
                              // ignore: use_build_context_synchronously
                              context.read<RekeningBloc>().add(
                                  FetchRekeningDetailEvent(widget.rekeningId));
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
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is RekeningDetailError) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                CustomSnackBar.show(context, state.message,
                    backgroundColor: Colors.red);
              });
              return Center(child: Text("Error: ${state.message}"));
            } else {
              return const Center(child: Text("Tidak ada data."));
            }
          },
        ),
      ),
    );
  }
}
