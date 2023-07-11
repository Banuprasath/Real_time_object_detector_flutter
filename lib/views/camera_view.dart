import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:object_detection_flutter/controller/scan_controller.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Developed by Banu Prasath S",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            )),
        backgroundColor: Colors.black,
      ),
      body: GetBuilder<ScanController>(
          init: ScanController(),
          builder: (controller) {
            return controller.isCameraInitialized.value
                ? Stack(
                    children: [
                      CameraPreview(controller.cameraController),
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green, width: 4.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 100,
                            ),
                            Container(
                                color: Colors.white,
                                child: Text(
                                  controller.label,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text("Loading Preview"),
                  );
          }),
    );
  }
}
