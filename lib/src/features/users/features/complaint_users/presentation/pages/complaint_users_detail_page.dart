import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:kibas_mobile/src/component/index_component.dart';
import '../../../../../../component/snack_bar.dart';
import '../../../../../../config/theme/index_style.dart';
import '../../../../../../core/services/complaint_users_services.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../bloc/complaint_usres_bloc.dart';

class ComplaintDetailUsersPage extends StatefulWidget {
  final int id;

  const ComplaintDetailUsersPage({super.key, required this.id});

  @override
  State<ComplaintDetailUsersPage> createState() =>
      _ComplaintDetailUsersPageState();
}

class _ComplaintDetailUsersPageState extends State<ComplaintDetailUsersPage> {
  final TextEditingController _ratingController = TextEditingController();

  @override
  void dispose() {
    _ratingController.dispose();
    super.dispose();
  }

  String truncateText(String text, [int length = 25]) {
    if (text.length <= length) {
      return text;
    } else {
      return '${text.substring(0, length)}...';
    }
  }

  void _submitRating() {
    final rating = int.tryParse(_ratingController.text);
    if (rating != null && rating >= 1 && rating <= 5) {
      context.read<ComplaintUsersBloc>().add(
            SubmitRatingComplaintEvent(
              pengaduanId: widget.id,
              rating: rating,
            ),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rating harus di antara 1 hingga 5")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final token = user?.token ?? "";
    final namaPelanggan = user?.pelanggan?.namaPelanggan ?? "";

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstants.backgroundSecondary,
      appBar: AppBar(
        title: const Text(
          'Detail Pengaduan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.blue[400],
      ),
      body: BlocProvider(
        create: (context) => complaintUsersInjec<ComplaintUsersBloc>()
          ..add(FetchComplaintDetailUsersEvent(token, widget.id)),
        child: BlocConsumer<ComplaintUsersBloc, ComplaintUsersState>(
          listener: (context, state) {
            if (state is DeleteComplaintSuccess) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                CustomSnackBar.show(context, state.message,
                    backgroundColor: Colors.green);
                Navigator.pop(context, true);
              });
            } else if (state is PutComplaintSuccess) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                CustomSnackBar.show(context, state.message,
                    backgroundColor: Colors.green);

                // Refresh ulang data
                context.read<ComplaintUsersBloc>().add(
                      FetchComplaintDetailUsersEvent(token, widget.id),
                    );
              });
            }
          },
          builder: (context, state) {
            if (state is ComplaintUsersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ComplaintDetailUsersLoaded) {
              final complaint = state.complaint;

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

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ComplaintUsersBloc>().add(
                        FetchComplaintDetailUsersEvent(token, widget.id),
                      );
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    truncateText(complaint.jenisPengaduan),
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
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
                              const SizedBox(height: 6),
                              Text(
                                'Pada tanggal ${DateFormat("d MMMM yyyy").format(DateTime.parse("${complaint.tanggalPengaduan}"))} anda $namaPelanggan melakukan pengaduan terkait keluhan karena ${complaint.jenisPengaduan}',
                                style: TypographyStyle.subTitleMedium.copyWith(
                                  color: ColorConstants.greyColorsecondary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Petugas yang ditugaskan adalah ${complaint.namaPegawai}',
                                style: TypographyStyle.subTitleMedium.copyWith(
                                  color: ColorConstants.greyColorsecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          decoration: BoxDecoration(
                            image: complaint.linkUrl != "-"
                                ? DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage("${complaint.linkUrl}"),
                                  )
                                : const DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      "assets/image.png",
                                    ),
                                  ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          decoration: BoxDecoration(
                            image: complaint.buktiFotoSelesai != "-"
                                ? DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        complaint.buktiFotoSelesai),
                                  )
                                : const DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      "assets/image.png",
                                    ),
                                  ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (index) {
                            if (index < (complaint.rating ?? 0).toInt()) {
                              return const Icon(
                                Iconsax.star1,
                                color: Colors.amber,
                                size: 40,
                              );
                            } else {
                              return const Icon(
                                Iconsax.star,
                                color: Colors.grey,
                                size: 40,
                              );
                            }
                          }),
                        ),
                        const SizedBox(height: 30),
                        BasicForm(
                          label: "Beri Nilai",
                          inputType: TextInputType.number,
                          controller: _ratingController,
                          hintText: "Rating (1 - 5)",
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: _submitRating,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: complaint.status.toLowerCase() == "selesai"
                                  ? ColorConstants.purpleColor
                                  : ColorConstants.greyColorPrimary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                "Beri Nilai",
                                style: TypographyStyle.bodySemiBold.copyWith(
                                  color: ColorConstants.backgroundColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
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
