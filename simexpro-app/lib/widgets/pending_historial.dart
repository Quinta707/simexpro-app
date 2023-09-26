import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';

Future<void> fetchData(BuildContext context) async {
  final response = await http.get(
    Uri.parse('${apiUrl}OrdenCompra/Listar'),
    headers: {
      'XApiKey': apiKey,
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final decodedJson = jsonDecode(response.body);
    final data = decodedJson["data"];

    // Crear un mapa para almacenar los datos específicos
    Map<String, dynamic> userData = {
      'orco_Codigo': data['orco_Codigo'],
      'clie_Nombre_O_Razon_Social': data['clie_Nombre_O_Razon_Social'],
      'orco_FechaEmision': data['orco_FechaEmision'],
      'orco_FechaLimite': data['orco_FechaLimite'],
      'orco_EstadoOrdenCompra': data['orco_EstadoOrdenCompra'],
    };

    // Imprimir el contenido del mapa en la consola
    if (kDebugMode) {
      print('UserData: $userData');
    }

    // Guardar el mapa en SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', jsonEncode(userData));
  } else {
    // Manejar el error si es necesario
  }
}

class Pendinghistorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "Orden #8732",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text("En ensamblaje"),
                    trailing: CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          NetworkImage("https://i.ibb.co/ypw0Ng3/icono.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      // color: Colors.black,
                      thickness: 1,
                      height: 20,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "12/01/2023",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_filled,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "10:30 AM",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Pendiente",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 150,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(87, 69, 223, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Ver detalles",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
