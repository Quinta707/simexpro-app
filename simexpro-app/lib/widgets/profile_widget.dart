import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/api.dart';
import 'package:simexpro/screens/DUCA/duca_found_screen.dart';
import 'package:simexpro/toastconfig/toastconfig.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:simexpro/toastconfig/toastconfig.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.onClicked,
  }) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  String image = '';

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  Future<void> loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      image = prefs.getString('image') ??
          'https://cdn-icons-png.flaticon.com/512/6073/6073873.png';
    });
  }

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

  Future<void> CambiarFoto(BuildContext context, String imageUrl) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final usua_Id = prefs.getInt('usua_Id');
      final String formattedDate =
          DateFormat('yyyy-MM-dd').format(DateTime.now());

      final Map<String, dynamic> requestBody = {
        'usua_Id': usua_Id,
        'usua_Image': imageUrl,
        'usua_UsuarioModificacion': usua_Id,
        'usua_FechaModificacion': formattedDate,
      };
      print(requestBody);

      final response = await http.post(
        Uri.parse('${apiUrl}Usuarios/CambiarPerfil'),
        headers: {
          'XApiKey': apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print(response);
      if (response.statusCode == 200) {
        print('Ya SIRVE WAOS');

        setState(() {
          image = imageUrl;
          prefs.setString('image', imageUrl);
        });
        print(
            'Error al cambiar la imagen de perfil. Código de respuesta: ${response.body}');
      }
    } catch (e) {
      print('Error al enviar la solicitud para cambiar la imagen: $e');
    }
  }

  Future<void> subirImagen(BuildContext context, File img) async {
    var imageUrl = '';
    final apiKey = '3b346fac515eaa6d6e2de7f6387c7186';

    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.imgbb.com/1/upload'));

    request.fields['key'] = apiKey;

    request.files.add(await http.MultipartFile.fromPath('image', img.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        final decodedResponse = jsonDecode(responseString);
        if (decodedResponse.containsKey('data') &&
            decodedResponse['data'].containsKey('url')) {
          imageUrl = decodedResponse['data']['url'];

          CambiarFoto(context, imageUrl);
        } else {
          print('La respuesta no contiene una URL válida.');
        }
      } else {
        print(
            'Error al subir la imagen. Código de respuesta: ${response.statusCode}');
      }
    } catch (e) {
      print('Error de red al subir la imagen: $e');
    }
  }

  Future selImagen(op, context) async {
    File Imagen;
    final picker = ImagePicker();
    var pickedFile;

    if (op == 1) {
      pickedFile = await picker.getImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.getImage(source: ImageSource.gallery);
    }

    if (pickedFile != null) {
      Imagen = File(pickedFile.path);
      print(Imagen);

      subirImagen(context, Imagen);
    } else {
      CherryToast.error(
        title: Text('No se ha seleccionado ninguna foto',
            style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
            textAlign: TextAlign.justify),
        borderRadius: 5,
      ).show(context);
    }
    Navigator.of(context).pop();
  }

  opciones(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: SingleChildScrollView(
                child: Column(
              children: [
                InkWell(
                  onTap: () {
                    selImagen(1, context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1, color: Colors.grey.shade300))),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Toma una foto',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.deepPurpleAccent,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    selImagen(2, context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Elegir de Galeria',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(
                          Icons.photo,
                          color: Colors.deepPurpleAccent,
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
          );
        });
  }

  Widget buildImage(context) {
    final imagen = NetworkImage(image);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: imagen,
          fit: BoxFit.cover,
          width: 170,
          height: 170,
          child: InkWell(onTap: () {}),
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
                opciones(context);
              },
            )),
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
