import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';
import 'package:simexpro/screens/historial_detalles_screen.dart';

class DetalleData {
  final int codeId;
  final int orcoId;
  final int codeCantidadPrenda;
  final String estiDescripcion;
  final String codeFechaProcActual;
  final String tallNombre;
  final String codeSexo;
  final String colrNombre;
  final String codeEspecificacionEmbalaje;
  final String orcoCodigo;
  final bool orcoEstadoFinalizado;
  final String orcoEstadoOrdenCompra;
  final String fechaExportacion;
  final int cantidadExportada;
  final int fedeCajas;
  final int fedeTotalDetalle;

  DetalleData({
    required this.codeId,
    required this.orcoId,
    required this.orcoCodigo,
    required this.codeCantidadPrenda,
    required this.estiDescripcion,
    required this.codeFechaProcActual,
    required this.tallNombre,
    required this.codeSexo,
    required this.colrNombre,
    required this.codeEspecificacionEmbalaje,
    required this.orcoEstadoFinalizado,
    required this.orcoEstadoOrdenCompra,
    required this.fechaExportacion,
    required this.cantidadExportada,
    required this.fedeCajas,
    required this.fedeTotalDetalle,
  });

  Map<String, dynamic> toJson() {
    return {
      'code_Id': codeId,
      'orco_Id': orcoId,
      'code_CantidadPrenda': codeCantidadPrenda,
      'esti_Descripcion': estiDescripcion,
      'code_FechaProcActual': codeFechaProcActual,
      'tall_Nombre': tallNombre,
      'code_Sexo': codeSexo,
      'colr_Nombre': colrNombre,
      'code_EspecificacionEmbalaje': codeEspecificacionEmbalaje,
      'orco_Codigo': orcoCodigo,
      'orco_EstadoFinalizado': orcoEstadoFinalizado,
      'orco_EstadoOrdenCompra': orcoEstadoOrdenCompra,
      'fechaExportacion': fechaExportacion,
      'cantidadExportada': cantidadExportada,
      'fede_Cajas': fedeCajas,
      'fede_TotalDetalle': fedeTotalDetalle,
    };
  }
}

class Detalleshistorial extends StatefulWidget {
  @override
  _DetalleshistorialState createState() => _DetalleshistorialState();
}

class _DetalleshistorialState extends State<Detalleshistorial> {
  List<DetalleData> detalles = [];
  List<DetalleData> filtereddetalles = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData().then((result) {
      setState(() {
        detalles = result;
        filtereddetalles = detalles;
      });
    });
  }

  Future<List<DetalleData>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var orderid = prefs.getString('orderid');

    final responsedetalles = await http.get(
      Uri.parse('${apiUrl}OrdenCompraDetalles/Listar?orco_Id=3'),
      headers: {
        'XApiKey': apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (responsedetalles.statusCode == 200) {
      final decodedJson = jsonDecode(responsedetalles.body);
      final dataList = decodedJson["data"] as List<dynamic>;

      final ordersdetalles = dataList.map((data) {
        String codeFechaprocactual = data['code_FechaProcActual'];
        int indexOfT1 = codeFechaprocactual.indexOf('T');

        if (indexOfT1 >= 0) {
          codeFechaprocactual = codeFechaprocactual.substring(0, indexOfT1);
        }

        return DetalleData(
          codeId: data['code_Id'] ?? 0,
          orcoId: data['orco_Id'] ?? 0,

          codeCantidadPrenda: data['code_CantidadPrenda'] ?? 0,
          estiDescripcion: data['esti_Descripcion'] ?? "",
          codeFechaProcActual: codeFechaprocactual,
          tallNombre: data['tall_Nombre'] ?? "",
          codeSexo: data['code_Sexo'] ?? "",
          colrNombre: data['colr_Nombre'] ?? "",
          codeEspecificacionEmbalaje: data['code_EspecificacionEmbalaje'] ?? "",
          orcoCodigo: data['orco_Codigo'] ?? "",
          orcoEstadoFinalizado: data['orco_EstadoFinalizado'] ?? false,
          orcoEstadoOrdenCompra: data['orco_EstadoOrdenCompra'] ?? "",
          fechaExportacion: data['fechaExportacion'] ?? "",
          cantidadExportada: data['cantidadExportada'] ?? 0,
          fedeCajas: data['fede_Cajas'] ?? 0,
          fedeTotalDetalle: data['fede_TotalDetalle'] ?? 0,
        );
      }).toList();


      return detalles;
    } else {
      throw Exception('Failed to load data');
    }
  }

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
              controller: searchController,
              onChanged: onSearchTextChanged,
              decoration: InputDecoration(
                hintText: 'Buscar',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            itemCount:
                filtereddetalles.isNotEmpty ? filtereddetalles.length : 1,
            itemBuilder: (context, index) {
              if (filtereddetalles.isNotEmpty) {
                // Muestra la tarjeta de pedido si hay datos
                return buildCard(filtereddetalles[index]);
              } else {
                // Muestra la imagen predeterminada con el tamaño deseado
                return Center(
                  child: Image.network(
                    "https://i.ibb.co/9sgcf39/image.png",
                    fit: BoxFit.contain,
                    width: 400,
                    height: 400,
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }

  void onSearchTextChanged(String searchText) {
    setState(() {
      filtereddetalles = detalles
          .where((detalle) =>
              detalle.colrNombre.toLowerCase().contains(searchText.toLowerCase()) ||
              detalle.estiDescripcion
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Widget buildCard(DetalleData detalle) {
    return Container(
        margin: EdgeInsets.only(bottom: 16.0),
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
                  "Orden #${detalle.colrNombre}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(detalle.colrNombre),
                trailing: SizedBox(
                  width: 100,
                  height: 25,
                  child: Image.network(
                    "https://i.ibb.co/GVHnGxg/encurso.png",
                    fit: BoxFit
                        .contain, // Ajusta la imagen para que cubra el espacio
                  ),
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
                        Icons.calendar_month_outlined,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 5),
                      Text(
                        detalle.colrNombre,
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 5),
                      Text(
                        detalle.colrNombre,
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
                          color: Colors.yellow,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "En Curso",
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
                    onTap: () async {},
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
              SizedBox(height: 15),
            ],
          ),
        ));
  }
}
