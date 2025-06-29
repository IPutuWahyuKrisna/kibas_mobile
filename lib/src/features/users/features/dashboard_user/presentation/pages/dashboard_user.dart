import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kibas_mobile/src/core/services/global_service_locator.dart';
import 'package:kibas_mobile/src/features/employee/features/dashbord_employee/domain/entities/announcement_entity.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../../component/snack_bar.dart';
import '../../../../../../config/routes/router.dart';
import '../../../../../../config/theme/index_style.dart';
import '../../../../../../core/services/dashboard_employee_services.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../../../../../employee/features/dashbord_employee/presentation/bloc/dashbord_employee_bloc.dart';
import '../widgets/item_announemnt.dart';

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
        child: ListView(
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
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: const DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/unknown.jpg')),
                              ),
                            ),
                            // const CircleAvatar(
                            //   backgroundImage: AssetImage('assets/unknown.jpg'),
                            //   radius: 50,
                            // ),
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
                            height: 100,
                            margin: const EdgeInsets.only(right: 20),
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/logo_kibas.png'))),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Informasi Tarif",
                style: TypographyStyle.headingBold
                    .copyWith(color: ColorConstants.blueColor),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    openFile(
                        url:
                            "https://kibas.tirtadanuarta.com/storage/files/informasi_tarif.pdf",
                        fileName: "informasi_tarif.pdf");
                  },
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            "assets/brosur1.png",
                          ),
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Center(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 40,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Informasi Tarif",
                            style: TypographyStyle.bodyBold
                                .copyWith(color: ColorConstants.whiteColor),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Berita Bangli Terkini",
                style: TypographyStyle.headingBold
                    .copyWith(color: ColorConstants.blueColor),
              ),
            ),
            SizedBox(
              height: 200,
              child: BlocProvider(
                create: (context) =>
                    dashboardEmployeeInjec<DashbordEmployeeBloc>()
                      ..add(GetAnnouncementsEvent(
                          token)), // Ambil data pengumuman awal
                child: BlocBuilder<DashbordEmployeeBloc, DashbordEmployeeState>(
                  builder: (context, state) {
                    print(state);

                    if (state is DashboardUnauthenticated) {
                      coreInjection<UserLocalStorageService>().clearUser();

                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        context.goNamed(RouteNames.login);
                      });

                      CustomSnackBar.show(
                        context,
                        "Anda belum login, silahkan login terlebih dahulu",
                        backgroundColor: Colors.red,
                      );
                    }

                    if (state is DashboardLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DashboardLoaded) {
                      // Clone list agar tidak mengubah state asli
                      final announcements = [...state.announcements];

                      // Urutkan berdasarkan tanggal terbaru (pastikan createdAt adalah DateTime atau bisa diparse)
                      announcements.sort((a, b) =>
                          DateTime.parse(b.tanggalMulai)
                              .compareTo(DateTime.parse(a.tanggalMulai)));

                      return RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<DashbordEmployeeBloc>()
                              .add(GetAnnouncementsEvent(token));
                          await Future.delayed(const Duration(seconds: 1));
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 20),
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            itemCount: announcements.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final announcement = announcements[index];
                              return ItemContantAnnouncement(
                                  announcement: announcement);
                            },
                          ),
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
            )
          ],
        ),
      ),
    );
  }
}
