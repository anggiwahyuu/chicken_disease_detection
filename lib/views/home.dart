// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:chicken_disease_detection/controllers/loader_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_pytorch/flutter_pytorch.dart';
import 'package:flutter_pytorch/pigeon.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = "/home_page";

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late ModelObjectDetection _objectModel;
  List<ResultObjectDetection?> yoloResult = [];

  bool firstState = false;
  bool message = true;
  bool detected = false;

  File? _image;
  final imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel("assets/models/yolov5s-original-1.torchscript");
  }

  @override
  void dispose() async {
    super.dispose();
  }

  void handleTimeout() {
    setState(() {
      firstState = true;
    });
  }

  Timer scheduleTimeout([int milliseconds = 10000]) =>
      Timer(Duration(milliseconds: milliseconds), handleTimeout);

  Widget createCardButtonDetection(String nameModel, String selectModel1,
      String selectModel2, String modelPath1, String modelPath2) {
    return Card(
      color: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 40,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            onAlertModelSplitDataset(
                nameModel, selectModel1, selectModel2, modelPath1, modelPath2);
          },
          child: Center(
            child: Text(
              nameModel,
              style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void onAlertModelSplitDataset(String nameModel, String selectModel1,
      String selectModel2, String modelPath1, String modelPath2) {
    setState(() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                nameModel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              actions: <Widget>[
                Card(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        loadModel(modelPath1);
                        onTapModelDetection(selectModel1);
                      },
                      child: Center(
                        child: Text(
                          selectModel1,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        loadModel(modelPath2);
                        onTapModelDetection(selectModel2);
                      },
                      child: Center(
                        child: Text(
                          selectModel2,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
    });
  }

  void onTapModelDetection(String modelSelected) {
    setState(() {
      showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            color: Colors.white,
            height: 200,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  modelSelected,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.grey,
                        onTap: () {
                          Navigator.pop(context);
                          pickImage(ImageSource.camera);
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_enhance,
                              size: 40,
                              color: Colors.blue,
                            ),
                            Text(
                              "Kamera",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 100,
                      ),
                      InkWell(
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.grey,
                        onTap: () {
                          Navigator.pop(context);
                          pickImage(ImageSource.gallery);
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo,
                              size: 40,
                              color: Colors.blue,
                            ),
                            Text(
                              "Galeri",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Beranda",
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  "Pilih Model Untuk Mendeteksi Penyakit Ayam: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                actions: <Widget>[
                  createCardButtonDetection(
                      "Yolov5s Original",
                      "Yolov5s Original Split 90:10",
                      "Yolov5s Original Split 80:20",
                      "assets/models/yolov5s-original-1.torchscript",
                      "assets/models/yolov5s-original-2.torchscript"),
                  createCardButtonDetection(
                      "Yolov5s Modify 1",
                      "Yolov5s Modify 1 Split 90:10",
                      "Yolov5s Modify 1 Split 80:20",
                      "assets/models/yolov5s-modify-1-1.torchscript",
                      "assets/models/yolov5s-modify-1-2.torchscript"),
                  createCardButtonDetection(
                      "Yolov5s Modify 2",
                      "Yolov5s Modify 2 Split 90:10",
                      "Yolov5s Modify 2 Split 80:20",
                      "assets/models/yolov5s-modify-2-1.torchscript",
                      "assets/models/yolov5s-modify-2-2.torchscript"),
                  createCardButtonDetection(
                      "Yolov5s Modify 3",
                      "Yolov5s Modify 3 Split 90:10",
                      "Yolov5s Modify 3 Split 80:20",
                      "assets/models/yolov5s-modify-3-1.torchscript",
                      "assets/models/yolov5s-modify-3-2.torchscript"),
                  createCardButtonDetection(
                      "Yolov5s Modify 4",
                      "Yolov5s Modify 4 Split 90:10",
                      "Yolov5s Modify 4 Split 80:20",
                      "assets/models/yolov5s-modify-4-1.torchscript",
                      "assets/models/yolov5s-modify-4-2.torchscript"),
                  createCardButtonDetection(
                      "Yolov5s Modify 5",
                      "Yolov5s Modify 5 Split 90:10",
                      "Yolov5s Modify 5 Split 80:20",
                      "assets/models/yolov5s-modify-5-1.torchscript",
                      "assets/models/yolov5s-modify-5-2.torchscript"),
                  createCardButtonDetection(
                      "Yolov5s Modify 6",
                      "Yolov5s Modify 6 Split 90:10",
                      "Yolov5s Modify 6 Split 80:20",
                      "assets/models/yolov5s-modify-6-1.torchscript",
                      "assets/models/yolov5s-modify-6-2.torchscript"),
                ],
              );
            },
          );
        },
        tooltip: "Choose Model",
        shape: const CircleBorder(),
        child: const Icon(
          Icons.camera,
          color: Colors.white,
        ),
      ),
      body: SizedBox(
          child: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          !firstState
              ? !message
                  ? const LoaderState()
                  : const Text("Tidak Ada Gambar yang Dipilih")
              : Expanded(
                  child: _objectModel.renderBoxesOnImage(_image!, yoloResult,
                      showPercentage: true,
                      boxesColor: const Color.fromARGB(255, 255, 255, 255))),
        ],
      ))),
    );
  }

  Future pickImage(ImageSource source) async {
    final imagePicked = await imagePicker.pickImage(source: source);

    yoloResult = await _objectModel.getImagePrediction(
        await File(imagePicked!.path)
            .readAsBytes()
            .then((bytes) => FlutterImageCompress.compressWithList(bytes)),
        minimumScore: 0.4,
        IOUThershold: 0.45);

    for (var element in yoloResult) {
      if (kDebugMode) {
        print({
          "score": element?.score,
          "className": element?.className,
          "class": element?.classIndex,
          "rect": {
            "left": element?.rect.left,
            "top": element?.rect.top,
            "width": element?.rect.width,
            "height": element?.rect.height,
            "right": element?.rect.right,
            "bottom": element?.rect.bottom,
          },
        });
      }
    }

    setState(() {
      firstState = false;
      message = false;
    });

    scheduleTimeout(5 * 1000);

    setState(() {
      _image = File(imagePicked.path);
      if (kDebugMode) {
        print(_image);
      }
    });

    detected = true;
  }

  Future loadModel(String pathObjectDetectionModel) async {
    try {
      _objectModel = await FlutterPytorch.loadObjectDetectionModel(
          pathObjectDetectionModel, 4, 640, 640,
          labelPath: "assets/labels/classes.txt");

      if (kDebugMode) {
        print("Model: $pathObjectDetectionModel");
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed: $e");
      }
    }
  }
}
