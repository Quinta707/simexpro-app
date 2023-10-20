// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:simexpro/screens/profile_screen.dart';
import 'package:simexpro/widgets/paneldeva_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:simexpro/toastconfig/toastconfig.dart';
import 'package:http/http.dart' as http;
import '../../api.dart';
import 'dart:convert';

import '../../widgets/headersinfo_widget.dart';
import '../../widgets/navbar_roots.dart';
import '../home_screen.dart';
import '../login_screen.dart';

class Deva_Found_Screen extends StatefulWidget {
  final data;
  final factura;
  final items;

  const Deva_Found_Screen({
    Key? key,
    required this.data,
    required this.factura,
    required this.items,
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
          panelBuilder: (controller) => PanelDevaWidget(),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          body: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: "General"),
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
                                          title: "Régimen Aduanero:",
                                          text: widget.data[0]
                                                      ["regi_Descripcion"] !=
                                                  null
                                              ? widget.data[0]
                                                      ["regi_Descripcion"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Nombre de Aduana de Ingreso:",
                                          text: widget.data[0]
                                                      ["adua_IngresoNombre"] !=
                                                  null
                                              ? widget.data[0]
                                                      ["adua_IngresoNombre"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Código de Aduana de Ingreso:",
                                          text: widget.data[0]
                                                      ["adua_IngresoCodigo"] !=
                                                  null
                                              ? widget.data[0]
                                                      ["adua_IngresoCodigo"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title:
                                              "Nombre de Aduana de despacho:",
                                          text: widget.data[0]
                                                      ["adua_DespachoNombre"] !=
                                                  null
                                              ? widget.data[0]
                                                      ["adua_DespachoNombre"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title:
                                              "Código de Aduana de despacho:",
                                          text: widget.data[0]
                                                      ["adua_DespachoCodigo"] !=
                                                  null
                                              ? widget.data[0]
                                                      ["adua_DespachoCodigo"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Fecha de Aceptación:",
                                          text: (widget.data[0][
                                                      "deva_FechaAceptacion"] !=
                                                  null)
                                              ? format.format(DateTime.tryParse(
                                                      widget.data[0][
                                                          "deva_FechaAceptacion"])
                                                  as DateTime)
                                              : "N/D",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Nombre del importador:",
                                          text: widget.data[0]
                                                      ["impo_Nombre_Raso"] !=
                                                  null
                                              ? widget.data[0]
                                                      ["impo_Nombre_Raso"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title: "RTN del Importador:",
                                          text: widget.data[0]
                                                      ["adua_DespachoCodigo"] !=
                                                  null
                                              ? widget.data[0]
                                                      ["adua_DespachoCodigo"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title: "DNI del Importador :",
                                          text: widget.data[0]
                                                      ["impo_NumRegistro"] !=
                                                  null
                                              ? widget.data[0]
                                                      ["impo_NumRegistro"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Teléfono del Importador :",
                                          text: widget.data[0]
                                                      ["impo_Telefono"] !=
                                                  null
                                              ? widget.data[0]["impo_Telefono"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Correo del Importador :",
                                          text: widget.data[0][
                                                      "impo_Correo_Electronico"] !=
                                                  null
                                              ? widget.data[0][
                                                      "impo_Correo_Electronico"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title: "País del Importador :",
                                          text: widget.data[0]
                                                      ["impo_PaisNombre"] !=
                                                  null
                                              ? widget.data[0]
                                                      ["impo_PaisNombre"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Nombre del Intermediario :",
                                          text: widget.data[0][
                                                      "int flutter run --no-sound-null-safetye_Nombre_Raso"] !=
                                                  null
                                              ? widget.data[0][
                                                      "int flutter run --no-sound-null-safetye_Nombre_Raso"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Correo del Intermediario :",
                                          text: widget.data[0][
                                                      "inte_Correo_Electronico"] !=
                                                  null
                                              ? widget.data[0][
                                                      "inte_Correo_Electronico"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title:
                                              "Número de Teléfono del intermediario :",
                                          text: widget.data[0]
                                                      ["inte_Telefono"] !=
                                                  null
                                              ? widget.data[0]["inte_Telefono"]
                                                  .toString()
                                              : "N/A",
                                        ),
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
                                    "Información del Proveedor",
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
                                          title: "Nombre del Proveedor",
                                          text: widget.data[0]
                                                      ["prov_Nombre_Raso"] !=
                                                  null
                                              ? widget.data[0]
                                                      ["prov_Nombre_Raso"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title:
                                              "Número de identidad del Proveedor",
                                          text: widget.data[0][
                                                      "prov_NumeroIdentificacion"] !=
                                                  null
                                              ? widget.data[0][
                                                      "prov_NumeroIdentificacion"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title:
                                              "Número de identidad del Proveedor",
                                          text: widget.data[0][
                                                      "prov_NumeroIdentificacion"] !=
                                                  null
                                              ? widget.data[0][
                                                      "prov_NumeroIdentificacion"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title:
                                              "Número de identidad del Proveedor",
                                          text: widget.data[0][
                                                      "prov_NumeroIdentificacion"] !=
                                                  null
                                              ? widget.data[0][
                                                      "prov_NumeroIdentificacion"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "Información de importación y exportación",
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
                                          title: "País de entrega",
                                          text: widget.data[0]
                                                      ["pais_EntregaNombre"] !=
                                                  null
                                              ? widget.data[0]
                                                      ["pais_EntregaNombre"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Lugar de embarque",
                                          text: widget.data[0]
                                                      ["lugarEmbarque"] !=
                                                  null
                                              ? widget.data[0]["lugarEmbarque"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Incoterm",
                                          text: widget.data[0]
                                                      ["inco_Descripcion"] !=
                                                  null
                                              ? widget.data[0]
                                                      ["inco_Descripcion"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title: " Versión de Incoterm",
                                          text: widget.data[0]
                                                      ["inco_Version"] !=
                                                  null
                                              ? widget.data[0]["inco_Version"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Moneda de transacción",
                                          text: widget.data[0]
                                                      ["monedaNombre"] !=
                                                  null
                                              ? widget.data[0]["monedaNombre"]
                                                  .toString()
                                              : "N/A",
                                        ),
                                        HeadersInfoWidget(
                                          title: "Cambio de moneda USD",
                                          text: widget.data[0][
                                                      "deva_ConversionDolares"] !=
                                                  null
                                              ? widget.data[0]
                                                      ["deva_ConversionDolares"]
                                                  .toString()
                                              : "N/A",
                                        ),
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

                  SingleChildScrollView(
  child: Column(
    children: [
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        child: Text(
          "DEVA: ${widget.data[0]["deva_Id"].toString() ?? "N/A"}",
        ),
      ),
      const SizedBox(height: 20),
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.factura.length,
        itemBuilder: (context, index) {
          final factura = widget.factura[index];
          return Column(
            children: [
              SizedBox(
                height: 50,
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 1,
                  children: [
                    HeadersInfoWidget(
                      title: "N° de Factura",
                      text: factura["fact_Numero"] != null
                          ? factura["fact_Numero"].toString()
                          : "N/A",
                    ),
                    HeadersInfoWidget(
                      title: "Fecha:",
                      text: factura["fact_Fecha"] != null
                          ? format.format(DateTime.tryParse(factura["fact_Fecha"]) as DateTime)
                          : "N/A",
                    ),
                  ],
                ),
              ),
              Divider(),
              // Aquí puedes mostrar los detalles de la factura
              for (var item in (widget.items ?? []))
                if (item['fact_Id'] == factura["fact_Id"])
                  Column(
                    children: [
                      HeadersInfoWidget(
                        title: "Id del Item",
                        text: item['item_Id'] != null ? item['item_Id'].toString() : "N/A",
                      ),
                      HeadersInfoWidget(
                        title: "Cantidad:",
                        text: item['item_Cantidad'] != null ? item['item_Cantidad'].toString() : "N/A",
                      ),
                      HeadersInfoWidget(
                        title: "Precio Unitario:",
                        text: item['item_ValorUnitario'] != null ? item['item_ValorUnitario'].toString() : "N/A",
                      ),
                      HeadersInfoWidget(
                        title: "Unidad de Medida:",
                        text: item['unme_Descripcion'] != null ? item['unme_Descripcion'].toString() : "N/A",
                      ),
                      HeadersInfoWidget(
                        title: "Identificación comercial:",
                        text: item['item_IdentificacionComercialMercancias'] != null ? item['item_IdentificacionComercialMercancias'].toString() : "N/A",
                      ),
                      Divider(),
                    ],
                  ),
              // Aquí termina la sección de detalles de la factura
            ],
          );
        },
      ),
    ],
  ),
)

          
                    ],
                    controller: _tabController,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
