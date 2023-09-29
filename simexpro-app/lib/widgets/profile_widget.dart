import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simexpro/toastconfig/toastconfig.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(context),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color, context),
          ),
        ],
      ),
    );
  }

  Future<void> CambiarFoto(context) async {
    CherryToast.info(title: Text('hola', style: TextStyle(color: Colors.white),)).show(context);
  }

  Widget buildImage(context) {
    final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 170,
          height: 170,
          child: InkWell(onTap: () {CambiarFoto(context);}),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color, BuildContext context) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: InkWell(
            child: Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
          onTap: () {CambiarFoto(context);},
          ) 
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
