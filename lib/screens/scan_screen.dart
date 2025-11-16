import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import '../services/ocr_service.dart';
import '../services/text_parser.dart';
import '../services/storage_service.dart';
import '../models/contact.dart';
import '../models/note.dart';
import '../models/receipt.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/edit_contact_dialog.dart';
import '../widgets/edit_receipt_dialog.dart';
import '../widgets/edit_note_dialog.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  final _ocrService = OCRService();
  String? _scannedText;
  bool _loading = false;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );

        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _captureAndScan() async {
    if (_isCapturing || _cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      _isCapturing = true;
      _loading = true;
    });

    try {
      final image = await _cameraController!.takePicture();
      final text = await _ocrService.scanImageFromFile(image.path);
      
      setState(() {
        _scannedText = text;
        _loading = false;
        _isCapturing = false;
      });
      
      if (text != null && text.isNotEmpty) {
        _showOptions(text);
      } else {
        _showSnackBar('No text detected. Please try again.', Icons.warning, Colors.orange);
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _isCapturing = false;
      });
      _showSnackBar('Failed to capture image', Icons.error, Colors.red);
    }
  }

  Future<void> _scanFromGallery() async {
    setState(() => _loading = true);
    final text = await _ocrService.scanImage(ImageSource.gallery);
    setState(() {
      _scannedText = text;
      _loading = false;
    });
    if (text != null && text.isNotEmpty) {
      _showOptions(text);
    } else {
      _showSnackBar('No text detected in the image', Icons.warning, Colors.orange);
    }
  }

  void _showOptions(String text) {
    final isReceipt = TextParser.isReceipt(text);
    final isContact = TextParser.isContact(text);

    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFFCFFFDC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Color(0xFFCFFFDC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Color(0xFF2E6F40).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Save As',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF253D2C),
                ),
              ),
              const SizedBox(height: 20),
              if (isContact) ...[
                _buildOptionTile(
                  icon: Icons.contact_page,
                  title: 'Contact',
                  subtitle: 'Detected: ${TextParser.extractPhone(text) ?? TextParser.extractEmail(text)}',
                  onTap: () => _saveContact(text, ctx),
                ),
                const SizedBox(height: 12),
              ],
              if (isReceipt) ...[
                _buildOptionTile(
                  icon: Icons.receipt_long,
                  title: 'Receipt',
                  subtitle: 'Amount: ₹${TextParser.extractAmount(text) ?? 'Not detected'}',
                  onTap: () => _saveReceipt(text, ctx),
                ),
                const SizedBox(height: 12),
              ],
              _buildOptionTile(
                icon: Icons.description,
                title: 'Note',
                subtitle: 'Save as general note',
                onTap: () => _saveNote(text, ctx),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF68BA7F).withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color(0xFF2E6F40).withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF253D2C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Color(0xFFCFFFDC), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF253D2C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF2E6F40),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Color(0xFF253D2C),
            ),
          ],
        ),
      ),
    );
  }

  void _saveContact(String text, BuildContext ctx) async {
    Navigator.pop(ctx);
    
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => EditContactDialog(
        initialName: TextParser.extractStoreName(text),
        initialPhone: TextParser.extractPhone(text),
        initialEmail: TextParser.extractEmail(text),
      ),
    );

    if (result != null) {
      await StorageService.addContact(Contact(
        name: result['name'],
        phone: result['phone'],
        email: result['email'],
        createdAt: DateTime.now(),
      ));
      if (mounted) {
        _showSnackBar('Contact saved successfully', Icons.check_circle, Color(0xFF68BA7F));
      }
    }
  }

  void _saveReceipt(String text, BuildContext ctx) async {
    Navigator.pop(ctx);
    
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => EditReceiptDialog(
        initialStoreName: TextParser.extractStoreName(text),
        initialAmount: TextParser.extractAmount(text),
        fullText: text,
      ),
    );

    if (result != null) {
      await StorageService.addReceipt(Receipt(
        storeName: result['storeName'],
        amount: result['amount'],
        fullText: text,
        createdAt: DateTime.now(),
      ));
      if (mounted) {
        _showSnackBar('Receipt saved successfully', Icons.check_circle, Color(0xFF68BA7F));
      }
    }
  }

  void _saveNote(String text, BuildContext ctx) async {
    Navigator.pop(ctx);
    
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => EditNoteDialog(
        initialTitle: TextParser.extractStoreName(text),
        initialContent: text,
      ),
    );

    if (result != null) {
      await StorageService.addNote(Note(
        title: result['title'],
        content: result['content'],
        createdAt: DateTime.now(),
      ));
      if (mounted) {
        _showSnackBar('Note saved successfully', Icons.check_circle, Color(0xFF68BA7F));
      }
    }
  }

  void _showSnackBar(String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF253D2C),
      appBar: AppBar(
        backgroundColor: Color(0xFF253D2C),
        elevation: 0,
        title: Text(
          'Scan Document',
          style: TextStyle(
            color: Color(0xFFCFFFDC),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFCFFFDC)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LoadingOverlay(
        isLoading: _loading,
        message: 'Processing image...',
        child: Stack(
          children: [
            
            if (_isCameraInitialized && _cameraController != null)
              Positioned.fill(
                child: ClipRRect(
                  child: CameraPreview(_cameraController!),
                ),
              )
            else
              Positioned.fill(
                child: Container(
                  color: Color(0xFF253D2C),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFF68BA7F),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Initializing camera...',
                          style: TextStyle(
                            color: Color(0xFFCFFFDC),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF253D2C).withOpacity(0.7),
                      Colors.transparent,
                      Colors.transparent,
                      Color(0xFF253D2C).withOpacity(0.8),
                    ],
                    stops: [0.0, 0.2, 0.6, 1.0],
                  ),
                ),
              ),
            ),

            
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF68BA7F),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    
                    Positioned(
                      top: -2,
                      left: -2,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFFCFFFDC), width: 4),
                            left: BorderSide(color: Color(0xFFCFFFDC), width: 4),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFFCFFFDC), width: 4),
                            right: BorderSide(color: Color(0xFFCFFFDC), width: 4),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -2,
                      left: -2,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0xFFCFFFDC), width: 4),
                            left: BorderSide(color: Color(0xFFCFFFDC), width: 4),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0xFFCFFFDC), width: 4),
                            right: BorderSide(color: Color(0xFFCFFFDC), width: 4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFF68BA7F).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Position document within frame',
                    style: TextStyle(
                      color: Color(0xFFCFFFDC),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: ElevatedButton.icon(
                      onPressed: _scanFromGallery,
                      icon: Icon(Icons.photo_library, color: Color(0xFF253D2C)),
                      label: Text(
                        'Choose from Gallery',
                        style: TextStyle(
                          color: Color(0xFF253D2C),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFCFFFDC),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: Size(double.infinity, 56),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  GestureDetector(
                    onTap: _captureAndScan,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF68BA7F),
                        border: Border.all(
                          color: Color(0xFFCFFFDC),
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF68BA7F).withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.camera,
                          color: Color(0xFFCFFFDC),
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _ocrService.dispose();
    super.dispose();
  }
}