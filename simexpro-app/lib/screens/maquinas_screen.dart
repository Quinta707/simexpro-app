import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/screens/historial_screen.dart';
import 'package:simexpro/screens/home_screen.dart';
import 'package:simexpro/screens/login_screen.dart';
import 'package:simexpro/screens/ordertracking/qrscanner_screen.dart';
import 'package:simexpro/screens/profile_screen.dart';
import 'package:simexpro/screens/timeline_screen.dart';
import 'package:simexpro/toastconfig/toastconfig.dart';
import 'package:simexpro/widgets/taps.dart';
import 'package:http/http.dart' as http;

import 'package:simexpro/api.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';

List datamaquina = [];
List datamaquina2 = [];
int valor = 0;

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
    if (data[item]['maquinaNumeroSerie'] == numserie) {
      filtrado.addAll(data as Iterable<String>);
    }
  }
  return filtrado;
}

Future<void> TraerDatos(BuildContext context, String numserie) async {
  datamaquina = [];
  datamaquina2 = [];
  valor = 0;
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
  for (var i = 0; i < data.length; i++) {
    if (data[i]["maquinaNumeroSerie"].toString() == numserie) {
      filteredlist.add(data[i]);
    }
  }
  final response2 = await http.get(
    Uri.parse('${apiUrl}Maquinas/Listar'),
    headers: {
      'XApiKey': apiKey,
      'Content-Type': 'application/json',
    },
  );
  final decodedJson2 = jsonDecode(response2.body);
  final data2 = decodedJson2["data"];
  List<Map> filteredlist2 = [];
  for (var i = 0; i < data2.length; i++) {

    if (data2[i]["maqu_NumeroSerie"].toString() == numserie) {
      filteredlist2.add(data2[i]);
    }
  }
  if(filteredlist2.isEmpty){
    CherryToast.error(
          title: Text('El número de serie no existe',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.justify),
          borderRadius: 5,
        ).show(context);
    valor = 0;
  }
  else{
    if(filteredlist.isEmpty){
      CherryToast.warning(
          title: Text('La máquina no tiene registros de averío.',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.justify),
          borderRadius: 5,
        ).show(context);
        valor = 0;
    } 
    else{ 
      // CherryToast.success(
      //   title: Text('ayer tuve un amor que hoy me abandonó porque no me quería, fue tanta mi ilusión por hacerla feliz pero todo fue en vano', 
      //     style: TextStyle(color: Colors.white), 
      //     textAlign: TextAlign.justify),
      //   borderRadius: 5,
      // ).show(context);
      datamaquina = filteredlist;
      datamaquina2 = data2;
      valor = 1;
    }
  }
}


class _MaquinasScreenState extends State<MaquinasScreen> {
  String searchValue = '';
  @override
  void initState() {
    valor = 0;
    super.initState();
    Imagen();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: const Image(
          height: 35,
          image: AssetImage('images/slogan.png'),
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
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Menú',
          onPressed: () {
            valor = 0;
            Navigator.pop(context);
          },
        ),
        //systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Center(
                      child: Text(
                        "Días inactivos de las máquinas",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(99, 74, 158, 1),
                        ),
                      ),
                    ),
                  ),
                ],
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
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                    onPressed: () async {
                      if (searchValue != null && searchValue != "") {
                        await TraerDatos(context, searchValue);
                        if (datamaquina.isNotEmpty) {
                          setState(() {
                            valor = 1;
                          });
                        }
                        else{
                          setState(() {
                            valor = 0;
                          });
                        }
                      } else {
                        CherryToast.warning(
                          title: Text('Llene los campos correctamente',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.justify),
                          borderRadius: 5,
                        ).show(context);
                      }
                    },
                    icon: Icon(Icons.search),
                    label: Text(
                      'Buscar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                   ),
                  ),
                    SizedBox(height: 40),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: new Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: Divider(
                          color: Colors.black,
                        ),
                      )),
                      Text("O"),
                      Expanded(
                          child: new Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                        child: Divider(
                          color: Colors.black,
                        ),
                      ))
                    ],
                  ),
                  SizedBox(height: 40),
                  ButtonTheme(
                    height: 20,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Color.fromRGBO(99, 74, 158, 1),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => const   QRScannerScreen(),
                          )
                        );
                      },
                      icon: Icon(Icons.qr_code),
                      label: Text(
                        'Escanear',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            valor == 0
            ? SizedBox(height: 2)
            : RightChild(),
          ],
        ),
      ),
    );
  }
}

