import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/widgets/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'dart:io';

class FractureDetector extends StatefulWidget {
  const FractureDetector({super.key});

  @override
  State<FractureDetector> createState() => _FractureDetectorState();
}

class _FractureDetectorState extends State<FractureDetector> {
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
        await tfl.Interpreter.fromAsset('assets/models/fracture_model.tflite');
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
        title: const Text('Fracture Detector'),
        backgroundColor: TColor.primaryColor1, // Set the AppBar color
      ),
      body: SingleChildScrollView(
        // Ensures the content is scrollable if it overflows
        padding: const EdgeInsets.all(16.0), // Add padding to the body content
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Ankle fractures can greatly affect stability and function, disrupting the '
                  'joint\'s alignment and integrity. This may lead to weakened support, increased '
                  're-injury risk, and chronic instability or arthritis. Early detection is key '
                  'for effective management and rehabilitation, highlighting the need for prompt '
                  'and accurate diagnosis to maintain ankle health.',
                  textAlign: TextAlign
                      .justify, // Justify the text for better readability
                  style: TextStyle(
                    fontSize: 13, // Adjusted font size for readability
                    color: TColor
                        .primaryColor1, // Specified text color for consistency
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (_image != null)
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: TColor
                            .primaryColor1, // Adjusted to match the AppBar color
                        width: 5), // Add a border to the image
                    borderRadius: BorderRadius.circular(
                        12), // Optional: make the border rounded
                  ),
                  child: Image.file(_image!),
                ),
              RoundButton(
                title: 'Pick X-Ray Image',
                onPressed: pickImage,
              ),
              const SizedBox(height: 15),
              if (_prediction != null)
                Text(
                  'Prediction: ${_prediction! > 0.5 ? "Fracture Detected" : "You're good to go!"}',
                  style: TextStyle(
                      fontSize: 18, // Increase text size
                      color: TColor
                          .primaryColor1 // Match the text color with the AppBar
                      ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
