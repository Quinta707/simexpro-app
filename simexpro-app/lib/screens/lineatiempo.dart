import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';

void main() {
  runApp(TimelineApp());
}
void initState() {
    TraerDatos();
  }
class TimelineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Timeline'),
        ),
        body: Timeline(),
      ),
    );
  }
}

List datamaquina = [];

Future<void> TraerDatos() async {
  final response = await http.get(
    Uri.parse('${apiUrl}MaquinaHistorial/Listar'),
    headers: {
      'XApiKey': apiKey,
      'Content-Type': 'application/json',
    },
  );
  final decodedJson = jsonDecode(response.body);
  final data = decodedJson["data"];
  List<Map> filteredlist = [];
  for (var i = 0; i < data.length; i++) {
    if (data[i]["maquinaNumeroSerie"].toString() == 00001) {
      filteredlist.add(data[i]);
    }
    print(data[i]['maquinaNumeroSerie'].toString());
  }
  datamaquina = data;
}

class Timeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return TimelineTile(
            alignment: TimelineAlign.center,
            isFirst: index == 0,
            isLast: index == 4,
            indicatorStyle: IndicatorStyle(
              
              width: 38,
              color: Colors.white,
              iconStyle: IconStyle(iconData: Icons.precision_manufacturing)
            ),
            beforeLineStyle: LineStyle(color: Colors.black, thickness: 1),
            afterLineStyle: LineStyle(color: Colors.black, thickness: 1),
            startChild: Card(
              elevation: 2,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.all(5),
              child: Padding(
                padding: EdgeInsets.all(10),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    child: Tooltip(
                      message: 'Evento $index', 
                      child: Text('Evento $index'),
                    ),
                  ),
                ),
            ),
            endChild: Card(
              elevation: 2,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.all(5),
              child: Padding(
                padding: EdgeInsets.all(10),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    child: Tooltip(
                      message: 'auxilio',
                      child: Text('Descripción del evento $index'),
                    ),
                  ),
                ),
            ),
          );
        },
      ),
    ); 
  }
}
 