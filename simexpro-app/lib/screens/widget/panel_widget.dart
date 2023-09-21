import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
          color: const Color.fromARGB(255, 154, 127, 217),
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
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15.0
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30)
              ),
              hintText: "N° de ítem",
              prefixIcon: const Icon(
                Icons.search, 
                size: 20.0,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {

                },
              ), 
            ),
          ),
        )
      ],
    ),
  );
} 