import 'package:flutter/material.dart';
import 'package:kibas_mobile/src/core/services/global_service_locator.dart';
import '../../../../../../config/routes/router.dart';
import '../../../../../../config/theme/index_style.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../../../../../employee/features/dashbord_employee/domain/entities/announcement_entity.dart';

class AnnouncementDetail extends StatefulWidget {
  const AnnouncementDetail({super.key});

  @override
  State<AnnouncementDetail> createState() => _AnnouncementDetailState();
}

class _AnnouncementDetailState extends State<AnnouncementDetail> {
  @override
  Widget build(BuildContext context) {
    final announcement = GoRouterState.of(context).extra as Announcement;
    // 🟢 Ambil data user dari local storage
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final email = user?.email;
    final rekening = user?.pelanggan?.rekening;

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
                            SizedBox(
                              width: 200,
                              child: Text(
                                email!, // Tampilkan email
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('assets/logo_kibas.png'),
                                height: 190,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Tirta Danu Arta',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              )
                            ],
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
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 350,
                          decoration: BoxDecoration(
                            image: announcement.linkFoto != "-"
                                ? DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(announcement.linkFoto),
                                  )
                                : const DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      "assets/home/profile.jpg",
                                    ),
                                  ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Text(
                          announcement.judul,
                          style: TypographyStyle.headingMedium.copyWith(
                            color: ColorConstants.blackColorPrimary,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          announcement.content,
                          style: TypographyStyle.bodyMedium.copyWith(
                              color: ColorConstants.blackColorPrimary),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  )),
            ))
          ],
        ),
      ),
    );
  }
}
