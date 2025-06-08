import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kibas_mobile/src/core/services/global_service_locator.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../../component/snack_bar.dart';
import '../../../../../../config/routes/router.dart';
import '../../../../../../config/theme/index_style.dart';
import '../../../../../../core/services/dashboard_employee_services.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../../../../../employee/features/dashbord_employee/presentation/bloc/dashbord_employee_bloc.dart';

class DashboardUserPages extends StatefulWidget {
  const DashboardUserPages({super.key});

  @override
  State<DashboardUserPages> createState() => _DashboardUserPagesState();
}

class _DashboardUserPagesState extends State<DashboardUserPages> {
  @override
  Widget build(BuildContext context) {
    // 🟢 Ambil data user dari local storage
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final token = user?.token ?? "";
    final idUsers = user!.pelanggan?.id ?? "";
    final email = user.email;
    final rekening = user.pelanggan?.rekening;
    final nama = user.pelanggan?.namaPelanggan;

    Future<File?> downloadFile(String url, String fileName) async {
      final appStorage = await getApplicationDocumentsDirectory();
      final file = File("${appStorage.path}/$fileName");

      try {
        // Tampilkan loading dialog
        showDialog(
          context: context,
          barrierDismissible:
              false, // User tidak bisa menutup dialog dengan tap di luar
          builder: (context) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Mengunduh file..."),
              ],
            ),
          ),
        );

