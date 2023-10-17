import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:simexpro/screens/maquinas_screen.dart';

class QRScannerScreenMaquinas extends StatefulWidget {
  const QRScannerScreenMaquinas({Key? key}) : super(key: key);

  @override
  _QRScannerScreenMaquinasState createState() => _QRScannerScreenMaquinasState();
}

class _QRScannerScreenMaquinasState extends State<QRScannerScreenMaquinas> {
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
        barcode != null ? 'Código: ${barcode!.code}' : 'Escanee el código',
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

    controller.scannedDataStream.listen((barcode) => {
          if (barcode.code != this.barcode?.code)
            {TraerDatos(context, barcode.code.toString())},
          this.barcode = barcode,
        });
  }
}
