import 'package:flutter/material.dart';
import '../../../../../../config/theme/index_style.dart';

class NotificationPages extends StatelessWidget {
  const NotificationPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Rekening Pelanggan"),
        backgroundColor: Colors.blue[400],
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: 3,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // final path =
              //     '/dashboard_user/rekening/${widget.pelangganId}/detail/${rekening.id}';
              // context.go(path);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.blue[400],
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "January",
                        style: TypographyStyle.bodyBold
                            .copyWith(color: ColorConstants.whiteColor),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: ColorConstants.errorColor,
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        child: Text(
                          "belum di bayar",
                          style: TypographyStyle.bodyLight
                              .copyWith(color: ColorConstants.whiteColor),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total kilometer: 23.563",
                        style: TypographyStyle.bodyLight
                            .copyWith(color: ColorConstants.whiteColor),
                      ),
                      Text(
                        "Total Nominal: 190.000",
                        style: TypographyStyle.bodyLight
                            .copyWith(color: ColorConstants.whiteColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
