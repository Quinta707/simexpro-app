import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../screens/ordertracking/itemtracking_screen.dart';

class PanelWidget extends StatelessWidget{
  final ScrollController controller;
  final PanelController panelController;

  const PanelWidget({
    Key? key,
    required this.controller,
    required this.panelController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.zero,
    controller: controller,
    children: <Widget>[
      const SizedBox(height: 15,),
      buildDragHandle(),
      const SizedBox(height: 36,),
      buildAboutText(context),
      const SizedBox(height: 24,),
    ],
  );

  Widget buildDragHandle() => GestureDetector(
    onTap: togglePanel,
    child: Center(
      child: Container(
        width: 30,
        height: 5,
        decoration: BoxDecoration(
          // color: Colors.grey[300],
          color: Colors.black12,
          borderRadius: BorderRadius.circular(18)
        ),
      ),
    ),
  );

  void togglePanel() => panelController.isPanelOpen 
    ? panelController.close()
    : panelController.open(); 

  Widget buildAboutText(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Text("hola"),

        //Search bar
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.87,
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 1.0
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    width: 0,
                    color: Colors.white,
                  )
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    width: 0,
                    color: Colors.white,
                  )
                ),
                hintText: "N° de ítem",
                hintStyle: const TextStyle(color: Colors.black54),
                prefixIcon: const Icon(
                  Icons.search, 
                  color: Colors.black54,
                  size: 20.0,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.clear, 
                    color: Colors.black54,),
                  onPressed: () {
        
                  },
                ), 
              ),
            ),
          ),
        ),
        //End search bar

        const SizedBox(height: 27),

        //Items
        Container(
        height: 135,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            splashColor: Colors.grey,
            borderRadius: BorderRadius.circular(15),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ItemTrackingScreen(),
                )
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.53, // 60% of the width
                    child: const Padding(
                      padding: EdgeInsets.only(left: 15, top: 23),
                      child: Text(
                        "Código de ítem: 314",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 18, top: 26),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              width: 20.0 / 2,
                              height: 20.0 / 2,
                            ),
                            //Dot and text separator
                            const SizedBox(width: 6),
                            const Flexible(
                              child: Text(
                                // softWrap: false,
                                "CORTE DE TELA",
                                // overflow: TextOverflow.clip,
                                style: TextStyle(fontSize: 11),
                                textAlign: TextAlign.end,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          
          
          
                const Padding(
                  padding: EdgeInsets.only(left: 15, top: 16, right: 18),
                  child: Text(
                    // softWrap: false,
                    "ESTILO: Escotada, TALLA: Extra Extra Small",
                    // overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(fontSize: 13),
                  ),
                ),
          
                const Padding(
                  padding: EdgeInsets.only(left: 15, top: 6, right: 18),
                  child: Text(
                    "COLOR: ANARANJADO, CANTIDAD: 50",
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(fontSize: 13),
                  ),
                ),
          
              ],
            ),
          ),
        ),
      ),


        const SizedBox(height: 27),

        //Items
        Container(
          height: 135,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                // color:  Color.fromARGB(255, 119, 86, 195).withOpacity(0.5),
                color:  Colors.deepPurple.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Stack(
            // alignment: Alignment.center,
            children: [
              const Positioned(
                top: 23,
                left: 15,
                child: Text(
                  "Código de ítem: 297",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                width: MediaQuery.of(context).size.width * 0.25,
                top: 26,
                right: 17,
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Wrap(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.purple,
                          ),
                        width: 20.0 / 2,
                        height: 20.0 / 2,
                        ),
                        const SizedBox(width: 6),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.21,
                          ),
                          child: const Text(
                            "ESTAMPADO",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
              const Positioned(
                top: 65,
                left: 15,
                child: Text(
                  "ESTILO: Escotada, TALLA: Extra Extra Small",
                  style: TextStyle(fontSize: 13),
                )
              ),
              const Positioned(
                top: 87,
                left: 15,
                child: Text(
                  "CANTIDAD: 12",
                  style: TextStyle(fontSize: 13),
                )
              ),
            ],
          ),
        )
      ],
    ),
  );
} 