import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kibas_mobile/src/core/services/read_meter_services.dart';
import '../../../../../../component/snack_bar.dart';
import '../../../../../../config/routes/router.dart';
import '../../../../../../config/theme/index_style.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../bloc/read_meter_bloc.dart';

class MeterEmployee extends StatelessWidget {
  const MeterEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final token = user?.token ?? "";

    String formatDate(DateTime date) {
      final DateFormat formatter = DateFormat('dd MMMM yyyy');
      return formatter.format(date);
    }

    return BlocProvider(
      create: (context) =>
          meterInjec<ReadMeterBloc>()..add(GetListMeterEvent(token)),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          title: const Text(
            'Baca Meter Mandiri',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.blue[400],
        ),
        body: BlocListener<ReadMeterBloc, ReadMeterState>(
          listener: (context, state) {
            print("ini state saat ini $state");
            if (state is PostMeterSuccess) {
              context.read<ReadMeterBloc>().add(GetListMeterEvent(token));
            }
          },
          child: BlocBuilder<ReadMeterBloc, ReadMeterState>(
            builder: (context, state) {
              if (state is ReadMeterLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ReadMeterLoaded) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ReadMeterBloc>().add(GetListMeterEvent(token));
                    await Future.delayed(const Duration(seconds: 1));
                  },
                  child: ListView.builder(
                    itemCount: state.meterList.length,
                    itemBuilder: (context, index) {
                      final item = state.meterList[index];
                      Color getStatusColor(String status) {
                        switch (status.toLowerCase()) {
                          case 'belum-terverifikasi':
                            return Colors.amber;
                          case 'gagal':
                            return Colors.red;
                          case 'terverifikasi':
                            return Colors.green;
                          default:
                            return Colors.grey;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatDate(
                                          DateTime.parse(item.createdAt)),
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: getStatusColor(item.status),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        item.status,
                                        style: TypographyStyle.captionsBold
                                            .copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Angka Final : ${item.angkaFinal}",
                                  style: TypographyStyle.captionsBold.copyWith(
                                    color: ColorConstants.blackColorPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is ReadMeterError) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  CustomSnackBar.show(context, "Tidak Ada Data",
                      backgroundColor: Colors.red);
                });
                return const Center(child: Text('No data found'));
              } else {
                return const Center(child: Text('No data found'));
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await context.pushNamed(RouteNames.postMeter);
            if (result == true) {
              context.read<ReadMeterBloc>().add(GetListMeterEvent(token));
            }
          },
          backgroundColor: ColorConstants.blueColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
