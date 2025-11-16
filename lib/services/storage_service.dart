 
import 'package:hive/hive.dart';
import '../models/contact.dart';
import '../models/note.dart';
import '../models/receipt.dart';
import '../models/link.dart';

class StorageService {
  static Box<Contact> get _contacts => Hive.box<Contact>('contacts');
  static Box<Note> get _notes => Hive.box<Note>('notes');
  static Box<Receipt> get _receipts => Hive.box<Receipt>('receipts');
  static Box<LinkItem> get _links => Hive.box<LinkItem>('links');

  static Future<void> addContact(Contact contact) => _contacts.add(contact);
  static Future<void> addNote(Note note) => _notes.add(note);
  static Future<void> addReceipt(Receipt receipt) => _receipts.add(receipt);
  static Future<void> addLink(LinkItem link) => _links.add(link);

  static List<Contact> getContacts() => _contacts.values.toList();
  static List<Note> getNotes() => _notes.values.toList();
  static List<Receipt> getReceipts() => _receipts.values.toList();
  static List<LinkItem> getLinks() => _links.values.toList();

  static Future<void> deleteContact(int index) => _contacts.deleteAt(index);
  static Future<void> deleteNote(int index) => _notes.deleteAt(index);
  static Future<void> deleteReceipt(int index) => _receipts.deleteAt(index);
  static Future<void> deleteLink(int index) => _links.deleteAt(index);
}