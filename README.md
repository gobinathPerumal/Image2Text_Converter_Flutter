Image2TextConverter(Flutter):

Description:
    1. Get image from gallery or take picture from camera.
    2. After pick the image, extract the text from the picked image.
    3. If image contain any text, it will detect and gives the exact text result.
    4. If image doesn't contain any text it gives "no text detect image..." message.

Used Plugins:
    1. image_picker
    2. firebase_ml_vision
    3. firebase_core

Integration:
    Note: Text detect from the image using Firebase ML kit - Flutter.

    1. Create Project in Firebase console and integrate firebase in your project.
    2. Place google-service.json in android-app folder.
    3. Add firebase_core and firebase_ml_vision in pubspec.yaml file
    4. Add image_picker in pubsyaml.yaml file
    5. Using image_picker plugin to pick or take images from device.
    6. Using the picked image, start detect the text from image using firebase_ml_vision plugin
    7. using performTextScanner method to detect the text from image

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

  8. In the performTextScanner method, used to convert normal image to FirebaseVisionImage.
  9. Using TextRecognizer, VisionText to detect the text from the image.
  10. Finally we get the text from the image.
