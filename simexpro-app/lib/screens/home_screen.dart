import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/widgets/listadoPruebaApi.dart';

String image = '';
Future<void>Imagen() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  image =  prefs.getString('image');
  print(image);
}

class HomeScreen extends StatelessWidget {
  @override
  void initState() {
    Imagen();
  }
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Bienvenido",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "Prendas en órdenes de compra",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: 25,),
              PruebaApi(),
            ],
          ),
        ),
      
    );
  }
}
