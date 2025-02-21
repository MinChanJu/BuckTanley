import 'package:buck_tanley_app/models/entity/Freind.dart';
import 'package:flutter/material.dart';

class FreindWidget extends StatelessWidget {
  final Freind freind;
  const FreindWidget({super.key, required this.freind});

  @override
  Widget build(BuildContext context) {
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
              backgroundImage: AssetImage(freind.id == null ? "assets/images/dinosaur1.png" : freind.userId1),
              backgroundColor: Color.fromARGB(255, 209, 209, 209),
            ),
            SizedBox(width: 20),
            Text(
              freind.userId2,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                freind.userId1,
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
              if (freind.status == 1) color = Colors.green;
              if (freind.status == 2) color = Colors.blue;
              if (freind.status == 3) color = Colors.red;
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
