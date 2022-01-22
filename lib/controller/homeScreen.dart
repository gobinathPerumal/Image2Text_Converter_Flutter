import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:splashscreen/splashscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isImageSelected = false, isExtractSelect = false;
  late File image;
  late ImagePicker imagePicker;
  String textResult = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          isImageSelected && isExtractSelect
              ? Container(
                  margin: const EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height - 120,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent)),
                        height: textResult.isNotEmpty
                            ? 120
                            : MediaQuery.of(context).size.height - 250,
                        width: textResult.isNotEmpty
                            ? 120
                            : MediaQuery.of(context).size.width,
                        child: Image.file(
                          image,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: SingleChildScrollView(
                            child: Text(
                          textResult.isEmpty
                              ? "No Text Detected...."
                              : textResult,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16,
                              color: textResult.isNotEmpty
                                  ? Colors.black
                                  : Colors.red),
                        )),
                      ),
                    ],
                  ),
                )
              : Container(
                  margin: const EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height - 120,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: isImageSelected
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height - 120,
                          width: MediaQuery.of(context).size.width,
                          child: Image.file(
                            image,
                            fit: BoxFit.fill,
                          ),
                        )
                      : const Center(
                          child: Text(
                            'Please Select or Upload Image for Scan...',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 16, color: Colors.purple),
                          ),
                        ),
                ),
          isImageSelected
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    isImageSelected
                        ? FlatButton(
                            color: Colors.black12,
                            onPressed: () {
                              setState(() {
                                isExtractSelect = false;
                                textResult = "";
                                isImageSelected = false;
                              });
                            },
                            child: const Text(
                              "Reset",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ))
                        : Container(),
                    FlatButton(
                        color: Colors.purple,
                        onPressed: () {
                          if (isImageSelected && textResult.isEmpty) {
                            setState(() {
                              isExtractSelect = true;
                            });
                            performTextScanner();
                          } else if (!isImageSelected)
                            _showOptionDialog(context);
                        },
                        child: Text(
                          isImageSelected ? "Extract Text" : "Upload Image",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        )),
                  ],
                )
              : FlatButton(
                  color: Colors.purple,
                  onPressed: () {
                    _showOptionDialog(context);
                  },
                  child: Text(
                    isImageSelected ? "Extract Text" : "Upload Image",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  )),
        ],
      ),
    );
  }

  @override
  void initState() {
    imagePicker = ImagePicker();
  }

  performTextScanner() async {
    final FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(image);
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    VisionText visionText =
        await textRecognizer.processImage(firebaseVisionImage);
    for (TextBlock textBlock in visionText.blocks) {
      final String? blockText = textBlock.text;
      for (TextLine line in textBlock.lines) {
        for (TextElement textElement in line.elements) {
          textResult += textElement.text! + " ";
        }
      }
      textResult += "\n";
    }
    setState(() {
      textResult;
    });
  }

  pickImageFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    image = File(pickedFile!.path);
    setState(() {
      textResult = "";
      isImageSelected = true;
      image;
    });
  }

  pickImageFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    image = File(pickedFile!.path);
    setState(() {
      textResult = "";
      isImageSelected = true;
      image;
    });
  }

  _showOptionDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Choose any one",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  child: Container(
                      child: Row(
                    children: [
                      Checkbox(
                          value: false,
                          activeColor: Colors.green,
                          onChanged: (newValue) {
                            Navigator.of(context).pop();
                            pickImageFromCamera();
                          }),
                      const Text(
                        'Camera',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      )
                    ],
                  )),
                  onTap: () {
                    Navigator.of(context).pop();
                    pickImageFromCamera();
                  },
                ),
                InkWell(
                  child: Container(
                      child: Row(
                    children: [
                      Checkbox(
                          value: false,
                          activeColor: Colors.green,
                          onChanged: (newValue) {
                            Navigator.of(context).pop();
                            pickImageFromGallery();
                          }),
                      const Text(
                        'Gallery',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      )
                    ],
                  )),
                  onTap: () {
                    Navigator.of(context).pop();
                    pickImageFromGallery();
                  },
                )
              ],
            ),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
}
