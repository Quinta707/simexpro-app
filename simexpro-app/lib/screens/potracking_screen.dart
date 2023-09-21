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
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.3;
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
        // leading: IconButton(
        //   icon: const Icon(Icons.menu),
        //   tooltip: 'Menú',
        //   onPressed: () {},
        // ),
      ),
      // backgroundColor: const Color.fromARGB(255, 129, 100, 197),
      // backgroundColor: Colors.white70,
      body: SlidingUpPanel(
        color: const Color.fromARGB(255, 129, 100, 197),
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
              // child: Column(
                // children: [
                  //Carta blanca donde se encuentra el estado y las imágenes
                  // Container(
                  //   height: (MediaQuery.of(context).size.height / 2) + 45,
                  //   decoration: const BoxDecoration(
                  //     borderRadius: BorderRadius.only(
                  //       bottomLeft: Radius.circular(50),
                  //       bottomRight: Radius.circular(50)),
                  //     color: Colors.white),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(10),
                        //   child: Text(
                        //     "Orden de Compra: PRUE123",
                        //     style: TextStyle(background: Paint()..color = Colors.black12
                        //                     ..strokeWidth = 17
                        //                     ..style = PaintingStyle.stroke,)
                        //   ),  
                        // ),
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
                        const SizedBox(height: 10),
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
                        const SizedBox(height: 15),
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
                        const SizedBox(height: 20),
                        Image.asset(
                          'images/trackingpos/${elementos.image}',
                          height: (MediaQuery.of(context).size.height / 4) + 15,),

                      ],
                    ),
                  ),
            
                  // const SizedBox(height: 15,),  

                  // const ItemsContainer(),
            
                  //Carrusel de ítems
                  // CarouselSlider(
                  //     items: [1, 2, 3, 4, 5].map((e) {
                  //       return Container(
                  //         width: MediaQuery.of(context).size.width,
                  //         height: 100,
                  //         margin: const EdgeInsets.symmetric(horizontal: 5),
                  //         padding: const EdgeInsets.symmetric(horizontal: 12),
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(25),
                  //           boxShadow: const [
                  //             BoxShadow(
                  //               color: Colors.black12,
                  //               spreadRadius: 3,
                  //               blurRadius: 1
                  //               // blurRadius: 1,
                  //               // offset: const Offset(0, 3)
                  //             )
                  //           ]
                  //         ),
                  //         child: Center(
                  //           child: Text(
                  //             "text $e",
                  //             style: const TextStyle(fontSize: 40),
                  //           ),
                  //         ),
                  //       );
                  //     }).toList(),
                  //     options: CarouselOptions(
                  //       height: 420,
                  //     ),
                  //   ),

                  // const SizedBox(height: 20,), 
                // ],
              // ),
            ),
          // ),
      )
    );
  }
}

class ItemsContainer extends StatelessWidget {
  const ItemsContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black
        ),
        boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 5,
                                // blurRadius: 1,
                                // offset: const Offset(0, 3)
                              )
                            ]
      ),
      child: Column(
        children: const <Widget>[
          Text("info 1"),
          Text("info 2"),
          Text("info 3"),
        ]
      ),
    );
  }
}