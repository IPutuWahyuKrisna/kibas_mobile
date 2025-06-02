import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../../../component/snack_bar.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../../domain/entities/complaint_entity.dart';
import '../bloc/complaint_bloc.dart';

class ComplaintListEmployeePage extends StatefulWidget {
  const ComplaintListEmployeePage({super.key});

  @override
  State<ComplaintListEmployeePage> createState() =>
      _ComplaintListEmployeePageState();
}

class _ComplaintListEmployeePageState extends State<ComplaintListEmployeePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ComplaintBloc>().add(FetchComplaintsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text(
          'Pengaduan Masuk',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.blue[400],
      ),
      body: BlocListener<ComplaintBloc, ComplaintState>(
        listener: (context, state) {
          if (state is ComplaintSubmittedSuccess) {
            CustomSnackBar.show(context, state.message,
                backgroundColor: Colors.green);
            context.read<ComplaintBloc>().add(FetchComplaintsEvent());
          } else if (state is ComplaintError) {
            CustomSnackBar.show(context, state.message,
                backgroundColor: Colors.red);
          }
        },
        child: BlocBuilder<ComplaintBloc, ComplaintState>(
          builder: (context, state) {
            if (state is ComplaintLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ComplaintLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ComplaintBloc>().add(FetchComplaintsEvent());
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  itemCount: state.complaints.length,
                  itemBuilder: (context, index) {
                    final ComplaintEmployee complaint = state.complaints[index];
                    final tanggal = DateFormat("d MMMM yyyy").format(
                        DateTime.parse("${complaint.tanggalPengaduan}"));

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: InkWell(
                        onTap: () {
                          context.go(
                            '/dashboard_employee/list_complaint_employee/edit_complaint',
                            extra: complaint,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                complaint.jenisPengaduan,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tanggal pengaduan: $tanggal',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Status: ${complaint.namaPelanggan}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
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
            } else {
              return const Center(child: Text('Tidak ada data pengaduan.'));
            }
          },
        ),
      ),
    );
  }
}
