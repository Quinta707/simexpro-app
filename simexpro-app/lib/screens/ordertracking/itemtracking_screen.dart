// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simexpro/screens/profile_screen.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../widgets/navbar_roots.dart';
import '../../widgets/panel_widget.dart';
import '../home_screen.dart';
import '../login_screen.dart';
import 'package:http/http.dart' as http;

import '../../api.dart';

class ItemTrackingScreen extends StatefulWidget {
  final item;

  const ItemTrackingScreen({
    Key? key,
    required this.item,
    }) : super(key: key);

  @override
  State<ItemTrackingScreen> createState() => _ItemTrackingScreenState();
}

var procesos;
final format = DateFormat('dd-MM-yyyy');
var foundDetalles;
// bool tieneDetalles = false;

Future<void> dibujarProcesos(String codigopo, context) async {
  final response = await http.get(
    Uri.parse(
      '${apiUrl}ProcesoPorOrdenCompraDetalle/DibujarProcesos?orco_Codigo=$codigopo'
    ),
    headers: {
      'XApiKey': apiKey,
      'Content-Type': 'application/json',
    },
  );

  final decodedJson = jsonDecode(response.body);
  procesos = decodedJson["data"];

  print(procesos);
}

tieneDetalles (procesosdetalles, idProceso) {
  if(procesosdetalles != null){
    final decodedDetalles = jsonDecode(procesosdetalles);
    foundDetalles = decodedDetalles.where((item) => 
          item["proc_Id"] == idProceso
    );
  }

}

Widget buildDetallesProcesos(isScrollable){

    final mappedFoundDetalles = foundDetalles.toList();
    print(mappedFoundDetalles);

    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: isScrollable ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: foundDetalles.length,
      itemBuilder: (BuildContext context, int index){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text("Orden de proceso: #${mappedFoundDetalles[index]["ensa_Id"]}\n"
              "Cantidad: ${mappedFoundDetalles[index]["ensa_Cantidad"]}\n"
              "Empleado encargado: ${mappedFoundDetalles[index]["empl_NombreCompleto"]}\n"
              "Fecha inicio: ${format.format(DateTime.tryParse(mappedFoundDetalles[index]["ensa_FechaInicio"]) as DateTime)}\n"
              "Fecha final: ${format.format(DateTime.tryParse(mappedFoundDetalles[index]["ensa_FechaLimite"]) as DateTime)}\n"
              "Módulo: ${mappedFoundDetalles[index]["modu_Nombre"]}",
              style: const TextStyle(
                height: 1.25
              ),
          ),
          if (index < foundDetalles.length - 1) const Divider(
            color: Colors.black,
          ),
          ],
        );
      },
    );
  }


class _ItemTrackingScreenState extends State<ItemTrackingScreen> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context){

    TabController _TabController = 
    TabController(length: 2, vsync: this);
    procesos = null;
    foundDetalles = null;
    print(widget.item["detallesprocesos"]);
    // dibujarProcesos(widget.detalles[0]["orco_Codigo"].toString(), context);

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
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 2.3,
                        crossAxisSpacing: 0,
                        // mainAxisSpacing: -1,
                        shrinkWrap: true,
                        children: <Widget>[
                          ListTile(
                            horizontalTitleGap: 5,
                            leading: const Icon(
                              Icons.content_paste_search_outlined,
                              color: Colors.deepPurple,),
                            title: const Text(
                              "Orden de compra",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(widget.item["orco_Codigo"].toString()),
                          ),
                          ListTile(
                            horizontalTitleGap: 5,
                            leading: const Icon(
                              Icons.numbers_rounded,
                              color: Colors.deepPurple,),
                            title: const Text(
                              "Código de ítem",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(widget.item["code_Id"].toString()),
                          ),
                          ListTile(
                            horizontalTitleGap: 5,
                            leading: const Icon(
                              Icons.shopping_cart_checkout_rounded,
                              color: Colors.deepPurple,),
                            title: const Text(
                              "Cantidad",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(widget.item["code_CantidadPrenda"].toString()),
                          ),
                          ListTile(
                            horizontalTitleGap: 5,
                            leading: const Icon(
                              Icons.design_services_rounded,
                              color: Colors.deepPurple,),
                            title: const Text(
                              "Estilo",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(widget.item["esti_Descripcion"].toString()),
                          ),
                          ListTile(
                            horizontalTitleGap: 5,
                            leading: const Icon(
                              Icons.format_size_rounded,
                              color: Colors.deepPurple,),
                            title: const Text(
                              "Talla",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(widget.item["tall_Nombre"].toString()),
                          ),
                          ListTile(
                            horizontalTitleGap: 5,
                            leading: const Icon(
                              Icons.transgender_rounded,
                              color: Colors.deepPurple,),
                            title: const Text(
                              "Medida",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(widget.item["code_Sexo"].toString()),
                          ),
                          ListTile(
                            horizontalTitleGap: 5,
                            leading: const Icon(
                              Icons.color_lens_rounded,
                              color: Colors.deepPurple,),
                            title: const Text(
                              "Color",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(widget.item["colr_Nombre"].toString()),
                          ),
                          ListTile(
                            horizontalTitleGap: 5,
                            leading: const Icon(
                              Icons.local_offer_rounded,
                              color: Colors.deepPurple,),
                            title: const Text(
                              "Valor unitario",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(widget.item["code_Unidad"].toString()),
                          ),
                          ListTile(
                            horizontalTitleGap: 5,
                            leading: const Icon(
                              Icons.payments,
                              color: Colors.deepPurple,),
                            title: const Text(
                              "Impuesto",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(widget.item["code_Impuesto"].toString()),
                          ),
                          ListTile(
                            horizontalTitleGap: 5,
                            leading: const Icon(
                              Icons.price_check_rounded,
                              color: Colors.deepPurple,),
                            title: const Text(
                              "Valor total",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(widget.item["code_Valor"].toString()),
                          ),
                        ],
                      ),
                      ListTile(
                        horizontalTitleGap: 5,
                        leading: const Icon(
                          Icons.inventory,
                          color: Colors.deepPurple,),
                        title: const Text(
                          "Especificación de embalaje",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        subtitle: Text(widget.item["code_EspecificacionEmbalaje"].toString()),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: FutureBuilder(
                    future: dibujarProcesos(widget.item["orco_Codigo"].toString(), context),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(procesos != null){
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: procesos.length,
                          itemBuilder: (BuildContext context, int index){

                            tieneDetalles(widget.item["detallesprocesos"], procesos[index]["proc_Id"]);

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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(""),
                                    SizedBox(height: foundDetalles != null && foundDetalles.length > 0 ? 40 : 10),
                                    Text(
                                      procesos[index]["proc_Descripcion"].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    // const SizedBox(height: 6),
                                    if(foundDetalles != null && foundDetalles.length > 0) Material(
                                      child: InkWell(
                                        splashColor: Colors.grey,
                                        onTap: () => {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              // title: const Text("Random title"),
                                              content: buildDetallesProcesos(true),
                                            )
                                          )
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: 40,
                                            child: buildDetallesProcesos(false),
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