class RightChild extends StatelessWidget {
  @override
  final format = DateFormat('dd-MM-yyyy HH:mm');
  Widget build(BuildContext context) {
    return
    Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child:  Padding(
              padding: EdgeInsets.all(5), 
              child: Row(
                children: [
                    Container(
                      width: 110,
                      alignment: Alignment.center,
                      child: Text('No. Serie: ', style: TextStyle(color: Color.fromRGBO(99, 74, 158, 1), fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.start),
                    ),
                    Container(
                      width: 110,
                      alignment: Alignment.center,
                      child: Text('Modelo: ', style: TextStyle(color: Color.fromRGBO(99, 74, 158, 1), fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                    ),
                    Container(
                      width: 110,
                      alignment: Alignment.center,
                      child: Text('Módulo: ', style: TextStyle(color: Color.fromRGBO(99, 74, 158, 1), fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.end),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5), 
              child: Row(
                children: [
                  Container(
                      width: 110,
                      alignment: Alignment.center,
                      child: Text(datamaquina[0]['maquinaNumeroSerie'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300), textAlign: TextAlign.start),
                  ),
                  Container(
                      width: 110,
                      alignment: Alignment.center,
                      child: Text(datamaquina2[0]['mmaq_Nombre'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300), textAlign: TextAlign.center),
                  ),
                  Container(
                      width: 110,
                      alignment: Alignment.center,
                      child: Text(datamaquina2[0]['modu_Nombre'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300), textAlign: TextAlign.end),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 10, right: 10),
            child: Divider(
                color: Color.fromRGBO(99, 74, 158, 1),
                thickness: 2,
              ),
            ),
            ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
              itemCount: datamaquina.length,
              itemBuilder: (BuildContext context, int index){
                return TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.1,
                  isFirst: index == 0,
                  isLast: index == datamaquina.length - 1,
                  indicatorStyle: IndicatorStyle(
                    drawGap: true,
                    height: 40,
                    width: 40,
                    color: Color.fromRGBO(99, 74, 158, 1),
                    padding: EdgeInsets.all(6),
                    indicator: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, 
                            border: Border.fromBorderSide(
                              BorderSide(
                                color: Color.fromRGBO(99, 74, 158, 1),
                                width: 2,
                              ),
                            ),
                          ),
                          child: Center( 
                            child: Icon(
                              Icons.precision_manufacturing_rounded, 
                              color: Color.fromRGBO(99, 74, 158, 1),
                            ),
                          )
                        )
                  ),
                  beforeLineStyle: const LineStyle(
                    color: Color.fromRGBO(99, 74, 158, 1),
                    thickness: 2,
                  ),
                  afterLineStyle: const LineStyle(
                    color: Color.fromRGBO(99, 74, 158, 1),
                    thickness: 2,
                  ),
                  startChild: null,
                  endChild: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Opacity(
                          child: Image.asset('images/maquina.png', height: 50),
                          opacity: 1,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                //dateFormat.format(new DateTime.fromMillisecondsSinceEpoch(datamaquina[index]['mahi_FechaInicio'])),
                                format.format(DateTime.tryParse(datamaquina[index]['mahi_FechaInicio']) as DateTime),
                                //datamaquina[index]['mahi_FechaInicio'],
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ), 
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              Padding(
                                padding: EdgeInsets.all(0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: Colors.transparent,
                                    child: Tooltip(
                                      message: datamaquina[index]['mahi_Observaciones'],
                                      child: Text(
                                        datamaquina[index]['mahi_Observaciones'],
                                        style: TextStyle(
                                        color: Color(0xFF636564),
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            ), 
          ],
        ), 
      );
  }
}
 