import 'dart:io';

import 'package:flutter/material.dart';
// import 'dart:convert';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:simexpro/screens/DUCA/duca_screen.dart';


class DucaQRScannerScreen extends StatefulWidget {
  const DucaQRScannerScreen({Key? key}) : super(key: key);

  @override
  _DucaQRScannerScreenState createState() => _DucaQRScannerScreenState();
}

class _DucaQRScannerScreenState extends State<DucaQRScannerScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? barcode;
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // throw UnimplementedError();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0x00000000),
        // title: const Image(
        //   height: 35,
        //   image: NetworkImage('https://i.ibb.co/HgdBM0r/slogan.png')
        // ),
        // centerTitle: true,
      ),
      body: Stack(alignment: Alignment.center, children: <Widget>[
        buildQrView(context),
        Positioned(bottom: 10, child: buildResult()),
      ]),
    );
  }

  Widget buildResult() => Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.white24),
      child: Text(
    barcode != null
            ? 'Código: ${barcode!.code!.startsWith("https://simexpro.vercel.app/Duca/DetalleAbierto/") ? barcode!.code?.substring("https://simexpro.vercel.app/Duca/DetalleAbierto/".length) : "No es una URL válida"}'
            : 'Escanee el código',
        maxLines: 3,
        style: TextStyle(color: Colors.white),

      ));

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Theme.of(context).accentColor,
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);

  controller.scannedDataStream.listen((barcode) {
      if (barcode.code != null && barcode.code != this.barcode?.code) {
        final urlPrefix = "https://simexpro.vercel.app/Duca/DetalleAbierto/";
        final barcodeValue = barcode.code;

        if (barcodeValue != null && barcodeValue.startsWith(urlPrefix)) {
          final id = barcodeValue.substring(urlPrefix.length);
          final idAsInt = int.tryParse(id);
          print(idAsInt);
          if (idAsInt != null) {
            // El ID capturado es un número válido
            TraerDatosById(idAsInt, context);
          } else {
            // El ID no es un número válido
            // Puedes manejar esto según tus necesidades
          }
        } else {
          // El código de barras no comienza con la URL esperada
          // Puedes manejar esto según tus necesidades
        }
      }

      this.barcode = barcode;
    });

  }
}
