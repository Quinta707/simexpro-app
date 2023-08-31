import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simexpro/api.dart';
import 'package:http/http.dart' as http;

Future<void> fetchData() async {
    final response = await http.get(Uri.parse('${apiUrl}api/Categoria/Listar?key=$apiKey'));

//   if (response.statusCode == 200) {
//     print('Listado de datos: ${response.body}');
//   } else {
//     print('Error en la solicitud. Código de estado: ${response.statusCode}');
//   }
// final tarea = Regitro(Local: Local , GolesLocal: GolesLocal, Visitante: Visitante , GolesVisitante: GolesVisitante, Jornada: Jornada);
//   final jsonTarea = jsonEncode(tarea.toJson());
//   final response = await http.post(
//     Uri.parse('https://localhost:44359/api/Equipos/InsertarEncuentros'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonTarea,
//   );


// Future<List<dynamic>> getListado() async{
//   final respuesta =  await http.get(
//     Uri.parse(apiUrl),
//     headers: <String, String>{
//       'XApiKey': apiKey,
//     },
//     );
//   if(respuesta.statusCode == 200)
//   {
//     final json  = respuesta.body;
//     final decodedJson = jsonDecode(json);
//     final data = decodedJson["data"];

//     print(data);
//     return [];
//   }
//   else
//   {
//     print("Error en la respuesta");
//     return [];
//   }
// }
  
    //final response = await http.get(Uri.parse('$apiUrl?key=$apiKey'));

    if (response.statusCode == 200) {
      // Si la solicitud es exitosa (código 200), puedes manejar la respuesta aquí
      debugPrint('Respuesta: ${response.body}');
      
    } else {
      // Si la solicitud no es exitosa, puedes manejar el error aquí
      debugPrint('Error en la solicitud: ${response.statusCode}');
    }
  }

class PruebaApi extends StatefulWidget {
  const PruebaApi({super.key});

  @override
  State<StatefulWidget> createState() => PruebaApiState();
}

class PruebaApiState extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
       padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
            ElevatedButton(
          onPressed: fetchData,
          child: Text('Realizar Solicitud a la API'),
        ),
          ]
        )
    );
  }
}
