import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/widgets/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'dart:io';

class ADTDetector extends StatefulWidget {
  const ADTDetector({super.key});

  @override
  State<ADTDetector> createState() => _ADTDetectorState();
}

class _ADTDetectorState extends State<ADTDetector> {
  tfl.Interpreter? _interpreter;
  File? _image;
  double? _prediction;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    _interpreter =
        await tfl.Interpreter.fromAsset('assets/models/adt_model.tflite');
  }

  Future pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _prediction = null; // Reset prediction on new image
      });
      runModel();
    }
  }

  Future<void> runModel() async {
    if (_image == null) return;

    // Load the image from file and resize it
    img.Image imageTemp = img.decodeImage(await _image!.readAsBytes())!;
    img.Image resizedImg = img.copyResize(imageTemp, width: 640, height: 640);

    // Convert the image to a Float32List
    var buffer = Float32List(1 * 640 * 640 * 3);
    var bufferIndex = 0;
    // Correctly extracting RGB values from each pixel
    // Assume 'resizedImg' is your image object of type 'img.Image'
    for (var y = 0; y < resizedImg.height; y++) {
      for (var x = 0; x < resizedImg.width; x++) {
        // Get the pixel value (ARGB)
        var pixel = resizedImg.getPixel(x, y);

        // Extract RGB components
        var red = pixel.r;
        var green = pixel.g;
        var blue = pixel.b;

        // Normalize and store RGB values
        buffer[bufferIndex++] = red / 255.0;
        buffer[bufferIndex++] = green / 255.0;
        buffer[bufferIndex++] = blue / 255.0;
      }
    }

    // Assuming your model outputs a single float prediction but expects the output list to be shaped [1, 1]
    List<List<dynamic>> output = [
      List.filled(1, 0.0)
    ]; // Adjusted to match the expected output shape [1, 1]

    // Run the model on the input data
    _interpreter?.run(buffer.reshape([1, 640, 640, 3]), output);

    setState(() {
      _prediction = output[0]
          [0]; // Adjusted to access the first element in the nested list
    });
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Ankle Anterior Drawer Test',
            style: TextStyle(
              color: Colors.white, // Set the text color to white
            ),
          ),
          backgroundColor: TColor.primaryColor1,
          iconTheme: const IconThemeData(
              color: Colors.white), // Set the icon color to white
        ),
        body: Stack(
            fit: StackFit
                .expand, // Make the background image fill the entire screen
            children: [
              // Background Image
              Image.asset(
                'assets/images/pics/instability_background.jpg', // Replace 'background.jpg' with your image asset path
                fit: BoxFit.cover, // Cover the entire screen
              ),

              SingleChildScrollView(
                // Ensures the content is scrollable if it overflows
                padding: const EdgeInsets.all(
                    16.0), // Add padding to the body content
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CarouselSlider(
                          items: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.indigo[50],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: TColor.primaryColor2,
                                  width: 3,
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'The Anterior Drawer Test (ADT)',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: TColor.primaryColor1,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'The ADT assesses ankle stability by pulling the calcaneus forward relative to the tibia. '
                                    'It helps diagnose ligament injuries.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: TColor.primaryColor1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.indigo[50],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: TColor.primaryColor2,
                                  width: 3,
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Procedure',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: TColor.primaryColor1,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'During the ADT, the patient lies supine with the knee flexed at 90 degrees and foot flat on the table. '
                                    'The examiner stabilizes the lower leg and pulls the calcaneus forward to assess ligament integrity.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: TColor.primaryColor1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.indigo[50],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: TColor.primaryColor2,
                                  width: 3,
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Interpretation',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: TColor.primaryColor1,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'A positive ADT indicates possible ligament injury and ankle instability, '
                                    'which may require further evaluation and treatment.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: TColor.primaryColor1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          options: CarouselOptions(
                            height: 220,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            viewportFraction: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_image != null)
                        Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: TColor.primaryColor1,
                                width: 5), // Add a border to the image
                            borderRadius: BorderRadius.circular(
                                12), // Optional: make the border rounded
                          ),
                          child: Image.file(_image!),
                        ),
                      RoundButton(
                        title: 'Pick X-Ray Scan',
                        onPressed: pickImage,
                      ),
                      const SizedBox(height: 15),
                      if (_prediction != null)
                        Text(
                          'Prediction: ${_prediction! > 0.5 ? 'ADT Positive' : 'ADT Negative'}',
                          style: TextStyle(
                              fontSize: 18, // Increase text size
                              fontWeight: FontWeight.bold,
                              color: TColor
                                  .primaryColor1 // Make text bold and set the color
                              ),
                        )
                    ],
                  ),
                ),
              ),
            ]));
  }
}
