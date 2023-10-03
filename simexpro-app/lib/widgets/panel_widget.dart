// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../screens/ordertracking/itemtracking_screen.dart';

class PanelWidget extends StatelessWidget{
  final ScrollController controller;
  final PanelController panelController;
  final detalles;

  const PanelWidget({
    Key? key,
    required this.controller,
    required this.panelController,
    required this.detalles
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
    
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: detalles.length,
          itemBuilder: (BuildContext context, int index){
            //Items
            return SingleChildScrollView(
              child: Column(
                children: [
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
                              builder: (context) => ItemTrackingScreen(detalles: detalles),
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
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15, top: 23),
                                  child: Text(
                                    "Código de ítem: ${detalles[index]["code_Id"]}",
                                    style: const TextStyle(
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
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: detalles[index]["proc_IdActual"] == 0 ? 
                                                   Colors.redAccent : detalles[index]["proc_IdActual"] > 0 ? 
                                                                        HexColor(detalles[index]["proc_CodigoHtml"]) : Colors.greenAccent,
                                          ),
                                          width: 20.0 / 2,
                                          height: 20.0 / 2,
                                        ),
                                        //Dot and text separator
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            detalles[index]["proc_IdActual"] == 0 ? 
                                                   "PENDIENTE" : detalles[index]["proc_IdActual"] > 0 ? 
                                                                        detalles[index]["proc_Descripcion"].toUpperCase() 
                                                                        : "TERMINADO",
                                            // detalles[index]["proc_Descripcion"].toUpperCase(),
                                            // overflow: TextOverflow.clip,
                                            style: const TextStyle(fontSize: 11),
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
                      
                      
                      
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 16, right: 18),
                              child: Text(
                                // softWrap: false,
                                "ESTILO: ${detalles[index]["esti_Descripcion"]}, TALLA: ${detalles[index]["tall_Nombre"]}",
                                // overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                      
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 6, right: 18),
                              child: Text(
                                "COLOR: ${detalles[index]["colr_Nombre"]}, CANTIDAD: ${detalles[index]["code_CantidadPrenda"]}",
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                      
                          ],
                        ),
                      ),
                    ),
                  ),
                
                    const SizedBox(height: 27),
                ],
              ),
            );
          },
        ),
        
      ],
    ),
  );
} 

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}