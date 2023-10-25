// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simexpro/screens/profile_screen.dart';
//import 'package:timeline_tile/timeline_tile.dart';

import '../../widgets/navbar_roots.dart';
import '../../widgets/panel_widget.dart';
import 'package:getwidget/getwidget.dart';
import '../home_screen.dart';
import '../login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/toastconfig/toastconfig.dart';

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
var documentos = [];
var materiales = [];
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
}

Future<void> infoAcordeon(int codigopodetalle) async {
  final response1 = await http.get(
    Uri.parse(
      '${apiUrl}DocumentosOrdenCompraDetalles/Listar?code_Id=$codigopodetalle'
    ),
    headers: {
      'XApiKey': apiKey,
      'Content-Type': 'application/json',
    },
  );

  final decodedJson1 = jsonDecode(response1.body);
  documentos = decodedJson1["data"];

  final response2 = await http.get(
    Uri.parse(
      '${apiUrl}MaterialesBrindar/ListarFiltrado?code_Id=$codigopodetalle'
    ),
    headers: {
      'XApiKey': apiKey,
      'Content-Type': 'application/json',
    },
  );

  final decodedJson2 = jsonDecode(response2.body);
  materiales = decodedJson2["data"];
}

tieneDetalles (procesosdetalles, idProceso) {
  if(procesosdetalles != null){
    final decodedDetalles = jsonDecode(procesosdetalles);
    print("$procesosdetalles procesosdetalles $idProceso idProceso");
    foundDetalles = decodedDetalles.where((item) => 
          item["proc_Id"] == idProceso
    );
    print("$foundDetalles foundDetalles");
  }

}

Widget buildDetallesProcesos(isScrollable, [procId, item]){
  if(procId != null){
    tieneDetalles(item["detallesprocesos"], procId);
  }
// return Text("Hola");
  final mappedFoundDetalles = foundDetalles.toList();

  return ListView.builder(
    scrollDirection: Axis.vertical,
    physics: isScrollable ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: foundDetalles.length,
    itemBuilder: (BuildContext context, int index){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Html(
          data: "<span><b>Orden de proceso: </b>${mappedFoundDetalles[index]["ensa_Id"]}</span><br>"
                "<span><b>Cantidad: </b>${mappedFoundDetalles[index]["ensa_Cantidad"]}</span><br>"
                "<span><b>Empleado encargado: </b>${mappedFoundDetalles[index]["empl_NombreCompleto"]}</span><br>"
                "<span><b>Fecha inicio: </b>${format.format(DateTime.tryParse(mappedFoundDetalles[index]["ensa_FechaInicio"]) as DateTime)}</span><br>"
                "<span><b>Fecha final: </b>${format.format(DateTime.tryParse(mappedFoundDetalles[index]["ensa_FechaLimite"]) as DateTime)}</span><br>"
                "<span><b>Módulo: </b>${mappedFoundDetalles[index]["modu_Nombre"]}</span>",
        ),
        if (index < foundDetalles.length - 1) const Divider(
          color: Colors.black,
        ),
        ],
      );
    },
  );
}

class ExpansionItem{
  ExpansionItem({
    this.isExpanded = false, 
    this.header = '', 
    this.titleBorderRadius = const BorderRadius.all(Radius.circular(15)),
    this.esDocumentos = false});
  
  bool isExpanded;
  final String header;
  var titleBorderRadius;
  bool esDocumentos;
}

List<ExpansionItem> _items = <ExpansionItem>[
  ExpansionItem(header: 'Documentos', 
                esDocumentos: true),
  ExpansionItem(header: 'Materiales brindar', 
                esDocumentos: false),
];


