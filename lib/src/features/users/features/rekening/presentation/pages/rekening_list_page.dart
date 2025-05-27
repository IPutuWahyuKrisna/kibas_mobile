import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/scheduler.dart';
import '../../../../../../component/snack_bar.dart';
import '../../../../../../config/theme/index_style.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../bloc/rekening_bloc.dart';

class RekeningListPage extends StatefulWidget {
  const RekeningListPage({super.key});

  @override
  State<RekeningListPage> createState() => _RekeningListPageState();
}

class _RekeningListPageState extends State<RekeningListPage> {
  @override
  void initState() {
    super.initState();
    context.read<RekeningBloc>().add(const FetchTagihanEvent());
  }

  @override
  Widget build(BuildContext context) {
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text(
          "Daftar Rekening Pelanggan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[400],
        elevation: 0,
      ),
      body: BlocBuilder<RekeningBloc, RekeningState>(
        builder: (context, state) {
          if (state is TagihanLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TagihanError) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              CustomSnackBar.show(
                context,
                state.message,
                backgroundColor: Colors.red,
                icon: Icons.error_outline,
              );
            });
            return Center(child: Text(state.message));
          } else if (state is TagihanLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<RekeningBloc>().add(const FetchTagihanEvent());
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                itemCount: state.tagihanList.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: ColorConstants.backgroundSecondary,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("No. Sambungan: ${user!.pelanggan?.rekening}",
                              style: TypographyStyle.bodyBold.copyWith(
                                  color: ColorConstants.blackColorPrimary)),
                          Text("Nama: ${user.pelanggan?.namaPelanggan}",
                              style: TypographyStyle.bodyLight.copyWith(
                                  color: ColorConstants.blackColorPrimary)),
                          Text("Alamat: ${user.pelanggan?.alamatPelanggan}",
                              style: TypographyStyle.bodyLight.copyWith(
                                  color: ColorConstants.blackColorPrimary)),
                          Text("Kecamatan: ${user.pelanggan?.kecamatan}",
                              style: TypographyStyle.bodyLight.copyWith(
                                  color: ColorConstants.blackColorPrimary)),
                          Text("Area: ${user.pelanggan?.area}",
                              style: TypographyStyle.bodyLight.copyWith(
                                  color: ColorConstants.blackColorPrimary)),
                          Text("No Pelanggan: ${user.pelanggan?.noPelanggan}",
                              style: TypographyStyle.bodyLight.copyWith(
                                  color: ColorConstants.blackColorPrimary)),
                        ],
                      ),
                    );
                  } else {
                    final tagihan = state.tagihanList[index - 1];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tagihan",
                              style: TypographyStyle.headingBold.copyWith(
                                  color: ColorConstants.blackColorPrimary)),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: ColorConstants.backgroundSecondary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(tagihan.periode,
                                        style: TypographyStyle.bodyBold
                                            .copyWith(
                                                color: ColorConstants
                                                    .blackColorPrimary)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: tagihan.statusBadge == "danger"
                                            ? Colors.red
                                            : Colors.green,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        tagihan.status,
                                        style: TypographyStyle.bodyLight
                                            .copyWith(color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text("Total Tagihan: ${tagihan.totalTagihan}",
                                    style: TypographyStyle.bodyLight.copyWith(
                                        color:
                                            ColorConstants.blackColorPrimary)),
                                Text("Denda: ${tagihan.denda}",
                                    style: TypographyStyle.bodyLight.copyWith(
                                        color:
                                            ColorConstants.blackColorPrimary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            );
          } else {
            return const Center(child: Text("Tidak ada data tagihan."));
          }
        },
      ),
    );
  }
}
