import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simexpro/api.dart';
import 'package:simexpro/toastconfig/toastconfig.dart';
import 'package:http/http.dart' as http;


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
    CherryToast.info(
      title: Text('hola', style: TextStyle(color: Colors.white))
    ).show(context);
  }

  Future<void> subirImagen(
    BuildContext context, String img) async {
  final cuerpo = {''};
  final jsoncuerpo = jsonEncode(cuerpo);
  final response = await http.post(
    Uri.parse('https://api.imgbb.com/1/upload'),
    headers: {
      'XApiKey': '7e4e4920016a49b1dfc06d5af4e9ffc3',
      'Content-Type': 'application/json',
    },
    body: jsoncuerpo,
  );
}
  
  Future<void> _selectImage() async {
    // final picker = ImagePicker();
    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   final path = pickedFile.path;
    //   final bytes = await File(path).readAsBytes();
    //   final img.Image? image = img.decodeImage(bytes);
    //   print(image);
    // }
  }

  Widget buildImage(context) {
    final imagen = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: imagen,
          fit: BoxFit.cover,
          width: 170,
          height: 170,
          child: InkWell(
            onTap: () {}
          ),
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
          onTap: () {
              _selectImage();
          },
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
          color: Color.fromRGBO(99, 74, 158, 1),
          child: child,
        ),
      );
}
