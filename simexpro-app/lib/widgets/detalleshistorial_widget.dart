import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';

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
  final String orcoEstadoFinalizado;
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
      'codeId': codeId,
      'orcoId': orcoId,
      'codeCantidadPrenda': codeCantidadPrenda,
      'estiDescripcion': estiDescripcion,
      'codeFechaProcActual': codeFechaProcActual,
      'tallNombre': tallNombre,
      'codeSexo': codeSexo,
      'colrNombre': colrNombre,
      'codeEspecificacionEmbalaje': codeEspecificacionEmbalaje,
      'orcoCodigo': orcoCodigo,
      'orcoEstadoFinalizado': orcoEstadoFinalizado,
      'orcoEstadoOrdenCompra': orcoEstadoOrdenCompra,
      'fechaExportacion': fechaExportacion,
      'cantidadExportada': cantidadExportada,
      'fedeCajas': fedeCajas,
      'fedeTotalDetalle': fedeTotalDetalle,
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
      Uri.parse('${apiUrl}OrdenCompraDetalles/Listar?orco_Id=${orderid}'),
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
        String codefechaExportacion = data['fechaExportacion'];

        int indexOfT1 = codeFechaprocactual.indexOf('T');
        int indexOfT2 = codefechaExportacion.indexOf('T');

        if (indexOfT1 >= 0) {
          codeFechaprocactual = codeFechaprocactual.substring(0, indexOfT1);
        }
        if (indexOfT2 >= 0) {
          codefechaExportacion = codefechaExportacion.substring(0, indexOfT2);
        }

        final detalle = DetalleData(
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
          orcoEstadoFinalizado: data['orco_EstadoFinalizado'] == true ? "Si" : "No",
          orcoEstadoOrdenCompra: data['orco_EstadoOrdenCompra'] ?? "",
          fechaExportacion: codefechaExportacion ?? "",
          cantidadExportada: data['cantidadExportada'] ?? 0,
          fedeCajas: data['fede_Cajas'] ?? 0,
          fedeTotalDetalle: data['fede_TotalDetalle'] ?? 0,
        );

        return detalle;
      }).toList();

      setState(() {
        detalles = ordersdetalles;
        filtereddetalles = detalles;
      });

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
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount:
                filtereddetalles.isNotEmpty ? filtereddetalles.length : 1,
            itemBuilder: (context, index) {
              if (filtereddetalles.isNotEmpty) {
                print("Detalles: ${filtereddetalles[index].toJson()}");
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
              detalle.colrNombre
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              detalle.estiDescripcion
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Widget buildCard(DetalleData detalle) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ExpansionTile(
          initiallyExpanded: false,
          title: ListTile(
            title: Text(
              "Detalle ID #${detalle.codeId.toString()}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(detalle.estiDescripcion),
            
          ),
          children: [
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  _buildDataRow("Cantidad de Pedido:",
                      detalle.codeCantidadPrenda.toString()),
                  _buildDataRow("Fecha de Procesamiento Actual:",
                      detalle.codeFechaProcActual),
                  _buildDataRow("Talla:", detalle.tallNombre),
                  _buildDataRow("Medida:", detalle.codeSexo),
                  _buildDataRow("Color Nombre:", detalle.colrNombre),
                  _buildDataRow("Especificación de Embalaje:",
                      detalle.codeEspecificacionEmbalaje),
                  _buildDataRow("Estado Finalizado de Orden de Compra:",
                      detalle.orcoEstadoFinalizado.toString()),
                  _buildDataRow(
                      "Fecha de Exportación:", detalle.fechaExportacion),
                  _buildDataRow("Cantidad Exportada:",
                      detalle.cantidadExportada.toString()),
                  _buildDataRow("Cajas:", detalle.fedeCajas.toString()),
                  _buildDataRow(
                      "Total de Detalle:", detalle.fedeTotalDetalle.toString()),
                ],
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
