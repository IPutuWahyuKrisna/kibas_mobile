import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../../config/theme/index_style.dart';
import '../../domain/entities/myannouncement.dart';
import '../bloc/notification_bloc.dart';

class NotificationPages extends StatefulWidget {
  const NotificationPages({super.key});

  @override
  State<NotificationPages> createState() => _NotificationPagesState();
}

class _NotificationPagesState extends State<NotificationPages> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(FetchMyAnnouncementsEvent());
  }

  String formatDate(DateTime date) {
    // Ubah format DateTime menjadi "01 January 2024"
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text(
          "Notifikasi Pengumuman",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[400],
        elevation: 0,
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationError) {
            return const Center(
              child: Text(
                "Belum ada notifikasi",
                style: TextStyle(color: ColorConstants.blackColorPrimary),
              ),
            );
          }

          if (state is NotificationLoaded) {
            final List<MyAnnouncementEntity> announcements =
                state.announcements;

            if (announcements.isEmpty) {
              return Container(
                child:
                    const Center(child: Text("Tidak ada pengumuman saat ini.")),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                final item = announcements[index];

                return GestureDetector(
                  // onTap: () {
                  //   context.goNamed(RouteNames.detailPengumuman, extra: item);
                  // },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: ColorConstants.backgroundSecondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Judul dan Scope
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.judul,
                                style: TypographyStyle.bodyBold.copyWith(
                                  color: ColorConstants.blackColorPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: item.targetScope == "pribadi"
                                    ? Colors.orange
                                    : Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                item.targetScope,
                                style: TypographyStyle.bodyMedium.copyWith(
                                  color: ColorConstants.blackColorPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        /// Periode
                        Text(
                          "Berlaku: ${formatDate(DateTime.parse(item.tanggalMulai))} - ${formatDate(DateTime.parse(item.tanggalBerakhir))}",
                          style: TypographyStyle.bodyMedium.copyWith(
                            color: ColorConstants.blackColorPrimary,
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// Isi preview konten
                        Text(
                          item.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TypographyStyle.bodyLight.copyWith(
                            color: ColorConstants.blackColorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox(); // default fallback
        },
      ),
    );
  }
}
