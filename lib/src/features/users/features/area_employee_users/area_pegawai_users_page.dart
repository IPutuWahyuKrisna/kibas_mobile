import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kibas_mobile/src/config/theme/colors.dart';
import 'package:kibas_mobile/src/core/services/area_pegawai_services.dart';

import '../../../../component/snack_bar.dart';
import '../../../../core/services/global_service_locator.dart';
import '../../../../core/utils/user_local_storage_service.dart';
import '../../../employee/features/area_employee/presentation/bloc/area_employee_bloc.dart';

class AreaPegawaiUserPage extends StatelessWidget {
  const AreaPegawaiUserPage({super.key});

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
          'Area Pegawai',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.blue[400],
      ),
      body: BlocProvider(
        create: (context) =>
            areaInjec<AreaEmployeeBloc>()..add(FetchAreaPegawaiEvent(token)),
        child: BlocBuilder<AreaEmployeeBloc, AreaEmployeeState>(
          builder: (context, state) {
            if (state is AreaPegawaiLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AreaPegawaiLoaded) {
              final area = state.areaPegawai;
              return Container(
                height: 210,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ColorConstants.backgroundSecondary),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Text(
                        'Nama Pegawai: ${area.pegawaiName}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      color: ColorConstants.blackColorSecondary,
                      height: 2,
                    ),
                    Container(
                      padding: const EdgeInsetsDirectional.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Area Bertugas:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          ...area.areaBertugas.map(
                            (area) => Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, bottom: 4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.blue),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      area,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is AreaPegawaiError) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                CustomSnackBar.show(context, state.message,
                    backgroundColor: Colors.red);
              });
              return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.red)),
              );
            } else {
              return const Center(child: Text('Tidak ada data.'));
            }
          },
        ),
      ),
    );
  }
}
