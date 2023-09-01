import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simexpro/api.dart';
import 'package:http/http.dart' as http;


Future<void> fetchData() async {
  final response = await http.get(
    Uri.parse('${apiUrl}Categoria/Listar'),
    headers: {'XApiKey': apiKey,},
  );
  if(response.statusCode == 200)
  {
    final json  = response.body;
    final decodedJson = jsonDecode(json);
    final data = decodedJson["data"];

    print(data);
    return data;
  }
  else
  {
    print(response.headers);
    return ;
  }
 
}


class PruebaApi extends StatefulWidget {
  const PruebaApi({super.key});

  @override
  State<StatefulWidget> createState() => PruebaApiState();
}

class PruebaApiState extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
       padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
            ElevatedButton(
          onPressed: fetchData,
          child: Text('Realizar Solicitud a la API'),
        ),
          ]
        )
    );
  }
}

