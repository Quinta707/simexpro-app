import 'dart:convert';

import 'package:flutter/material.dart';


import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simexpro/screens/home_screen.dart';
import 'package:simexpro/screens/recover_password_screen.dart';
import 'package:simexpro/widgets/navbar_roots.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';
import 'package:simexpro/toastconfig/toastconfig.dart';
/// Flutter code sample for [Card].

class Cartas extends StatefulWidget {
  const Cartas({super.key});

  @override
  State<StatefulWidget> createState() => CardExamplesApp();
}

Future<void> fetchData(BuildContext context) async {

  final response = await http.get(
    Uri.parse('${apiUrl} Graficas/TotalOrdenesCompraMensual'),
    headers: {
      'XApiKey': apiKey,
    },
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

class CardExamplesApp extends State {
 // const CardExamplesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('Card Examples')),
        body:  Column(
          children: <Widget>[
            Spacer(),
            ElevatedCardExample(),
            FilledCardExample(),
            
            Spacer(),
          ],
        ),
      ),
    );
  }
}

/// An example of the elevated card type.
///
/// The default settings for [Card] will provide an elevated
/// card matching the spec:
///
/// https://m3.material.io/components/cards/specs#a012d40d-7a5c-4b07-8740-491dec79d58b
class ElevatedCardExample extends StatelessWidget {
  const ElevatedCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        child: SizedBox(
          width: 300,
          height: 100,
          child: Center(child: Text('Elevated Card')),
        ),
      ),
    );
  }
}

/// An example of the filled card type.
///
/// To make a [Card] match the filled type, the default elevation and color
/// need to be changed to the values from the spec:
///
/// https://m3.material.io/components/cards/specs#0f55bf62-edf2-4619-b00d-b9ed462f2c5a
class FilledCardExample extends StatelessWidget {
  const FilledCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: const SizedBox(
          width: 300,
          height: 100,
          child: Center(child: Text('Filled Card')),
        ),
      ),
    );
  }
}

/// An example of the outlined card type.
///
/// To make a [Card] match the outlined type, the default elevation and shape
/// need to be changed to the values from the spec:
///
/// https://m3.material.io/components/cards/specs#0f55bf62-edf2-4619-b00d-b9ed462f2c5a
class OutlinedCardExample extends StatelessWidget {
  const OutlinedCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: const SizedBox(
          width: 300,
          height: 100,
          child: Center(child: Text('Outlined Card')),
        ),
      ),
    );
  }
}
