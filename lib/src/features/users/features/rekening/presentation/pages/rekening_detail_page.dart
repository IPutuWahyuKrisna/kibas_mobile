import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kibas_mobile/src/config/theme/colors.dart';
import 'package:kibas_mobile/src/config/theme/index_style.dart';

import '../../../../../../component/snack_bar.dart';
import '../../../../../../core/services/rekening_injec.dart';
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
          backgroundColor: Colors.lightBlue[50],
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
                  child: Container(
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
                        Text("No. Rekening: ${rekening.noRekening}",
                            style: TypographyStyle.bodyBold.copyWith(
                                color: ColorConstants.blackColorPrimary)),
                        Text(
                          "Pelanggan ID: ${rekening.pelangganId}",
                          style: TypographyStyle.bodyLight.copyWith(
                              color: ColorConstants.blackColorPrimary),
                        ),
                        Text(
                          "Area: ${state.labelMapping['area']}",
                          style: TypographyStyle.bodyLight.copyWith(
                              color: ColorConstants.blackColorPrimary),
                        ),
                        Text(
                          "Kecamatan: ${state.labelMapping['kecamatan']}",
                          style: TypographyStyle.bodyLight.copyWith(
                              color: ColorConstants.blackColorPrimary),
                        ),
                        Text(
                          "Kelurahan: ${state.labelMapping['kelurahan']}",
                          style: TypographyStyle.bodyLight.copyWith(
                              color: ColorConstants.blackColorPrimary),
                        ),
                        Text(
                          "Golongan: ${state.labelMapping['golongan']}",
                          style: TypographyStyle.bodyLight.copyWith(
                              color: ColorConstants.blackColorPrimary),
                        ),
                        Text(
                          "Rayon: ${state.labelMapping['rayon']}",
                          style: TypographyStyle.bodyLight.copyWith(
                              color: ColorConstants.blackColorPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is RekeningDetailError) {
              SchedulerBinding.instance.addPostFrameCallback(
                (_) {
                  CustomSnackBar.show(context, state.message,
                      backgroundColor: Colors.red);
                },
              );
              return Center(
                child: Text("Belum Ada Data"),
              );
            } else {
              return const Center(
                child: Text("Tidak ada data."),
              );
            }
          },
        ),
      ),
    );
  }
}