        final response = await Dio().get(
          url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: const Duration(seconds: 0),
          ),
        );

        final raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();

        // Tutup dialog setelah selesai
        Navigator.of(context).pop();

        return file;
      } catch (e) {
        // Tutup dialog jika terjadi error
        Navigator.of(context).pop();
        return null;
      }
    }

    Future openFile({required String url, required String fileName}) async {
      final file = await downloadFile(url, fileName);
      if (file == null) {
        // Tampilkan pesan error jika download gagal
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal mengunduh file")),
        );
        return;
      }

      print("Path: ${file.path}");
      OpenFile.open(file.path);
    }

    String truncateText(String text, [int length = 25]) {
      if (text.length <= length) {
        return text;
      } else {
        return '${text.substring(0, length)}...';
      }
    }

    String truncateTextBody(String text, [int length = 100]) {
      if (text.length <= length) {
        return text;
      } else {
        return '${text.substring(0, length)}...';
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.lightBlue[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(color: Colors.blue[400]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mobile Pelanggan',
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                backgroundColor: Colors.white,
                                title: const Text(
                                  "Logout",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                content: const Text(
                                  "Apakah Anda yakin ingin logout?",
                                  style: TextStyle(fontSize: 16),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      "Batal",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context); // Tutup dialog
                                      coreInjection<UserLocalStorageService>()
                                          .clearUser();
                                      context.go(
                                          '/login'); // Navigasi ke halaman login
                                    },
                                    child: const Text(
                                      "Logout",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.logout_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Profile Section
            Container(
              decoration: BoxDecoration(color: Colors.blue[400]),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage('assets/unknown.jpg'),
                              radius: 50,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "$rekening", // Tampilkan role
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 5),

                            // kalo bisa kasi antara nama sama email
                            SizedBox(
                              width: 200,
                              child: Text(
                                nama ?? email, // Tampilkan email
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Image(
                                  image: AssetImage('assets/logo_kibas.png'),
                                  height: 190,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    openFile(
                                        url:
                                            "https://kibas.tirtadanuarta.com/storage/files/informasi_tarif.pdf",
                                        fileName: "informasi_tarif.pdf");
                                  },
                                  child: Container(
                                    width: 200,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: Center(
                                      child: Text("Informasi Tarif",
                                          style: TypographyStyle.bodyMedium
                                              .copyWith(
                                                  color: ColorConstants
                                                      .blackColorPrimary)),
                                    ),
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
            ),
            const SizedBox(height: 20),
            // Menu Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      try {
                        if (rekening != "") {
                          context.go(
                              '/dashboard_user/rekening'); // 🔥 Format benar
                        } else {}
                        // ignore: empty_catches
                      } catch (e) {}
                    },
                    child: const Column(
                      children: [
                        Image(
                          image: AssetImage('assets/menu4.png'),
                          width: 80,
                          height: 80,
                        ),
                        Text('Rekening'),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      try {
                        if (idUsers != "") {
                          context.go(
                              '/dashboard_user/notifikasi'); // 🔥 Format benar
                        } else {}
                        // ignore: empty_catches
                      } catch (e) {}
                    },
                    child: const Column(
                      children: [
                        Image(
                          image: AssetImage('assets/menu2.png'),
                          width: 80,
                          height: 80,
                        ),
                        Text('Notifikasi'),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      try {
                        context.goNamed(RouteNames.getMeter);
                        // ignore: empty_catches
                      } catch (e) {}
                    },
                    child: const Column(
                      children: [
                        Image(
                          image: AssetImage('assets/menu1.png'),
                          width: 80,
                          height: 80,
                        ),
                        Text('Baca Meter'),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      try {
                        context.go('/dashboard_user/list_complaint_users');
                        // ignore: empty_catches
                      } catch (e) {}
                    },
                    child: const Column(
                      children: [
                        Image(
                          image: AssetImage('assets/menu3.png'),
                          width: 80,
                          height: 80,
                        ),
                        Text('Pengaduan'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Pengumuman List
            const SizedBox(height: 20),

            Expanded(
              child: BlocProvider(
                create: (context) =>
                    dashboardEmployeeInjec<DashbordEmployeeBloc>()
                      ..add(GetAnnouncementsEvent(
                          token)), // Ambil data pengumuman awal
                child: BlocBuilder<DashbordEmployeeBloc, DashbordEmployeeState>(
                  builder: (context, state) {
                    print(state);
                    if (state is DashboardUnauthenticated) {
                      // Clear user data
                      coreInjection<UserLocalStorageService>().clearUser();

                      // Navigate to login after current frame is rendered
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        context.goNamed(RouteNames.login);
                      });

                      // Show snackbar
                      CustomSnackBar.show(
                        context,
                        "Anda belum login, silahkan login terlebih dahulu",
                        backgroundColor: Colors.red,
                      );
                    }
                    if (state is DashboardLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DashboardLoaded) {
                      final announcements = state.announcements;
                      return RefreshIndicator(
                        onRefresh: () async {
                          // Trigger event refresh
                          context
                              .read<DashbordEmployeeBloc>()
                              .add(GetAnnouncementsEvent(token));
                          // Opsional: beri delay agar animasi refresh terlihat
                          await Future.delayed(const Duration(seconds: 1));
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          itemCount: announcements.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final announcement = announcements[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: GestureDetector(
                                onTap: () {
                                  context.goNamed(
                                    RouteNames.detailPengumuman,
                                    extra:
                                        announcement, // pastikan ini adalah AnnouncementEntity
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            truncateText(
                                              announcement.judul,
                                            ), // Judul pengumuman
                                            textAlign: TextAlign.left,
                                            style: TypographyStyle.bodyBold
                                                .copyWith(
                                                    color: ColorConstants
                                                        .blackColorPrimary)),
                                        const SizedBox(height: 15),
                                        SizedBox(
                                          width: 300,
                                          child: Text(
                                              truncateTextBody(announcement
                                                  .content), // Detail pengumuman
                                              textAlign: TextAlign.start,
                                              style: TypographyStyle
                                                  .captionsMedium
                                                  .copyWith(
                                                      color: ColorConstants
                                                          .greyColorPrimary)),
                                        ),
                                        const SizedBox(height: 15),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is DashboardError) {
                      return const Center(child: Text("Data Tidak ditemukan"));
                    } else {
                      return const Center(child: Text('No data found!'));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
