// lib/screens/scan_screen.dart

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import '../services/nutrition_service.dart';
import '../widgets/nutrition_info_widget.dart';
import '../widgets/camera_preview_widget.dart';
import 'package:tflite/tflite.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _cameraController;
  String _prediction = "";
  Nutrition? _nutrition;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _cameraController = CameraController(camera, ResolutionPreset.high);
    await _cameraController?.initialize();
    setState(() {});
  }

  Future<void> _loadModel() async {
    await Tflite.loadModel(
      model: "assets/models/model_unquant.tflite",
      labels: "assets/models/labels.txt",
    );
  }

  Future<void> _scanImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    final image = await _cameraController?.takePicture();
    if (image == null) return;

    setState(() {
      _isLoading = true;
    });

    final recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 1,
    );

    if (recognitions != null && recognitions.isNotEmpty) {
      final recognition = recognitions.first;
      final label = recognition['label'];

      setState(() {
        _prediction = label;
      });

      final nutritionData = await loadNutritionData();
      setState(() {
        _nutrition = nutritionData[label];
        _isLoading = false;
      });
    } else {
      setState(() {
        _prediction = "Unrecognized";
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutriBro Scan'),
      ),
      body: Column(
        children: [
          if (_cameraController != null && _cameraController!.value.isInitialized)
            Expanded(
              flex: 2,
              child: CameraPreviewWidget(cameraController: _cameraController!),
            ),
          if (_isLoading)
            const CircularProgressIndicator()
          else
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_prediction.isNotEmpty) Text('Prediction: $_prediction'),
                  if (_nutrition != null)
                    NutritionInfoWidget(nutrition: _nutrition!),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _scanImage,
                    child: const Text('Scan Food'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}