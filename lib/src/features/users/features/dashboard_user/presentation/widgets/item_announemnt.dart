import 'package:flutter/material.dart';

import '../../../../../../config/routes/router.dart';
import '../../../../../../config/theme/index_style.dart';
import '../../../../../employee/features/dashbord_employee/domain/entities/announcement_entity.dart';

class ItemContantAnnouncement extends StatelessWidget {
  const ItemContantAnnouncement({
    super.key,
    required this.announcement,
  });

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed(
          RouteNames.detailPengumuman,
          extra: announcement,
        );
      },
      child: Container(
        height: 180,
        width: 350,
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          image: announcement.linkFoto != ""
              ? DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(announcement.linkFoto),
                )
              : const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/image.png"),
                ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 40,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Text(
              announcement.judul,
              style: TypographyStyle.bodyBold.copyWith(
                color: ColorConstants.whiteColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
