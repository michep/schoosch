import 'dart:io';

import 'package:schoosch/controller/blueprint_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  ScanPageState createState() => ScanPageState();
}

class ScanPageState extends State<ScanPage> {
  final qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;
  Barcode? barcode;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.stopCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("scanner"),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildQrView(context),
          Positioned(
            bottom: 20,
            child: GestureDetector(
              onTap: barcode != null
                  ? () {
                      Get.find<BlueprintController>().findARoom(barcode!.code!);
                      // TODO: MAKE A FUNCTION TO FIND A ROOM
                      Get.back();
                    }
                  : () {},
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white24.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  barcode != null ? "${barcode!.code}" : "scan a qr...",
                  maxLines: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          cutOutSize: MediaQuery.of(context).size.width * 0.7,
          borderRadius: 10,
          borderWidth: 10,
          borderLength: 20,
          borderColor: Colors.blue.withOpacity(0.8),
        ),
      );

  void onQRViewCreated(QRViewController cont) {
    setState(() {
      controller = cont;
    });
    cont.scannedDataStream.listen((event) {
      setState(() {
        barcode = event;
      });
    });
  }
}
