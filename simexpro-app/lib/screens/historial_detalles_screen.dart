import 'dart:convert';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/screens/historial_screen.dart';
import 'package:simexpro/screens/home_screen.dart';
import 'package:simexpro/screens/login_screen.dart';
import 'package:simexpro/screens/potracking_screen.dart';
import 'package:simexpro/screens/profile_screen.dart';
import 'package:simexpro/screens/qrscanner_screen.dart';
import 'package:simexpro/screens/timeline_screen.dart';
import 'package:simexpro/toastconfig/toastconfig.dart';
import 'package:simexpro/widgets/taps.dart';
import 'package:http/http.dart' as http;

import '../api.dart';

class OrderData {
  final int id;
  final String codigo;
  final String fechaEmision;
  final String fechaLimite;
  final String estadoOrdenCompra;
  final String nombreCliente;
  final String direccionEntrega;
  final String metodoPago;
  final String RTN;
  final String embalaje;

  OrderData({
    required this.id,
    required this.codigo,
    required this.fechaEmision,
    required this.fechaLimite,
    required this.estadoOrdenCompra,
    required this.nombreCliente,
    required this.direccionEntrega,
    required this.metodoPago,
    required this.RTN,
    required this.embalaje,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo': codigo,
      'fechaEmision': fechaEmision,
      'fechaLimite': fechaLimite,
      'estadoOrdenCompra': estadoOrdenCompra,
      'nombreCliente': nombreCliente,
      'direccionEntrega': direccionEntrega,
      'metodoPago': metodoPago,
      'RTN': RTN,
      'embalaje': embalaje,
    };
  }
}

class ItemData {
  final int codeId;
  final int orcoId;
  final int codeCantidadPrenda;
  final int estiId;
  final String estiDescripcion;
  final String codeFechaProcActual;
  final String tallNombre;
  final int tallId;
  final String codeSexo;
  final int colrId;
  final String colrNombre;
  final String codeEspecificacionEmbalaje;
  final int usuaUsuarioCreacion;
  final String usuarioCreacionNombre;
  final String codeFechaCreacion;
  final int usuaUsuarioModificacion;
  final String usuarioModificacionNombre;
  final String codeFechaModificacion;
  final bool codeEstado;
  final String orcoCodigo;
  final String clieNombreORazonSocial;
  final bool orcoEstadoFinalizado;
  final String orcoEstadoOrdenCompra;
  final int procActual;
  final int procComienza;
  final int ordenProduccion;
  final int faexId;
  final String fechaExportacion;
  final int cantidadExportada;
  final int fedeCajas;
  final int fedeTotalDetalle;

  ItemData({
    required this.codeId,
    required this.orcoId,
    required this.codeCantidadPrenda,
    required this.estiId,
    required this.estiDescripcion,
    required this.codeFechaProcActual,
    required this.tallNombre,
    required this.tallId,
    required this.codeSexo,
    required this.colrId,
    required this.colrNombre,
    required this.codeEspecificacionEmbalaje,
    required this.usuaUsuarioCreacion,
    required this.usuarioCreacionNombre,
    required this.codeFechaCreacion,
    required this.usuaUsuarioModificacion,
    required this.usuarioModificacionNombre,
    required this.codeFechaModificacion,
    required this.codeEstado,
    required this.orcoCodigo,
    required this.clieNombreORazonSocial,
    required this.orcoEstadoFinalizado,
    required this.orcoEstadoOrdenCompra,
    required this.procActual,
    required this.procComienza,
    required this.ordenProduccion,
    required this.faexId,
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
      'esti_Id': estiId,
      'esti_Descripcion': estiDescripcion,
      'code_FechaProcActual': codeFechaProcActual,
      'tall_Nombre': tallNombre,
      'tall_Id': tallId,
      'code_Sexo': codeSexo,
      'colr_Id': colrId,
      'colr_Nombre': colrNombre,
      'code_EspecificacionEmbalaje': codeEspecificacionEmbalaje,
      'usua_UsuarioCreacion': usuaUsuarioCreacion,
      'usuarioCreacionNombre': usuarioCreacionNombre,
      'code_FechaCreacion': codeFechaCreacion,
      'usua_UsuarioModificacion': usuaUsuarioModificacion,
      'usuarioModificacionNombre': usuarioModificacionNombre,
      'code_FechaModificacion': codeFechaModificacion,
      'code_Estado': codeEstado,
      'orco_Codigo': orcoCodigo,
      'clie_Nombre_O_Razon_Social': clieNombreORazonSocial,
      'orco_EstadoFinalizado': orcoEstadoFinalizado,
      'orco_EstadoOrdenCompra': orcoEstadoOrdenCompra,
      'proc_Actual': procActual,
      'proc_Comienza': procComienza,
      'ordenProduccion': ordenProduccion,
      'faex_Id': faexId,
      'fechaExportacion': fechaExportacion,
      'cantidadExportada': cantidadExportada,
      'fede_Cajas': fedeCajas,
      'fede_TotalDetalle': fedeTotalDetalle,
    };
  }
}

