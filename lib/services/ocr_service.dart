import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OCRService {
  final _textRecognizer = TextRecognizer();

  
  Future<String?> scanImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (image == null) return null;

    final inputImage = InputImage.fromFilePath(image.path);
    final recognizedText = await _textRecognizer.processImage(inputImage);
    return recognizedText.text.isNotEmpty ? recognizedText.text : null;
  }

  
  Future<String?> scanImageFromFile(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      return recognizedText.text.isNotEmpty ? recognizedText.text : null;
    } catch (e) {
      print('Error processing image: $e');
      return null;
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}