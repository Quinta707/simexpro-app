import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/screens/login_screen.dart';
import 'package:simexpro/screens/profile_screen.dart';

import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';

import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;

import 'dart:math';
String imagen = '';
enum MenuItem { item1, item2 }

class Graficas extends StatefulWidget {
  @override
  State<Graficas> createState() => TabBarDemo();
}

Future<void> Imagen() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  imagen = prefs.getString('image');
}

// Función para generar un color aleatorio
charts.Color getRandomColor() {
  final random = Random();
  final r = random.nextInt(256);
  final g = random.nextInt(256);
  final b = random.nextInt(256);
  return charts.Color(r: r, g: g, b: b, a: 255);
}

class TabBarDemo extends State<Graficas> {
  num Conteo = 0;
  var ConteoMesPendiente = 0;
  var ConteoMesFinalizado = 0;
  var ConteoSemanaPendiente = 0;
  var ConteoSemanaFinalizado = 0;

  num GananciasSemanales = 0;
  num GananciasMensuales = 0;
  num GananciasAnio = 0;

  String MesActual = "";

  List<BarChartData> data = [];
  List<Clientes> ClientesData = [];

  //PETICION PARA OPTENER LOS DATOS DE LA GRAFICA (MODULOS MAS EFICIENTES)
  Future<void> fetchDataFromAPI() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}Graficas/ProductividadModulos'),
        headers: {
          'XApiKey': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> jsonData = responseData['data'];

        setState(() {
          data = jsonData
              .map((item) => BarChartData(item['modu_Nombre'],
                  item['totalProduccionDia'], item['porcentajeProduccion']))
              .toList();
        });
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  //PETICION PARA OPTENER LOS DATOS DE LA GRAFICA (CLIENTES PRODUCIVOS)
  Future<void> clientesProdivos() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}Graficas/ClientesProductivos'),
        headers: {
          'XApiKey': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> jsonData = responseData['data'];

        setState(() {
          ClientesData = jsonData
              .map((item) => Clientes(
                  item['clie_Nombre_O_Razon_Social'], item['cantidadIngresos']))
              .toList();
        });
      }
    } catch (error) {
      throw Exception('Error: ${error}');
    }
  }

  //PETICION PARA OPTENER LA CABTIDAD DE  ORDENES EN EL AÑO
  Future<void> OrdenesAnio() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}Graficas/OrdenenesEntregadasPendientes_Anual'),
        headers: {
          'XApiKey': apiKey,
        },
      );
      final jsonBody = json.decode(response.body);
      final data = jsonBody['data'];

      for (var item in data) {
        String avance = item['orco_Avance'];
        int conteo = item['orco_Conteo'];

        setState(() {
          if (avance == "Terminado") {
            Conteo += conteo;
          } else {
            Conteo += 0;
          }
        });
      }
    } catch (error) {
      print(error);
    }
  }

  //PETICION PARA OPTENER LA CABTIDAD DE  ORDENES EN EL MES
  Future<void> OrdenesMes() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}Graficas/OrdenenesEntregadasPendientes_Mensual'),
        headers: {
          'XApiKey': apiKey,
        },
      );
      final jsonBody = json.decode(response.body);
      final dataMes = jsonBody['data'];

      for (var item in dataMes) {
        String avance = item['orco_Avance'];
        int conteo = item['orco_Conteo'];

        setState(() {
          if (avance == "Terminado") {
            ConteoMesFinalizado += conteo;
          } else if (avance == "Pendiente") {
            ConteoMesPendiente += conteo;
          }
        });
      }
    } catch (error) {
      print(error);
    }
  }

  //PETICION PARA OPTENER LA CABTIDAD DE  ORDENES EN EL MES
  Future<void> OrdenSemana() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}Graficas/OrdenenesEntregadasPendientes_Semanal'),
        headers: {
          'XApiKey': apiKey,
        },
      );
      final jsonBody = json.decode(response.body);
      final dataMes = jsonBody['data'];

      for (var item in dataMes) {
        String avance = item['orco_Avance'];
        int conteo = item['orco_Conteo'];

        setState(() {
          if (avance == "Terminado") {
            ConteoSemanaFinalizado += conteo;
          } else if (avance == "Pendiente") {
            ConteoSemanaPendiente += conteo;
          }
        });
      }
    } catch (error) {
      print(error);
    }
  }

  //PETICION PARA OBTENER LAS GANACIAS DEL AÑO
  Future<void> OpteneGananciasAnio() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}Graficas/VentasAnuales'),
        headers: {
          'XApiKey': apiKey,
        },
      );
      final jsonBody = json.decode(response.body);
      final data = jsonBody['data'];

      for (var item in data) {
        int conteo = item['totalIngresos'];

        setState(() {
          GananciasAnio = conteo;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  //PETICION PARA OBTENER LAS GANACIAS DEL MES
  Future<void> OpteneGananciasMes() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}Graficas/VentasMensuales'),
        headers: {
          'XApiKey': apiKey,
        },
      );
      final jsonBody = json.decode(response.body);
      final data = jsonBody['data'];

      for (var item in data) {
        int conteo = item['totalIngresos'];

        setState(() {
          GananciasMensuales = conteo;
          MesActual = item['mes'];
        });
      }
    } catch (error) {
      print(error);
    }
  }

  //PETICION PARA OBTENER LAS GANACIAS DE LA SEMANA
  Future<void> OpteneGananciasSemana() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}Graficas/VentasSemanales'),
        headers: {
          'XApiKey': apiKey,
        },
      );
      final jsonBody = json.decode(response.body);
      final data = jsonBody['data'];

      for (var item in data) {
        int conteo = item['totalIngresos'];

        setState(() {
          GananciasSemanales = conteo;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  //LLMMAR  A LAS FUNCIONES QUE HACEN LAS PETICIONES A LA API
  void initState() {
    super.initState();
    fetchDataFromAPI();
    clientesProdivos();
    OrdenesAnio();
    OrdenesMes();
    OrdenSemana();
    OpteneGananciasAnio();
    OpteneGananciasMes();
    OpteneGananciasSemana();
    Imagen();
  }

  @override
  Widget build(BuildContext context) {
    // Genera una lista de colores aleatorios para el grafico pie
    final List<charts.Color> randomColors = List.generate(
      data.length,
      (_) => getRandomColor(),
    );

    //ASIGNACION DEL GRAFICO DE BARRAS (MODULOS MAS PRODUCTIVOS)
    final List<charts.Series<BarChartData, String>> seriesList = [
      charts.Series<BarChartData, String>(
        id: 'Barras',
        domainFn: (BarChartData data, _) => data.modu_Nombre,
        measureFn: (BarChartData data, _) => data.totalProduccionDia,
        labelAccessorFn: (BarChartData data, _) => '${data.porcentaje}%',
        colorFn: (BarChartData data, int? index) => randomColors[
            index ?? 0], // Asigna el color desde la lista de colores aleatorios
        data: data, // Utiliza los datos de la API
      )
    ];

    //ASIGNACION DEL GRAFICO PIE (CLIENTES MAS PRODUCTIVOS)
    final List<charts.Series<Clientes, String>> ClientesGrafica = [
      charts.Series<Clientes, String>(
        id: 'Barras',
        domainFn: (Clientes data, _) => data.cliente_Nombre,
        measureFn: (Clientes data, _) => data.Cantidad_Ingresos,
        labelAccessorFn: (Clientes data, _) {
          final porcentaje = (data.Cantidad_Ingresos /
                  ClientesData.map((cliente) => cliente.Cantidad_Ingresos)
                      .reduce((a, b) => a + b) *
                  100)
              .toStringAsFixed(2);
          return '${porcentaje}%';
        },
        colorFn: (Clientes data, int? index) => randomColors[
            index ?? 0], // Asigna el color desde la lista de colores aleatorios
        data: ClientesData, // Utiliza los datos de la API
      )
    ];

    //GRAFICA DE BARRAS (MODULOS MAS PRODUCTIVOS)
    final chart = new charts.BarChart(
      seriesList,
      animate: true,
      vertical: true,
      domainAxis: new charts.OrdinalAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
          labelStyle: new charts.TextStyleSpec(
            color: charts.MaterialPalette.black,
          ),
          labelRotation: 45,
        ),
      ),
      barRendererDecorator: charts.BarLabelDecorator<String>(
        labelAnchor: charts.BarLabelAnchor.end,
        insideLabelStyleSpec: const charts.TextStyleSpec(
          fontSize: 12, // Tamaño de letra de la etiqueta de porcentaje
          color: charts
              .Color.white, // Color de la letra de la etiqueta de porcentaje
        ),
        outsideLabelStyleSpec: charts.TextStyleSpec(
          fontSize: 12, // Tamaño de letra de la etiqueta de porcentaje
          color: charts
              .Color.black, // Color de la letra de la etiqueta de porcentaje
        ),
      ),
    );

    //GRAFICA PIE (CLIENTES MAS PRODUCTIVOS)
    final pieChart = charts.PieChart(
      ClientesGrafica,
      animate: true,
      behaviors: [
        charts.DatumLegend(
          outsideJustification: charts.OutsideJustification.endDrawArea,
          horizontalFirst: false,
          desiredMaxRows: 2,
          cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
          entryTextStyle: charts.TextStyleSpec(
            color: charts.MaterialPalette.black,
            fontSize: 15,
          ),
        ),
      ],
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 100, // Ancho de los segmentos del gráfico de pastel
        arcRendererDecorators: [
          charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition
                .auto, // Mostrar etiquetas automáticamente fuera cuando sea necesario
            leaderLineStyleSpec: charts.ArcLabelLeaderLineStyleSpec(
              color: charts.MaterialPalette
                  .black, // Color transparente para la línea líder
              length:
                  5, // Ajusta la longitud de la línea líder según sea necesario
              thickness:
                  1.0, // Ajusta el grosor de la línea líder según sea necesario
            ),
            insideLabelStyleSpec: const charts.TextStyleSpec(
              fontSize: 12, // Tamaño de letra de la etiqueta de porcentaje
              color: charts.Color
                  .white, // Color de la letra de la etiqueta de porcentaje
            ),
            outsideLabelStyleSpec: charts.TextStyleSpec(
              fontSize: 12, // Tamaño de letra de la etiqueta de porcentaje
              color: charts.Color
                  .black, // Color de la letra de la etiqueta de porcentaje
            ),
          ),
        ],
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Image(
                height: 35,
                image: NetworkImage('https://i.ibb.co/HgdBM0r/slogan.png')),
            centerTitle: true,
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(imagen),
                  child: PopupMenuButton<MenuItem>(
                    //padding: EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        imagen,
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
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.auto_graph_sharp)),
                Tab(icon: Icon(Icons.pie_chart)),
                Tab(icon: Icon(Icons.add_task)),
                Tab(icon: Icon(Icons.attach_money_rounded)),
              ],
            ),
            //systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          body: TabBarView(
            children: [
              Card(
                margin: EdgeInsets.all(10.0), // Margen de la tarjeta
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'MODULOS EFICIENTES',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0), // Centra el título
                      ),
                      Container(
                        height:
                            500, // Establece una altura específica para el contenido
                        padding: EdgeInsets.all(
                            16.0), // Padding dentro de la tarjeta
                        child:
                            chart, // El contenido de la tarjeta, en este caso, el gráfico
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(10.0), // Margen de la tarjeta
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'CLIENTES RENTABLES: LÍDERES DE INGRESOS',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0), // Centra el título
                      ),
                      Container(
                        height:
                            500, // Establece una altura específica para el contenido
                        padding: EdgeInsets.all(
                            16.0), // Padding dentro de la tarjeta
                        child:
                            pieChart, // El contenido de la tarjeta, en este caso, el gráfico
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Color.fromARGB(255, 0, 0, 0),
                                thickness: 2,
                                height: 20,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "ESTADISTICAS",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Color.fromARGB(255, 6, 5, 5),
                                thickness: 2,
                                height: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                       SizedBox(height: 15),
                      Container(
                        width: 385,
                        height: 111,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          //color: Color.fromRGBO(232, 252, 232, 1),
                          image: DecorationImage(
                            image: AssetImage(
                                'images/MaquinaCosturera.png'), // Reemplaza con la ruta de tu imagen
                            fit: BoxFit
                                .cover, // Ajusta la forma en que la imagen se adapta al contenedor
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                          border: Border.all(
                              color: Color.fromARGB(255, 83, 83, 83)),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  'ÓRDENES FINALIZADAS EN ${DateTime.now().year}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                              ),
                              const Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Divider(
                                  color: Colors.white,
                                  thickness: 3,
                                  height: 20,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        alignment: Alignment.bottomRight,
                                        decoration: const BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        Conteo == 1
                                            ? ' ${Conteo} Órden Completada'
                                            : '${Conteo} Órdenes Completadas',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Color.fromARGB(255, 0, 0, 0),
                                thickness: 2,
                                height: 20,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "ESTE MES",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Color.fromARGB(255, 6, 5, 5),
                                thickness: 2,
                                height: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: 165,
                              height: 110,
                              margin: EdgeInsets.only(left: 10),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                //color: Color.fromRGBO(255, 175, 175, 1),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                  ),
                                ],
                                border: Border.all(
                                    color: Color.fromARGB(255, 83, 83, 83)),
                                image: DecorationImage(
                                  image: AssetImage(
                                      'images/Listado.png'), // Reemplaza con la ruta de tu imagen
                                  fit: BoxFit
                                      .cover, // Ajusta la forma en que la imagen se adapta al contenedor
                                ),
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    const ListTile(
                                      title: Text(
                                        "ÓRDENES PENDIENTES DEL MES",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255)),
                                      ),
                                    ),
                                    const Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Divider(
                                        color: Colors.white,
                                        thickness: 2,
                                        height: 20,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              ConteoMesPendiente == 1
                                                  ? ' ${ConteoMesPendiente} Órden Pendiente'
                                                  : '${ConteoMesPendiente} Órdenes Pendientes',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              width: 165,
                              height: 110,
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                //color: Color.fromRGBO(208, 255, 213, 1),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                  ),
                                ],
                                border: Border.all(
                                    color: Color.fromARGB(255, 83, 83, 83)),
                                image: DecorationImage(
                                  image: AssetImage(
                                      'images/Listado.png'), // Reemplaza con la ruta de tu imagen
                                  fit: BoxFit
                                      .cover, // Ajusta la forma en que la imagen se adapta al contenedor
                                ),
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    const ListTile(
                                      title: Text(
                                        "ÓRDENES FINALIZADAS DEL MES",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255)),
                                      ),
                                    ),
                                    const Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Divider(
                                        color: Colors.white,
                                        thickness: 2,
                                        height: 20,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              ConteoMesFinalizado == 1
                                                  ? ' ${ConteoMesFinalizado} Órden Completada'
                                                  : '${ConteoMesFinalizado} Órdenes Completadas',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Color.fromARGB(255, 0, 0, 0),
                                thickness: 2,
                                height: 20,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "ESTA SEMANA",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Color.fromARGB(255, 6, 5, 5),
                                thickness: 2,
                                height: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: 165,
                              height: 110,
                              margin: EdgeInsets.only(left: 10),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                //color: Color.fromRGBO(255, 175, 175, 1),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                  ),
                                ],
                                border: Border.all(
                                    color: Color.fromARGB(255, 83, 83, 83)),
                                image: DecorationImage(
                                  image: AssetImage(
                                      'images/Cajas.png'), // Reemplaza con la ruta de tu imagen
                                  fit: BoxFit
                                      .cover, // Ajusta la forma en que la imagen se adapta al contenedor
                                ),
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    const ListTile(
                                      title: Text(
                                        "ÓRDENES PENDIENTES DE LA SEMANA",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255)),
                                      ),
                                    ),
                                    const Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Divider(
                                        color: Colors.white,
                                        thickness: 2,
                                        height: 20,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              ConteoMesPendiente == 1
                                                  ? ' ${ConteoSemanaPendiente} Órden Pendiente'
                                                  : '${ConteoSemanaPendiente} Órdenes Pendientes',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              width: 167,
                              height: 110,
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                //color: Color.fromRGBO(208, 255, 213, 1),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                  ),
                                ],
                                border: Border.all(
                                    color: Color.fromARGB(255, 83, 83, 83)),
                                image: DecorationImage(
                                  image: AssetImage(
                                      'images/Cajas.png'), // Reemplaza con la ruta de tu imagen
                                  fit: BoxFit
                                      .cover, // Ajusta la forma en que la imagen se adapta al contenedor
                                ),
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    const ListTile(
                                      title: Text(
                                        "ÓRDENES FINALIZADAS DE LA SEMANA",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255)),
                                      ),
                                    ),
                                    const Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Divider(
                                        color: Colors.white,
                                        thickness: 2,
                                        height: 20,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              ConteoMesFinalizado == 1
                                                  ? ' ${ConteoSemanaFinalizado} Órden Completada'
                                                  : '${ConteoSemanaFinalizado} Órdenes Completadas',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Color.fromARGB(255, 0, 0, 0),
                                thickness: 2,
                                height: 20,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "NUESTRAS GANACIAS",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Color.fromARGB(255, 6, 5, 5),
                                thickness: 2,
                                height: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: 385,
                        height: 145,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'images/Hilos.png'), // Reemplaza con la ruta de tu imagen
                            fit: BoxFit
                                .cover, // Ajusta la forma en que la imagen se adapta al contenedor
                          ),
                          //color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Lado izquierdo: Texto
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Container(
                                  alignment: Alignment
                                      .center, // Centrar el contenido en la columna
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center, // Centrar el texto horizontalmente
                                    children: [
                                      Text(
                                        "GANANCIAS  DEL  ${DateTime.now().year}",
                                        textAlign: TextAlign
                                            .center, // Alinea el texto al centro
                                        style: TextStyle(
                                          //fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Color.fromARGB(
                                              255, 249, 249, 249),
                                        ),
                                      ),
                                      const Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Divider(
                                          color:
                                              Color.fromARGB(255, 255, 106, 0),
                                          thickness: 3,
                                          height: 20,
                                        ),
                                      ),
                                      Text(
                                        '${GananciasAnio} .LPS',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color.fromARGB(
                                              255, 241, 240, 240),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Lado derecho: Imagen
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'images/sastre.png'), // Reemplaza con la ruta de tu imagen
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: 385,
                        height: 145,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'images/Hilos.png'), // Reemplaza con la ruta de tu imagen
                            fit: BoxFit
                                .cover, // Ajusta la forma en que la imagen se adapta al contenedor
                          ),
                          //color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Lado izquierdo: Texto
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "GANANCIAS DE ${MesActual.toUpperCase()}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color.fromARGB(
                                              255, 249, 249, 249),
                                        ),
                                      ),
                                      const Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Divider(
                                          color:
                                              Color.fromARGB(255, 255, 106, 0),
                                          thickness: 3,
                                          height: 20,
                                        ),
                                      ),
                                      Text(
                                        '${GananciasMensuales} .LPS',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color.fromARGB(
                                              255, 255, 253, 253),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Lado derecho: Imagen
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'images/costurera.png'), // Reemplaza con la ruta de tu imagen
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: 385,
                        height: 145,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'images/Hilos.png'), // Reemplaza con la ruta de tu imagen
                            fit: BoxFit
                                .cover, // Ajusta la forma en que la imagen se adapta al contenedor
                          ),
                          //color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Lado izquierdo: Texto
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "GANANCIA DE LA SEMANA",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                      const Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Divider(
                                          color:
                                              Color.fromARGB(255, 255, 106, 0),
                                          thickness: 3,
                                          height: 20,
                                        ),
                                      ),
                                      Text(
                                        '${GananciasSemanales} .LPS',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Lado derecho: Imagen
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'images/ropa.png'), // Reemplaza con la ruta de tu imagen
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BarChartData {
  final String modu_Nombre;
  final int totalProduccionDia;
  final String porcentaje;

  BarChartData(this.modu_Nombre, this.totalProduccionDia, this.porcentaje);
}

class Clientes {
  final String cliente_Nombre;
  final int Cantidad_Ingresos;

  Clientes(this.cliente_Nombre, this.Cantidad_Ingresos);
}
