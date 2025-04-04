import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kibas_mobile/src/core/services/global_service_locator.dart';
import '../../../../../../component/snack_bar.dart';
import '../../../../../../config/routes/router.dart';
import '../../../../../../core/services/dashboard_employee_services.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../bloc/dashbord_employee_bloc.dart';

class DashboardEmployeePages extends StatelessWidget {
  const DashboardEmployeePages({super.key});

  @override
  Widget build(BuildContext context) {
    // 🟢 Ambil data user dari local storage
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final token = user?.token ?? "";
    final email = user?.email ?? "Email tidak ditemukan";
    final role = user?.role ?? "Role tidak ditemukan";

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
                      'Mobile Petugas',
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
                              role, // 🟢 Tampilkan role
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: 200,
                              child: Text(
                                email, // 🟢 Tampilkan email
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('assets/new photo.png'),
                              height: 190,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Tirta Danu Arta',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
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
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      try {
                        context.goNamed(RouteNames.meterEmployee);
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
                        context.goNamed(RouteNames.areaPegawai);
                        // ignore: empty_catches
                      } catch (e) {}
                    },
                    child: const Column(
                      children: [
                        Image(
                          image: AssetImage('assets/area.png'),
                          width: 80,
                          height: 80,
                        ),
                        Text('Area'),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      try {
                        context.goNamed(RouteNames.listComplaintGet);
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
            const SizedBox(height: 20),
            // Pengumuman List
            Expanded(
              child: BlocProvider(
                create: (context) =>
                    dashboardEmployeeInjec<DashbordEmployeeBloc>()
                      ..add(GetAnnouncementsEvent(
                          token)), // 🟢 Gunakan token untuk API
                child: BlocBuilder<DashbordEmployeeBloc, DashbordEmployeeState>(
                  builder: (context, state) {
                    if (state is DashboardLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DashboardLoaded) {
                      final announcements = state.announcements;
                      return ListView.builder(
                        itemCount: announcements.length,
                        itemBuilder: (context, index) {
                          final announcement = announcements[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      announcement.judul, // Judul pengumuman
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    SizedBox(
                                      width: 300,
                                      child: Text(
                                        announcement
                                            .pengumuman, // Detail pengumuman
                                        textAlign: TextAlign.start,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      announcement.areaName,
                                      textAlign:
                                          TextAlign.right, // Area pengumuman
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.cyan,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is DashboardError) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        CustomSnackBar.show(context, state.message,
                            backgroundColor: Colors.red);
                      });
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
