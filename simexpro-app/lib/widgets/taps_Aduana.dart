import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/screens/DUCA/duca_screen.dart';
import 'package:simexpro/screens/deva_screen.dart';
import 'package:simexpro/screens/historial_screen.dart';
import 'package:simexpro/screens/historial_screen_Aduana.dart';
import 'package:simexpro/screens/login_screen.dart';
import 'package:simexpro/screens/maquinas_screen.dart';
import 'package:simexpro/screens/ordertracking/orders_screen.dart';
import 'package:simexpro/screens/profile_screen.dart';

import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';

import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;

import 'dart:math';

import 'package:simexpro/screens/rastreo_aduana.dart';
import 'package:simexpro/screens/timeline_screen.dart';
import 'package:simexpro/widgets/taps.dart';

String imagen = '';

enum MenuItem { item1, item2 }

class GraficasAduanas extends StatefulWidget {
  @override
  State<GraficasAduanas> createState() => Graficas();
}



// Función para generar un color aleatorio
charts.Color getRandomColor() {
  final random = Random();
  final r = random.nextInt(256);
  final g = random.nextInt(256);
  final b = random.nextInt(256);
  return charts.Color(r: r, g: g, b: b, a: 255);
}

class Graficas extends State<GraficasAduanas> {
  //DECLARACION DE VARIABLES UTILIZADAS EN LAS GRAFICAS
  List<PaisesExportados> PaisesData = [];
  List<AduanasIngresos> AduanasData = [];

  num ImportaciionesSemanales = 0;
  num ImportaciionesMensuales = 0;
  num ImportaciionesAnio = 0;

  String MesActual = "";

  bool esAduana1 = false;
  String imagenperfil = '';
  String username = '';
  int _selectedIndex = 0;
  List<Widget> _screens = [];

