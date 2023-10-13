// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:simexpro/screens/profile_screen.dart';
import 'package:simexpro/widgets/panelduca_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../widgets/headersinfo_widget.dart';
import '../../widgets/navbar_roots.dart';
import '../home_screen.dart';
import '../login_screen.dart';

class Deva_Found_Screen extends StatefulWidget {
  final data;

  const Deva_Found_Screen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<Deva_Found_Screen> createState() => _Deva_Found_ScreenState();
}

Future<void> imagen() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  image = prefs.getString('image');
}

class Elementos {
  var linea1 = Colors.black12;
  var linea2 = Colors.black12;
  var linea3 = Colors.black12;
  var tag = null;
  String text = '';
  String image = '';

  Elementos();
}

// ignore: camel_case_types
class _Deva_Found_ScreenState extends State<Deva_Found_Screen>
    with SingleTickerProviderStateMixin {
  var elementos = Elementos();
  final panelController = PanelController();
  final format = DateFormat('dd-MM-yyyy');
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.16;
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.70;

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
        body: SlidingUpPanel(
          backdropEnabled: true,
          color: Color.fromARGB(212, 134, 111, 189),
          controller: panelController,
          maxHeight: panelHeightOpen,
          minHeight: panelHeightClosed,
          panelBuilder: (controller) => PanelDucaWidget(
          
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          body: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: "Declaración de valor"),
                    Tab(text: "Más"),
                    Tab(text: "Facturas"),
                  ],
                  controller: _tabController,
                  labelColor: Color.fromRGBO(87, 69, 223, 1),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Contenido del tab 1
                      SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                ),
                                child: Text(
                                  "DEVA: ${widget.data[0]["deva_Id"]}",
                                ),
                              ),
                              const SizedBox(height: 5),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 380,
                                    child: GridView.count(
                                      padding: const EdgeInsets.all(20),
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10.0,
                                      childAspectRatio: 3 / 1,
                                      children: [
                                     HeadersInfoWidget(
                                        title: "No° Correlativo:",
                                        text: widget.data[0]["deva_Id"].toString() ?? "N/A",
                                      ),

                                        HeadersInfoWidget(
                                          title: "Regimen Aduanero:",
                                          text: widget.data[0]["deva_Id"].toString() ?? "N/A",
                                        ),
                                       /* HeadersInfoWidget(
                                          title: "Fecha de Vencimiento:",
                                          text: (widget.data[0][
                                                      "deva_Id"] !=
                                                  null)
                                              ? format.format(DateTime.tryParse(
                                                      widget.data[0][
                                                          "deva_Id"])
                                                  as DateTime)
                                              : "N/D",
                                        ),*/
                                       /* HeadersInfoWidget(
                                          title: "Fecha de Aceptación:",
                                          text: (widget.data[0][
                                                      "deva_Id"] !=
                                                  null)
                                              ? format.format(DateTime.tryParse(
                                                      widget.data[0][
                                                          "deva_Id"])
                                                  as DateTime)
                                              : "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Pais de Procedencia:",
                                          text: widget.data[0]
                                                  ["deva_Id"] ??
                                              "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Pais de Destino:",
                                          text: widget.data[0]
                                                  ["deva_Id"] ??
                                              "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Lugar Embarque:",
                                          text: widget.data[0]
                                                  ["deva_Id"] ??
                                              "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Lugar Desembarque:",
                                          text: widget.data[0]
                                                  ["deva_Id"] ??
                                              "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Aduana de Registro:",
                                          text: widget.data[0]
                                                  ["deva_Id"] ??
                                              "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Aduana de Salida:",
                                          text: widget.data[0]
                                                  ["deva_Id"] ??
                                              "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Aduana de Ingreso:",
                                          text: widget.data[0]
                                                  ["deva_Id"] ??
                                              "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Aduana de Destino:",
                                          text: widget.data[0]
                                                  ["deva_Id"] ??
                                              "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Manifiesto:",
                                          text: widget.data[0]
                                                  ["deva_Id"] ??
                                              "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Titulo:",
                                          text: widget.data[0]["deva_Id"] ??
                                              "N/D",
                                        ),*/
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),

                      // Contenido del tab 2
                      SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                ),
                                child: Text(
                                  "DUCA: ${widget.data[0]["deva_Id"].toString() ?? "N/A"}",
                                ),
                              ),
                              const SizedBox(height: 20),
                              Column(
                                children: [
                                  Text(
                                    "Cliente o Razón Social",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 150,
                                    child: GridView.count(
                                      padding: const EdgeInsets.all(20),
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10.0,
                                      childAspectRatio: 3 / 1,
                                      children: [
                                        HeadersInfoWidget(
                                          title: "Código Declarante",
                                         text: widget.data[0]["deva_Id"].toString() ?? "N/A",
                                        ),
                                       /* HeadersInfoWidget(
                                          title:
                                              "Cliente o Razón Social Declarante:",
                                          text: widget.data[0][
                                                  "deva_Id"] ??
                                              "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Dpminio Fiscal",
                                          text: widget.data[0][
                                                  "deva_Id"] ??
                                              "N/D",
                                        ),*/
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "Proveedor e Importador",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 200,
                                    child: GridView.count(
                                      padding: const EdgeInsets.all(20),
                                      crossAxisCount: 2,
                                      childAspectRatio: 3 / 1,
                                      children: [
                                        HeadersInfoWidget(
                                          title: "No° Idenficación Proveedor",
                                        text: widget.data[0]["deva_Id"].toString() ?? "N/A",
                                        ),
                                       /* HeadersInfoWidget(
                                          title: "Razón Social Proveedor:",
                                          text: widget.data[0]
                                                  ["deva_Id"] ??
                                              "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title: "No° de Registro Importador",
                                          text: widget.data[0]
                                                  ["deva_Id"] ??
                                              "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Razón Social Importador",
                                          text: widget.data[0]
                                                  ["deva_Id"] ??
                                              "N/D",
                                        ),*/
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),

                      //Tab 3
                      SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                ),
                                child: Text(
                                  "DEVA: ${widget.data[0]["deva_Id"].toString() ?? "N/A"}",
                                ),
                              ),
                              const SizedBox(height: 20),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 300,
                                    child: GridView.count(
                                      padding: const EdgeInsets.all(20),
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10.0,
                                      childAspectRatio: 3 / 1,
                                      children: [
                                        HeadersInfoWidget(
                                          title: "País de Transporte",
                                         text: widget.data[0]["deva_Id"].toString() ?? "N/A",
                                        ),
                                       /* HeadersInfoWidget(
                                          title: "Marca Vehiculo:",
                                          text: widget.data[0]
                                                  ["deva_Id"] ??
                                              "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Chasis Vehiculo",
                                          text: widget.data[0]
                                                  ["deva_Id"] ??
                                              "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Remolque del vehículo",
                                          text: widget.data[0]
                                                  ["deva_Id"] ??
                                              "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Cantidad de carga:",
                                          text: widget.data[0]["deva_Id"]
                                                  .toString() ??
                                              "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title:
                                              "Número de dispositivo de seguridad:",
                                          text: widget.data[0][
                                                      "deva_Id"]
                                                  .toString() ??
                                              "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Equipamiento del vehículo:",
                                          text: widget.data[0]
                                                  ["deva_Id"] ??
                                              "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Tamaño del equipamiento:",
                                          text: widget.data[0][
                                                      "deva_Id"]
                                                  .toString() ??
                                              "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Tipo de carga",
                                          text: widget.data[0]["deva_Id"]
                                                  .toString() ??
                                              "N/D",
                                        ),*/
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                    controller: _tabController,
                  ),
                ),
              ],
            ),
          ),
        )
     );
  }
}
