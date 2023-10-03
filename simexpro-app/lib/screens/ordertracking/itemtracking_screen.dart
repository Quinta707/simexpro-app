// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simexpro/screens/profile_screen.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../widgets/navbar_roots.dart';
import '../../widgets/panel_widget.dart';
import '../home_screen.dart';
import '../login_screen.dart';
import 'package:http/http.dart' as http;

import '../../api.dart';

class ItemTrackingScreen extends StatefulWidget {
  final detalles;

  const ItemTrackingScreen({
    Key? key,
    required this.detalles,
    }) : super(key: key);

  @override
  State<ItemTrackingScreen> createState() => _ItemTrackingScreenState();
}

var procesos;

Future<void> DibujarProcesos(String codigopo, context) async {
  final response = await http.get(
    Uri.parse(
      '${apiUrl}ProcesoPorOrdenCompraDetalle/DibujarProcesos?orco_Codigo=$codigopo'
    ),
    headers: {
      'XApiKey': apiKey,
      'Content-Type': 'application/json',
    },
  );

  // print(response);

  final decodedJson = jsonDecode(response.body);
  procesos = decodedJson["data"];

  print(procesos);
} 

class _ItemTrackingScreenState extends State<ItemTrackingScreen> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context){

    TabController _TabController = 
    TabController(length: 2, vsync: this);
    procesos = null;
    // DibujarProcesos(widget.detalles[0]["orco_Codigo"].toString(), context);

    return Scaffold(
      appBar: AppBar(
        title: const Image(
          height: 35,
          image: NetworkImage('https://i.ibb.co/HgdBM0r/slogan.png'),
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
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
                      children: const [
                        Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.person_2_outlined,
                              color: Color.fromRGBO(87, 69, 223, 1),
                            )),
                        Text(
                          'Mi Perfil',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<MenuItem>(
                    value: MenuItem.item2,
                    child: Row(
                      children: const [
                        Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.logout,
                              color: Color.fromRGBO(87, 69, 223, 1),
                            )),
                        Text(
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
        backgroundColor: const Color.fromRGBO(17, 24, 39, 1),
      ),
      body: Column(
        children: [
          Container(
            child: TabBar(
              controller: _TabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: "Información general",),
                Tab(text: "Proceso")
              ],
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.83,
            child: TabBarView(
              controller: _TabController,
              children: [
                const Text("Hi"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: FutureBuilder(
                    future: DibujarProcesos(widget.detalles[0]["orco_Codigo"].toString(), context),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(procesos != null){
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: procesos.length,
                          itemBuilder: (BuildContext context, int index){
                            return TimelineTile(
                              alignment: TimelineAlign.manual,
                              lineXY: 0.1,
                              isFirst: index == 0,
                              isLast: index == procesos.length - 1,
                              beforeLineStyle: const LineStyle(
                                color: Colors.black87,
                                thickness: 2,
                              ),
                              indicatorStyle: IndicatorStyle(
                                drawGap: true,
                                color: HexColor(procesos[index]["proc_CodigoHTML"]),
                                width: 30,
                              ),
                              endChild: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(""),
                                    const SizedBox(height: 2),
                                    Text(
                                      procesos[index]["proc_Descripcion"].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    // const SizedBox(height: 6),
                                    Material(
                                      child: InkWell(
                                        splashColor: Colors.grey,
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => const AlertDialog(
                                              title: Text("Random title"),
                                              content: Text("Some more text pretending that it's important at all LMAO"),
                                            )
                                          );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "nomás probar q ",
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,  
                                          ),
                                        )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Column(
                          children: const [
                            SizedBox(height: 100,),
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(),
                            ),
                          ],
                        );
                      }
                      
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}