  Future<void> Imagen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    imagen = prefs.getString('image');
    imagenperfil = imagen;
    esAduana1 = prefs.getBool('esAduana');
    username = prefs.getString('username');
    setState(() {
      if (esAduana1) {
      _screens = [
        GraficasAduanas(), // Usa la pantalla relacionada con la aduana
        historialAduanaScreen(), // Modifica esta línea a la pantalla de historial relacionada con la aduana
        TimelineAduanaScreen(),
        const OrdersScreen(),
      ];
    } else {
      _screens = [
        TapsProduccion(),
        historialScreen(), // Usa la pantalla de historial existente
        TimelineScreen(),
        const OrdersScreen(),
      ];
    }
    });
  }

  //PETICION PARA OPTENER LOS DATOS DE LA GRAFICA (REGIMENES ADUANEROS MAS UTILIZADOS)
  Future<void> GetRegimenesAduaneros() async {
    try {
      final response = await http.get(
        Uri.parse(
            '${apiUrl}AduanasGraficas/PaisesMasExportadores'),
        headers: {
          'XApiKey': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> jsonData = responseData['data'];

        setState(() {
          PaisesData = jsonData
          .map((item) => PaisesExportados(item['pais_Nombre'], item['cantidad'], item['porcentaje']))
          .toList();
        });
      }
    } catch (error) {
      throw Exception('Error: ${error}');
    }
  }

  //PETICION PARA OPTENER LOS DATOS DE LA GRAFICA (ADUANAS INGRESO CON MAYOR IMPORTACION)
  Future<void> GetAduanasIngreso() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}AduanasGraficas/AduanasIngreso_CantidadPorcentaje'),
        headers: {
          'XApiKey': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> jsonData = responseData['data'];
        //print(responseData['data']);
        setState(() {
          AduanasData = jsonData
              .map((item) => AduanasIngresos(
                  item['adua_Nombre'], item['cantidad'], item['porcentaje']))
              .toList();
        });
      }
    } catch (error) {
      throw Exception('Error: ${error}');
    }
  }

  //PETICION PARA OBTENER LAS IMPORTACIONES DEL MES
  Future<void> OpteneImportacionesMes() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}AduanasGraficas/Importaciones_Contador_Mes'),
        headers: {
          'XApiKey': apiKey,
        },
      );
      final jsonBody = json.decode(response.body);
      final data = jsonBody['data'];

      for (var item in data) {
        setState(() {
          MesActual = item['mes'];
          ImportaciionesMensuales = item['cantidad'];
        });
      }
    } catch (error) {
      print(error);
    }
  }

  //PETICION PARA OBTENER LAS IMPORTACIONES DEL MES
  Future<void> OpteneImportacionesAnio() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}AduanasGraficas/Importaciones_Contador_Anio'),
        headers: {
          'XApiKey': apiKey,
        },
      );
      final jsonBody = json.decode(response.body);
      final data = jsonBody['data'];

      for (var item in data) {
        setState(() {
          ImportaciionesAnio = item['cantidad'];
        });
      }
    } catch (error) {
      print(error);
    }
  }

  //PETICION PARA OBTENER LAS IMPORTACIONES DEL MES
  Future<void> OpteneImportacionesSemana() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}AduanasGraficas/Importaciones_Contador_Semana'),
        headers: {
          'XApiKey': apiKey,
        },
      );
      final jsonBody = json.decode(response.body);
      final data = jsonBody['data'];

      for (var item in data) {
        setState(() {
          ImportaciionesSemanales = item['cantidad'];
        });
      }
    } catch (error) {
      print(error);
    }
  }

  //LLMMAR  A LAS FUNCIONES QUE HACEN LAS PETICIONES A LA API
  void initState() {
    super.initState();
    GetRegimenesAduaneros();
    GetAduanasIngreso();
    OpteneImportacionesAnio();
    OpteneImportacionesMes();
    OpteneImportacionesSemana();
    Imagen();
  }

  @override
  Widget build(BuildContext context) {
    // Genera una lista de colores aleatorios para el grafico pie
    final List<charts.Color> randomColors = List.generate(
      AduanasData.length,
      (_) => getRandomColor(),
    );

    //ASIGNACION DEL GRAFICO DE BARRAS (REGIMENES ADUANEROS MAS UTILIZADOS)
    final List<charts.Series<PaisesExportados, String>>
        DatosGraficaPaisesExportadores = [
      charts.Series<PaisesExportados, String>(
        id: 'Barras',
        domainFn: (PaisesExportados data, _) => data.pais_Nombre,
        measureFn: (PaisesExportados data, _) => data.cantidad,
        labelAccessorFn: (PaisesExportados data, _) => '${data.porcentaje}%',
        colorFn: (PaisesExportados data, int? index) =>
            getRandomColor(), // Asigna el color desde la lista de colores aleatorios
        data: PaisesData, // Utiliza los datos de la API
      )
    ];

    //ASIGNACION DEL GRAFICO DE BARRAS (REGIMENES ADUANEROS MAS UTILIZADOS)
    final List<charts.Series<AduanasIngresos, String>>
        DatosGraficaAduanasIngresos = [
      charts.Series<AduanasIngresos, String>(
        id: 'Barras',
        domainFn: (AduanasIngresos data, _) =>
            '${data.adua_Nombre} - ${data.cantidad}',
        measureFn: (AduanasIngresos data, _) => data.cantidad,
        labelAccessorFn: (AduanasIngresos data, _) => '${data.porcentaje}%',
        colorFn: (AduanasIngresos data, int? index) => randomColors[
            index ?? 0], // Asigna el color desde la lista de colores aleatorios
        data: AduanasData, // Utiliza los datos de la API
      )
    ];

    //GRAFICA DE BARRAS (REGIMENES ADUANEROS MAS UTILIZADOS)
    final GraficaPaisesExportadores = new charts.BarChart(
      DatosGraficaPaisesExportadores,
      animate: true,
      vertical: true,
      domainAxis: new charts.OrdinalAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
          labelStyle: new charts.TextStyleSpec(
            color: charts.MaterialPalette.black,
          ),
          labelRotation: 60,
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

    //GRAFICA DE BARRAS (ADUANAS DE INGRESO CON MAYOR IMPORTACIÓN)
    final pieChart = charts.PieChart(
      DatosGraficaAduanasIngresos,
      animate: true,
      behaviors: [
        charts.DatumLegend(
          outsideJustification: charts.OutsideJustification.start,
          horizontalFirst: false,
          desiredMaxRows: 5,
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
        length: 3,
        child: Scaffold(
          appBar: _selectedIndex != 0 
          ? AppBar(
                  title: const Image(
                    height: 35,
                    image: NetworkImage('https://i.ibb.co/HgdBM0r/slogan.png'),
                  ),
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
                )
          : AppBar(
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
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.auto_graph_sharp)),
                Tab(icon: Icon(Icons.pie_chart)),
                Tab(icon: Icon(Icons.add_task)),
              ],
            ),
            //systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          bottomNavigationBar: Container(
            height: 80,
            child: BottomNavigationBar(
              backgroundColor: Color.fromRGBO(17, 24, 39, 1),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Color.fromRGBO(87, 69, 223, 1),
              unselectedItemColor: Colors.white,
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled), label: "Inicio"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month_outlined), label: "Historial"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.timelapse_outlined), label: "Rastreo"),
              ],
            ),
          ),
          drawer: Drawer(
            backgroundColor: Color.fromRGBO(17, 24, 39, 1),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                SizedBox(height: 50),
                Image.network('https://i.ibb.co/HgdBM0r/slogan.png', height: 50),
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(imagenperfil),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: Text(username, style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700)),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    ListTile(
                       leading: Icon(Icons.person, color: Colors.white),
                      title: Text(
                        'Perfil',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                        ));
                      },
                    ),
                  ],
                ),
                esAduana1
                ? Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.document_scanner, color: Colors.white),
                      title: Text(
                        'Rastreo de declaraciones de valor',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DevaScreen(),
                        ));
                      },
                    ),
                    ListTile(
                       leading: Icon(Icons.edit_document, color: Colors.white),
                      title: Text(
                        'Rastreo de ducas',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DucasScreen(),
                        ));
                      },
                    )
                  ],
                )
                : Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.precision_manufacturing_rounded, color: Colors.white),
                      title: Text(
                        'Rastreo de máquinas',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MaquinasScreen(),
                        ));
                      },
                    ),
                    ListTile(
                       leading: Icon(Icons.shopping_bag_rounded, color: Colors.white),
                      title: Text(
                        'Rastreo de órdenes de compra',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrdersScreen(),
                        ));
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
          body: _selectedIndex != 0 ?  _screens[_selectedIndex] 
          : TabBarView(
            children: [
              Card(
                margin: EdgeInsets.all(10.0), // Margen de la tarjeta
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'PAISES MÁS EXPORTADORES',
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
                            GraficaPaisesExportadores, // El contenido de la tarjeta, en este caso, el gráfico
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
                          'ADUANAS DE INGRESO CON MAYOR IMPORTACIÓN',
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
                                "NUESTRAS IMPORTACIONES",
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
                        height: 155,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'images/Cargas.png'), // Reemplaza con la ruta de tu imagen
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
                                  alignment: Alignment
                                      .center, // Centrar el contenido en la columna
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center, // Centrar el texto horizontalmente
                                    children: [
                                      Text(
                                        "IMPORTACIONES   DEL  ${DateTime.now().year}",
                                        textAlign: TextAlign
                                            .center, // Alinea el texto al centro
                                        style: TextStyle(
                                          //fontWeight: FontWeight.bold,
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
                                        '${ImportaciionesAnio}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
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
                                        'images/Barco.png'), // Reemplaza con la ruta de tu imagen
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
                        height: 155,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'images/Cargas.png'), // Reemplaza con la ruta de tu imagen
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
                                        "IMPORTACIONES DE ${MesActual.toUpperCase()}",
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
                                        '${ImportaciionesMensuales}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color.fromARGB(
                                              255, 244, 243, 243),
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
                                        'images/Mundo.png'), // Reemplaza con la ruta de tu imagen
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
                        height: 155,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'images/Cargas.png'), // Reemplaza con la ruta de tu imagen
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
                                        "IMPORTACIONES DE LA SEMANA",
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
                                        '${ImportaciionesSemanales}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color.fromARGB(
                                              255, 244, 243, 243),
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
                                        'images/cargamento.png'), // Reemplaza con la ruta de tu imagen
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

class PaisesExportados {
  final String pais_Nombre;
  final int cantidad;
  final String porcentaje;

  PaisesExportados(this.pais_Nombre, this.cantidad, this.porcentaje);
}

class AduanasIngresos {
  // ignore: non_constant_identifier_names
  final String adua_Nombre;
  final int cantidad;
  final String porcentaje;

  AduanasIngresos(
    this.adua_Nombre,
    this.cantidad,
    this.porcentaje,
  );
}