class _ItemTrackingScreenState extends State<ItemTrackingScreen> with TickerProviderStateMixin{
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  Widget build(BuildContext context){

    TabController _TabController = TabController(length: 2, vsync: this);
    procesos = null;
    foundDetalles = null;
    // ignore: no_leading_underscores_for_local_identifiers
    print("DETALLES PROCESOS ${widget.item["detallesprocesos"]}");
    // dibujarProcesos(widget.detalles[0]["orco_Codigo"].toString(), context);
    infoAcordeon(widget.item["code_Id"]);
    print(" widget.item ${widget.item}");
    return WillPopScope(
      onWillPop: (() async {
        _items[0].titleBorderRadius = const BorderRadius.all(Radius.circular(15));
        _items[1].titleBorderRadius = const BorderRadius.all(Radius.circular(15));
        return true;
      }),
      child: Scaffold(
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
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                child: TabBar(
                  controller: _TabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: "Información general",)
                   
                  ],
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.83,
                child: TabBarView(
                  controller: _TabController,
                  children: [
                    SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 10,),
                            GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: 2.3,
                              crossAxisSpacing: 0,
                              physics: const NeverScrollableScrollPhysics(),
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
                            const SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: _items.length,
                                itemBuilder: (BuildContext context, int index){
                                  return GFAccordion(
                                    titleBorderRadius: _items[index].titleBorderRadius,
                                    collapsedTitleBackgroundColor: const Color(0xFFE0E0E0),
                                    contentBorderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                    onToggleCollapsed: (isCollapsed) {
                                      setState(() {
                                        print("hola");
                                        if(isCollapsed){
                                          _items[index].titleBorderRadius = const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15));
                                        } else {
                                          _items[index].titleBorderRadius = const BorderRadius.all(Radius.circular(15));
                                        }
                                      });                            
                                    },
                                    title: _items[index].header,
                                    contentChild: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: FittedBox(
                                        child: buildDataTable(_items[index].esDocumentos)
                                      )
                                    )
                                  );
                                }
                              )
                            ),
                            // const SizedBox(height: 20,)
                          ],
                        ),
                      ),
                    ),
                   
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildDataTable(bool esDocumentos){
    List<String> columns;

    if(esDocumentos){
      columns = ['Nombre', 'Tipo', 'Archivo'];
    } else{
      columns = ['Material', 'Unidad Medida', 'Cantidad'];
    }
    return DataTable(
      sortColumnIndex: sortColumnIndex,
      sortAscending: isAscending,
      columns: getColumns(columns),
      rows: esDocumentos ? getRowsDocumentos(documentos) : getRowsMateriales(materiales),
    );
  }
  
  List<DataColumn> getColumns(List<String> columns) => columns
    .map((String column) => DataColumn(
        label: Text(column),
        onSort: onSort,
      ))
    .toList();

  List<DataRow> getRowsDocumentos(rows) => 
    rows.map<DataRow>((row) => DataRow(
      cells: [
        DataCell(ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 100),
          child: Text(
            row["dopo_NombreArchivo"],
            overflow: TextOverflow.ellipsis,)
          )
        ),
        DataCell(ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 60),
          child: Text(
            row["dopo_TipoArchivo"],
            overflow: TextOverflow.ellipsis,)
          )
        ),
        DataCell(ElevatedButton(
          onPressed: () => openFile(
            url: row["dopo_Archivo"],
            fileName: row["dopo_NombreArchivo"]
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 230, 200, 92)
          ),
          child: const Icon(Icons.remove_red_eye_rounded),
        )),
      ]
    ))
    .toList();

    List<DataRow> getRowsMateriales(rows) => 
    rows.map<DataRow>((row) => DataRow(
      cells: [
        DataCell(ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 100),
          child: Text(
            row["mate_Descripcion"],
            overflow: TextOverflow.ellipsis,)
          )
        ),
        DataCell(ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 60),
          child: Text(
            row["unme_Descripcion"],
            overflow: TextOverflow.ellipsis,)
          )
        ),
        DataCell(ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 60),
          child: Text(
            row["code_CantidadPrenda"],
            overflow: TextOverflow.ellipsis,)
          )
        ),
      ]
    ))
    .toList();

  void onSort(int columnIndex, bool ascending){
    if (columnIndex == 0){
      documentos.sort((doc1, doc2) =>
        compareString(ascending, doc1["dopo_NombreArchivo"], doc2["dopo_NombreArchivo"])
      );
    } else if (columnIndex == 1){
      documentos.sort((doc1, doc2) =>
        compareString(ascending, doc1["dopo_TipoArchivo"], doc2["dopo_TipoArchivo"])
      );
    }
    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
    ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  Future openFile({required String url, String? fileName}) async {
    final file = await downloadFile(url, fileName!);

    if(file == null) return;

    print('Path: ${file.path}');

    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, String name) async {
    try{
      final appStorage = await getApplicationDocumentsDirectory();
      final file = File('${appStorage.path}/$name');

      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;

    } catch (e) {
      CherryToast.error(
          title: const Text('Ha ocurrido un error.',
              style: TextStyle(color: Colors.white)))
      .show(context);

      print(e);

      return null;
    }
  }
}