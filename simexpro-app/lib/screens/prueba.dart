import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';

class LineaPrueba extends StatelessWidget {
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

void TraerDatos() async {
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
  }
  datamaquina = data;
}

class Timeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            isFirst: true,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Color.fromRGBO(99, 74, 158, 1),
              padding: EdgeInsets.all(6),
            ),
            endChild: const _RightChild(
              asset: 'images/maquina.png',
              title: 'Order Placed',
              message: 'We have received your order.',
            ),
            beforeLineStyle: const LineStyle(
              color: Color.fromRGBO(99, 74, 158, 1),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Color.fromRGBO(99, 74, 158, 1),
              padding: EdgeInsets.all(6),
            ),
            endChild: const _RightChild(
              asset: 'images/maquina.png',
              title: 'Order Confirmed',
              message: 'Your order has been confirmed.',
            ),
            beforeLineStyle: const LineStyle(
              color: Color.fromRGBO(99, 74, 158, 1),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Color.fromRGBO(99, 74, 158, 1),
              padding: EdgeInsets.all(6),
            ),
            endChild: const _RightChild(
              asset: 'images/maquina.png',
              title: 'Order Processed',
              message: 'We are preparing your order.',
            ),
            beforeLineStyle: const LineStyle(
              color: Color.fromRGBO(99, 74, 158, 1),
            ),
            afterLineStyle: const LineStyle(
              color: Color(0xFFDADADA),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            isLast: true,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Color(0xFFDADADA),
              padding: EdgeInsets.all(6),
            ),
            endChild: const _RightChild(
              asset: 'images/maquina.png',
              title: 'Ready to Pickup',
              message: 'Your order is ready for pickup.',
            ),
            beforeLineStyle: const LineStyle(
              color: Color(0xFFDADADA),
            ),
          ),
        ],
      ),
    );
  }
}


class _RightChild extends StatelessWidget {
  const _RightChild({
    required this.asset,
    required this.title,
    required this.message,
  });

  final String asset;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Opacity(
            child: Image.asset(asset, height: 50),
            opacity: 1,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: Color(0xFF636564),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ), 
              ),
              const SizedBox(height: 6),
              Text(
                message,
                style: TextStyle(
                  color: Color(0xFF636564),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
 