Future<void> Imagen() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  image = prefs.getString('image');
}

class Historial_detalles_Screen extends StatefulWidget {
  const Historial_detalles_Screen({Key? key}) : super(key: key);

  @override
  _Historial_detalles_ScreenState createState() =>
      _Historial_detalles_ScreenState();
}

class _Historial_detalles_ScreenState extends State<Historial_detalles_Screen> {
  List<OrderData> orders = [];
  List<ItemData> detalles = [];
  List<ItemData> filteredOrders = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData().then((result) {
      setState(() {
        orders = result;
      });
    });
    fetchDataDetalles().then((resultdetalles) {
      setState(() {
        detalles = resultdetalles;
        filteredOrders = detalles;
      });
    });
  }

  Future<List<OrderData>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var ordercodigo = prefs.getString('ordercodigo');

    final response = await http.get(
      Uri.parse(
          '${apiUrl}OrdenCompra/LineaTiempoOrdenCompra?orco_Codigo=$ordercodigo'),
      headers: {
        'XApiKey': apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      final dataList = decodedJson["data"] as List<dynamic>;

      final orders = dataList.map((data) {
        String fechaEmision = data['orco_FechaEmision'];
        String fechaLimite = data['orco_FechaLimite'];

        int indexOfT1 = fechaEmision.indexOf('T');
        int indexOfT2 = fechaLimite.indexOf('T');

        if (indexOfT1 >= 0) {
          fechaEmision = fechaEmision.substring(0, indexOfT1);
        }

        if (indexOfT2 >= 0) {
          fechaLimite = fechaLimite.substring(0, indexOfT2);
        }

        return OrderData(
            id: data['orco_Id'],
            codigo: data['orco_Codigo'],
            fechaEmision: fechaEmision,
            fechaLimite: fechaLimite,
            estadoOrdenCompra: data['orco_EstadoOrdenCompra'],
            nombreCliente: data['clie_Nombre_O_Razon_Social'],
            direccionEntrega: data['orco_DireccionEntrega'],
            metodoPago: data['fopa_Descripcion'],
            embalaje: data['tiem_Descripcion'],
            RTN: data['clie_RTN']);
      }).toList();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userData',
          jsonEncode(orders.map((order) => order.toJson()).toList()));

      return orders;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<ItemData>> fetchDataDetalles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var orderid = prefs.getString('orderid');

    final responsedetalles = await http.get(
      Uri.parse(
          '${apiUrl}OrdenCompraDetalles/Listar?orco_Id=$orderid'),
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

        return ItemData(
          codeId: data['code_Id'],
          orcoId: data['orco_Id'],
          codeCantidadPrenda: data['code_CantidadPrenda'],
          estiId: data['esti_Id'],
          estiDescripcion: data['esti_Descripcion'],
          codeFechaProcActual: codeFechaprocactual,
          tallNombre: data['tall_Nombre'],
          tallId: data['tall_Id'],
          codeSexo: data['code_Sexo'],
          colrId: data['colr_Id'],
          colrNombre: data['colr_Nombre'],
          codeEspecificacionEmbalaje: data['code_EspecificacionEmbalaje'],
          usuaUsuarioCreacion: data['usua_UsuarioCreacion'],
          usuarioCreacionNombre: data['usuarioCreacionNombre'],
          codeFechaCreacion: data['code_FechaCreacion'],
          usuaUsuarioModificacion: data['usua_UsuarioModificacion'],
          usuarioModificacionNombre: data['usuarioModificacionNombre'],
          codeFechaModificacion: data['code_FechaModificacion'],
          codeEstado: data['code_Estado'],
          orcoCodigo: data['orco_Codigo'],
          clieNombreORazonSocial: data['clie_Nombre_O_Razon_Social'],
          orcoEstadoFinalizado: data['orco_EstadoFinalizado'],
          orcoEstadoOrdenCompra: data['orco_EstadoOrdenCompra'],
          procActual: data['proc_Actual'],
          procComienza: data['proc_Comienza'],
          ordenProduccion: data['ordenProduccion'],
          faexId: data['faex_Id'],
          fechaExportacion: data['fechaExportacion'],
          cantidadExportada: data['cantidadExportada'],
          fedeCajas: data['fede_Cajas'],
          fedeTotalDetalle: data['fede_TotalDetalle'],
        );
      }).toList();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'ordersdetalles',
          jsonEncode(
              ordersdetalles.map((detalle) => detalle.toJson()).toList()));

      return ordersdetalles;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Image(
          height: 35,
          image: NetworkImage('https://i.ibb.co/HgdBM0r/slogan.png'),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Add the back button icon here
          onPressed: () {
            Navigator.pop(context); // Navigate back when the button is pressed
          },
        ),
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
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            //titulo

            if (orders.isNotEmpty) buildEncabezado(orders[0]),
            //barra de busqueda
            SizedBox(height: 0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14),
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

            //cards
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: filteredOrders.isNotEmpty ? filteredOrders.length : 1,
              itemBuilder: (context, index) {
                if (filteredOrders.isNotEmpty) {
                  // Muestra la tarjeta de detalles si hay datos
                  return buildCard(filteredOrders[index]);
                } else {
                  // Muestra un mensaje de que no hay detalles disponibles
                  return Center(
                    child: Text("No hay detalles disponibles"),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void onSearchTextChanged(String searchText) {
    setState(() {
      filteredOrders = detalles
          .where((detalle) =>
              detalle.estiDescripcion
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              detalle.colrNombre
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Widget buildCard(ItemData itemDetalles) {
    bool isExpanded = false; // Inicialmente, la tarjeta no está expandida

    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              "Orden #${itemDetalles.orcoCodigo}", // Usa la propiedad orcoCodigo de ItemData
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(itemDetalles
                .clieNombreORazonSocial), // Usa la propiedad clieNombreORazonSocial de ItemData
            trailing: SizedBox(
              width: 100,
              height: 25,
              child: Image.network(
                "https://i.ibb.co/GVHnGxg/encurso.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
              thickness: 1,
              height: 20,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.calendar_month_outlined,
              color: Colors.black54,
            ),
            title: Text(
              itemDetalles
                  .codeFechaProcActual, // Usa la propiedad codeFechaProcActual de ItemData
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.calendar_month,
              color: Colors.black54,
            ),
            title: Text(
              itemDetalles
                  .codeFechaCreacion, // Usa la propiedad codeFechaCreacion de ItemData
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
              ),
            ),
            title: Text(
              "En Curso",
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('userData', itemDetalles.orcoCodigo);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Historial_detalles_Screen(),
                      ),
                    );
                  },
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
                IconButton(
                  icon:
                      Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ],
            ),
          ),
          if (isExpanded) // Mostrar información adicional cuando está expandida
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Información adicional aquí",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildEncabezado(OrderData order) {
    bool isExpanded = false; // Initially, the card is not expanded

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "Detalles orden de compra #${order.codigo}",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w200,
                color: Color.fromRGBO(148, 82, 249, 1),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: GridView.count(
            // shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            // mainAxisSpacing: 1,
            childAspectRatio: 3 / 1,
            children: [
              Text.rich(TextSpan(
                text: "Cliente:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.nombreCliente}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "RTN:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.RTN}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "Fecha de Emisión",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.fechaEmision}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "Fecha Limite",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.fechaLimite}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "Embalaje general:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.embalaje}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "Dirección de entrega:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.direccionEntrega}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ],
    );
  }
}
