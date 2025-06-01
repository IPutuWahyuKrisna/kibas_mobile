import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kibas_mobile/src/config/theme/colors.dart';
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
      // Ubah format DateTime menjadi "01 January 2024"
      final DateFormat formatter = DateFormat('dd MMMM yyyy');
      return formatter.format(date);
    }

    return Scaffold(
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
      body: BlocProvider(
        create: (context) =>
            meterInjec<ReadMeterBloc>()..add(GetListMeterEvent(token)),
        child: BlocBuilder<ReadMeterBloc, ReadMeterState>(
          builder: (context, state) {
            if (state is ReadMeterLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReadMeterLoaded) {
              final data = state.meterList;
              return RefreshIndicator(
                onRefresh: () async {
                  // Kirim ulang event untuk refresh data
                  context.read<ReadMeterBloc>().add(GetListMeterEvent(token));
                  // Opsional: tunggu beberapa detik agar animasi refresh terlihat
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
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
                                    formatDate(DateTime.parse(item
                                        .createdAt)), // Parse the string to DateTime first
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
                                      style:
                                          TypographyStyle.captionsBold.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Angka FInal : ${item.angkaFinal}",
                                style: TypographyStyle.captionsBold.copyWith(
                                    color: ColorConstants.blackColorPrimary),
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
          // Menggunakan pushNamed agar menunggu nilai balik dari halaman FormMeterEmployee
          final result = await context.pushNamed(RouteNames.postMeter);
          if (result == true) {
            final userService = coreInjection<UserLocalStorageService>();
            final user = userService.getUser();
            final token = user?.token ?? "";
            // ignore: use_build_context_synchronously
            context.read<ReadMeterBloc>().add(GetListMeterEvent(token));
          }
        },
        backgroundColor: ColorConstants.blueColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
