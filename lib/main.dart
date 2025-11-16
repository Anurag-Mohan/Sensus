
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';
import 'models/contact.dart';
import 'models/note.dart';
import 'models/receipt.dart';
import 'models/link.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ContactAdapter());
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(ReceiptAdapter());
  Hive.registerAdapter(LinkItemAdapter());
  await Hive.openBox<Contact>('contacts');
  await Hive.openBox<Note>('notes');
  await Hive.openBox<Receipt>('receipts');
  await Hive.openBox<LinkItem>('links');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Capture',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}