import 'package:buck_tanley_app/SetUp.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';

class FriendWidget extends StatelessWidget {
  final UserDTO friend;
  const FriendWidget({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    Imager? imager = ImageConverter.decodeImage(friend.image);
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
        ),
        onPressed: () {},
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: imager == null
                  ? AssetImage("assets/images/BuckTanleyLogo.png")
                  : (foundation.kIsWeb
                      ? (imager.webImage == null ? AssetImage("assets/images/BuckTanleyLogo.png") : MemoryImage(imager.webImage!)) // 웹
                      : (imager.mobileImage == null ? AssetImage("assets/images/BuckTanleyLogo.png") : FileImage(imager.mobileImage!))), // 모바일
              backgroundColor: Color.fromARGB(255, 209, 209, 209),
            ),
            SizedBox(width: 20),
            Text(
              friend.nickname,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                friend.introduction,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            () {
              var color = Colors.grey;
              if (friend.status == 1) color = Colors.green;
              if (friend.status == 2) color = Colors.blue;
              if (friend.status == 3) color = Colors.red;
              return Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
              );
            }()
          ],
        ),
      ),
    );
  }
}
