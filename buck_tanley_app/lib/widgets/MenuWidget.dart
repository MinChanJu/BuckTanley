import 'package:buck_tanley_app/core/Import.dart';
import 'package:flutter/material.dart';

class MenuWidget extends StatefulWidget {
  final UserInfo user;
  const MenuWidget({super.key, required this.user});

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 209, 209, 209),
              image: DecorationImage(
                image: widget.user.image,
                fit: BoxFit.cover,
              ),
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ImageWidget(imageProvider: widget.user.image),
                );
              },
              child: OutlineTextWidget(
                Text(
                  widget.user.user.nickname,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Text("소개"),
            title: Text(widget.user.user.introduction),
            onTap: () {},
          ),
          ListTile(
            leading: Text("성별"),
            title: Text(widget.user.user.gender ? "남성" : "여성"),
            onTap: () {},
          ),
          ListTile(
            leading: Text("나이"),
            title: Text(widget.user.user.age.toString()),
            onTap: () {},
          ),
          ListTile(
            leading: Text("상태"),
            title: Text(widget.user.user.status.toString()),
            onTap: () {},
          ),
          ListTile(
            title: Text("취소"),
            onTap: () {Navigator.of(context).pop();},
          ),
        ],
      ),
    );
  }
}
