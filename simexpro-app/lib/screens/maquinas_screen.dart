import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/screens/historial_screen.dart';
import 'package:simexpro/screens/home_screen.dart';
import 'package:simexpro/screens/login_screen.dart';
import 'package:simexpro/screens/profile_screen.dart';
import 'package:simexpro/screens/timeline_screen.dart';
import 'package:simexpro/toastconfig/toastconfig.dart';
import 'package:simexpro/widgets/taps.dart';
import 'package:http/http.dart' as http;

import 'package:simexpro/api.dart';

class MaquinasScreen extends StatefulWidget {

  const MaquinasScreen({Key? key}) : super(key: key);

  @override
  _MaquinasScreenState createState() => _MaquinasScreenState();
}

Future<void> Imagen() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  image = prefs.getString('image');
}

List<dynamic> Lista(List data, String numserie) {
  List<String> filtrado = [];
  for (var item in data) {
    if(data[item]['maquinaNumeroSerie'] == numserie){
      filtrado.addAll(data as Iterable<String>);
    }
  }
  print(filtrado);
  print('abajodefiltrado');
  return filtrado;
}


Future<void> TraerDatos(BuildContext context, String numserie) async {
  final response = await http.get(
    Uri.parse('${apiUrl}MaquinaHistorial/Listar'),
    headers: {
      'XApiKey': apiKey,
      'Content-Type': 'application/json',
    },
  );
  final decodedJson = jsonDecode(response.body);
  final data = decodedJson["data"];
      List<Map> filteredlist = [];
  print(numserie);
  for(var i = 0; i < data.length; i++){
      
    if(data[i]["maquinaNumeroSerie"].toString() == numserie){
    filteredlist.add(data[i]);
    
    }
    print(data[i]['maquinaNumeroSerie'].toString());
  }  
  print(numserie);
  print(filteredlist);
  filteredlist.isEmpty
  ? CherryToast.error(title: Text('El número de máquina no existe', style: TextStyle(color: Colors.white)),  borderRadius: 5,).show(context)
  : CherryToast.success(title: Text('Trae los datos', style: TextStyle(color: Colors.white)),  borderRadius: 5,).show(context);

}

class _MaquinasScreenState extends State<MaquinasScreen> {  
  int _selectedIndex = 0;
  final _screens = [
    TapsProduccion(),
    historialScreen(),
    TimelineScreen(),
  ];
    String searchValue = '';
  @override
  void initState() {
    super.initState();
    Imagen();
  }
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
              title: const Image(
                height: 35,
                image: NetworkImage('https://i.ibb.co/HgdBM0r/slogan.png'),
              ),
              centerTitle: true,
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(image),
                    child: PopupMenuButton<MenuItem>(
                      //padding: EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          image,
                          width: 50,
                        ),
                      ),
                      onSelected: (value) {
                        if (value == MenuItem.item1) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(),
                              ));
                        }
                        if (value == MenuItem.item2) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => loginScreen(),
                              ));
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem<MenuItem>(
                          value: MenuItem.item1,
                          child: Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.person_2_outlined,
                                    color: Color.fromRGBO(87, 69, 223, 1),
                                  )),
                              const Text(
                                'Mi Perfil',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<MenuItem>(
                          value: MenuItem.item2,
                          child: Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.logout,
                                    color: Color.fromRGBO(87, 69, 223, 1),
                                  )),
                              const Text(
                                'Cerrar Sesión',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
              backgroundColor: Color.fromRGBO(17, 24, 39, 1),
              //elevation: 50.0,
              leading: IconButton(
                icon: const Icon(Icons.menu),
                tooltip: 'Menú',
                onPressed: () {},
              ),
              //systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            body: Center(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(
                          "Días inactivos de las máquinas",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(148, 82, 249, 1),
                          ),
                        ),
                      ),
                    ), 
                  ),
                  //SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                searchValue = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Digite un número de serie"),
                            ),
                          ),
                          SizedBox(height: 20),
                          ButtonTheme(
                            height: 20,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Color.fromRGBO(99, 74, 158, 1),
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              ),
                              onPressed: (){
                                searchValue == null || searchValue == ""
                                  ? CherryToast.warning(title: Text('Llene los campos correctamente', style: TextStyle(color: Colors.white)), borderRadius: 5,).show(context)
                                  : TraerDatos(context, searchValue);
                              }, 
                              icon: Icon(Icons.search), 
                              label: Text('Buscar',
                                style: TextStyle(
                                      fontSize: 18, 
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          )
                      ],
                    ), 
                  ),
                ],
              ),
            ),
    );
  }
}
