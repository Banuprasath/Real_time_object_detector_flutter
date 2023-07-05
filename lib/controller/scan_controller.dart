import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initCamera();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> Cameras;

  var isCameraInitialized = false.obs;

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      Cameras = await availableCameras();
      cameraController =
          await CameraController(Cameras[0], ResolutionPreset.max);
      await cameraController.initialize();
      isCameraInitialized(true);
      update();
    } else {
      print("Permission denied");
    }
  }
}
