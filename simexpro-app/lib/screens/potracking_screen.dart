// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:simexpro/screens/profile_screen.dart';
import 'package:simexpro/screens/widget/panel_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../widgets/navbar_roots.dart';
import 'home_screen.dart';
import 'login_screen.dart';

// ignore: must_be_immutable
class POTrackingScreen extends StatefulWidget {
  final data;
  const POTrackingScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<POTrackingScreen> createState() => _POTrackingScreenState();
}

Future<void> imagen() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  image = prefs.getString('image');
}

class Elementos {
  var linea1 = Colors.black12;
  var linea2 = Colors.black12;
  var linea3 = Colors.black12;
  // ignore: avoid_init_to_null
  var tag = null;
  String text = '';
  String image = '';

  Elementos();
}

class _POTrackingScreenState extends State<POTrackingScreen> {
   
   var elementos = Elementos();
   final panelController = PanelController();
  //  final elementos = {
  //   final linea1;
  //  };
   

  visualizarEstado(){
    if(widget.data[0]["orco_EstadoOrdenCompra"] == 'P'){
      elementos.linea1 = Colors.red;
      elementos.tag = Colors.red[100];
      elementos.text = "PENDIENTE";
      elementos.image = "pendientefinal.png";
    } else if(widget.data[0]["orco_EstadoOrdenCompra"] == 'C'){
      elementos.linea1 = Colors.amber;
      elementos.linea2 = Colors.amber;
      elementos.tag = Colors.amber[100];
      elementos.text = "EN CURSO";
      elementos.image = "encurso.png";
    } else {
      elementos.linea1 = Colors.green;
      elementos.linea2 =  Colors.green;
      elementos.linea3 =  Colors.green;
      elementos.tag = Colors.green[100];
      elementos.text = "TERMINADA";
      elementos.image = "terminado.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.16;
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.70;

    visualizarEstado();
    return Scaffold (
      appBar: AppBar(
        title: const Image(
          height: 35,
          image: NetworkImage('https://i.ibb.co/HgdBM0r/slogan.png'),
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
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
                      children: const [
                        Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.person_2_outlined,
                              color: Color.fromRGBO(87, 69, 223, 1),
                            )),
                        Text(
                          'Mi Perfil',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<MenuItem>(
                    value: MenuItem.item2,
                    child: Row(
                      children: const [
                        Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.logout,
                              color: Color.fromRGBO(87, 69, 223, 1),
                            )),
                        Text(
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
        backgroundColor: const Color.fromRGBO(17, 24, 39, 1),
      ),

      // backgroundColor: const Color.fromARGB(255, 129, 100, 197),
      // backgroundColor: Colors.white70,
      body: SlidingUpPanel(
        backdropEnabled: true,
        // color: Color.fromARGB(255, 134, 111, 189),
        color: const Color.fromARGB(255, 134, 111, 189),
        controller: panelController,
        maxHeight: panelHeightOpen,
        minHeight: panelHeightClosed,
        panelBuilder: (controller) => PanelWidget(
          controller: controller,
          panelController: panelController,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        body: 
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    // width: ,
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                    child: Text(
                      "Orden de Compra: ${widget.data[0]["orco_Codigo"]}",
                    ),
                  ),
                  const SizedBox(height: 5),
                  GridView.count(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 5.0,
                    crossAxisCount: 3,
                    childAspectRatio: 17.0,
                    // height: ,
                    children: <Widget>[
                      // visualizarEstado(),
                      // pendiente?
                      Container(
                        decoration: BoxDecoration(
                          color: elementos.linea1,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
      
                      // encurso?
                      Container(
                        decoration: BoxDecoration(
                          color: elementos.linea2,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      
                      Container(
                        decoration: BoxDecoration(
                          color: elementos.linea3,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ],
                  ),   
                  const SizedBox(height: 5),
                  Container(
                    // width: ,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                          color: elementos.tag,
                          borderRadius: const BorderRadius.all(Radius.circular(18)),
                        ),
                    child: Wrap(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: elementos.linea1,
                          ),
                        width: 20.0 / 2,
                        height: 20.0 / 2,
                        ),
                        const SizedBox(width: 7),
                        Positioned(
                          // right: 9.0,
                          child: Text(
                            elementos.text,
                            style: const TextStyle(fontSize: 11),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Image.asset(
                    'images/trackingpos/${elementos.image}',
                    height: (MediaQuery.of(context).size.height / 4) + 10,),

                
                  // Row(
                  //   children: const [
                  //     //Encabezados
                  //     Text(
                  //       "Cliente:",
                  //       style: TextStyle(
                  //         color: Colors.grey,
                  //       ),
                  //     ),
                  //     Text("RTN:"),

                  //     //Info real
                  //   ],
                  // ),
                  // const SizedBox(height: 5),

                  SizedBox(
                    height: 200,
                    child: GridView.count(
                      // shrinkWrap: true,
                      padding: const EdgeInsets.all(20),
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      // mainAxisSpacing: 1,
                      childAspectRatio: 3/1,
                      children: const [
                        // Text(
                        //   "Cliente: \nTiendas Carrión",
                        //   style: TextStyle(
                        //     color: Colors.grey,
                        //   ),
                        // ),
                        Text.rich(
                          TextSpan(
                            text: "Cliente:",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: "\nTiendas Carrión",
                                       style: TextStyle(
                                        color: Colors.black,
                                      ),
                              )
                              
                            ]
                          )
                        ),
                        Text.rich(
                          TextSpan(
                            text: "RTN:",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: "\n0512-2003-007569",
                                       style: TextStyle(
                                        color: Colors.black,
                                      ),
                              )
                              
                            ]
                          )
                        ),
                        Text.rich(
                          TextSpan(
                            text: "Fecha de emisión:",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: "\n8/9/2023",
                                       style: TextStyle(
                                        color: Colors.black,
                                      ),
                              )
                            ]
                          )
                        ),
                        Text.rich(
                          TextSpan(
                            text: "Fecha límite:",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: "\n30/9/2023",
                                       style: TextStyle(
                                        color: Colors.black,
                                      ),
                              )
                            ]
                          )
                        ),
                        Text.rich(
                          TextSpan(
                            text: "Embalaje general:",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: "\nBultos",
                                       style: TextStyle(
                                        color: Colors.black,
                                      ),
                              )
                            ]
                          )
                        ),
                        Text.rich(
                          TextSpan(
                            text: "Dirección de entrega:",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: "\nMullberry street, so good to see you.",
                                       style: TextStyle(
                                        color: Colors.black,
                                      ),
                              ),
                            ]
                          )
                        ),
                        // Text("RTN:"),
                        // Text("RTN:"),
                        // Text("RTN:"),
                        // Text("RTN:"),
                        // Text("RTN:"),
                      ],),
                  )
                ],
              ),
            ),
            
          ),
      )
    );
  }
}

// class ItemsContainer extends StatelessWidget {
//   const ItemsContainer({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(
//           color: Colors.black
//         ),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             spreadRadius: 5,
//             // blurRadius: 1,
//             // offset: const Offset(0, 3)
//           )
//         ]
//       ),
//       child: Column(
//         children: const <Widget>[
//           Text("info 1"),
//           Text("info 2"),
//           Text("info 3"),
//         ]
//       ),
//     );
//   }
// }