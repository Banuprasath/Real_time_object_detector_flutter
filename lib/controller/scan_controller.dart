import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:tflite/tflite.dart';

class ScanController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTflite();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> Cameras;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;
  var x, y, w, h = 0.0;
  var label = "";
  var val = "";

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      Cameras = await availableCameras();
      cameraController =
          await CameraController(Cameras[0], ResolutionPreset.max);
      await cameraController.initialize().then((value) {
        cameraCount = 0;
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            objectDetector(image);
          }
          update();
        });
        update();
      });
      isCameraInitialized(true);
      update();
    } else {
      print("Permission denied");
    }
  }

  initTflite() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/label.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }

  objectDetector(CameraImage image) async {
    var detector = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((e) {
        return e.bytes;
      }).toList(),
      asynch: true,
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 1,
      rotation: 90,
      threshold: 0.4,
    );

    //need to use log
    if (detector != null) {
      var OurDetectedObject = detector.first;
      //print(OurDetectedObject);
      print(
          "***********************************************************************************************result is $detector");
      val = detector[0]['label'];
      if (OurDetectedObject['confidence'] * 100 > 45) {
        label = OurDetectedObject['label'].toString();
        print(label);
        h = OurDetectedObject['rect'][0];
        w = OurDetectedObject['rect'][1];
        x = OurDetectedObject['rect'][2];
        y = OurDetectedObject['rect'][3];
      }
      update();
    }
  }
}
