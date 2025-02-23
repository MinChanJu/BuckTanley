import 'package:buck_tanley_app/SetUp.dart';
import 'package:flutter/material.dart';

class MenuWidget extends StatefulWidget {
  final UserDTO userDTO;
  final ImageProvider imageProvider;
  const MenuWidget({super.key, required this.userDTO, required this.imageProvider});

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 209, 209, 209),
              image: DecorationImage(
                image: widget.imageProvider,
                fit: BoxFit.cover,
              ),
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0), // Dialog의 둥근 테두리
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8, // 화면 너비의 80%
                          height: MediaQuery.of(context).size.height * 0.6, // 화면 높이의 60%
                          child: InteractiveViewer(
                            panEnabled: true,
                            minScale: 1.0,
                            maxScale: 3.0,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Image(
                                image: widget.imageProvider,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: OutlineTextWidget(
                Text(
                  widget.userDTO.nickname,
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
            title: Text(widget.userDTO.introduction),
            onTap: () {},
          ),
          ListTile(
            leading: Text("성별"),
            title: Text(widget.userDTO.gender ? "남성" : "여성"),
            onTap: () {},
          ),
          ListTile(
            leading: Text("나이"),
            title: Text(widget.userDTO.age.toString()),
            onTap: () {},
          ),
          ListTile(
            leading: Text("상태"),
            title: Text(widget.userDTO.status.toString()),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
