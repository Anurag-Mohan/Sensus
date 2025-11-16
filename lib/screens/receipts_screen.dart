import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/receipt.dart';
import '../services/storage_service.dart';

class ReceiptsScreen extends StatelessWidget {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFFFDC),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF68BA7F).withOpacity(0.95), Color(0xFF68BA7F).withOpacity(0.85)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border(bottom: BorderSide(color: Color(0xFF2E6F40).withOpacity(0.2), width: 1)),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF253D2C).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.receipt_long_rounded, color: Color(0xFF253D2C), size: 20),
            ),
            SizedBox(width: 12),
            Text('RECEIPTS', style: TextStyle(color: Color(0xFF253D2C), fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 3)),
          ],
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Receipt>('receipts').listenable(),
        builder: (context, Box<Receipt> box, _) {
          final receipts = box.values.toList();
          if (receipts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [Color(0xFF68BA7F).withOpacity(0.3), Color(0xFF2E6F40).withOpacity(0.1)]),
                    ),
                    child: Icon(Icons.receipt_long_outlined, size: 80, color: Color(0xFF2E6F40).withOpacity(0.6)),
                  ),
                  const SizedBox(height: 24),
                  Text('NO RECEIPTS YET', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF253D2C), letterSpacing: 2)),
                  const SizedBox(height: 12),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 48),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF68BA7F).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xFF2E6F40).withOpacity(0.2), width: 1),
                    ),
                    child: Text('Scan bills and receipts\nto track expenses', style: TextStyle(fontSize: 13, color: Color(0xFF2E6F40), height: 1.5), textAlign: TextAlign.center),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(16, 100, 16, 20),
            itemCount: receipts.length,
            itemBuilder: (context, index) => _buildReceiptCard(context, receipts[index], index),
          );
        },
      ),
    );
  }

  Widget _buildReceiptCard(BuildContext context, Receipt receipt, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF68BA7F).withOpacity(0.5), Color(0xFF68BA7F).withOpacity(0.3), Color(0xFF68BA7F).withOpacity(0.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color(0xFF2E6F40).withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(color: Color(0xFF2E6F40).withOpacity(0.3), blurRadius: 20, spreadRadius: 2, offset: Offset(0, 10)),
          BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 15, offset: Offset(-5, -5)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF253D2C), Color(0xFF2E6F40)]),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Color(0xFF253D2C).withOpacity(0.4), blurRadius: 8, offset: Offset(0, 4))],
                  ),
                  child: Icon(Icons.receipt_long_rounded, color: Color(0xFFCFFFDC), size: 22),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('RECEIPT #${index + 1}', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF2E6F40), letterSpacing: 1.5)),
                      SizedBox(height: 2),
                      Text(receipt.storeName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF253D2C), letterSpacing: 0.5), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Color(0xFF253D2C).withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Color(0xFF2E6F40).withOpacity(0.3), width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color.fromARGB(255, 255, 234, 116), Color.fromARGB(255, 245, 218, 88)]),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Color.fromARGB(255, 200, 170, 60).withOpacity(0.4), blurRadius: 8, offset: Offset(0, 3))],
                    ),
                    child: Icon(Icons.currency_rupee_rounded, color: Color(0xFF253D2C), size: 18),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TOTAL AMOUNT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF2E6F40).withOpacity(0.8), letterSpacing: 1)),
                        SizedBox(height: 2),
                        Text(receipt.amount != null ? '₹${receipt.amount}' : 'Not specified', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF253D2C), letterSpacing: 0.5), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF2E6F40)),
                SizedBox(width: 6),
                Expanded(child: Text(_formatDate(receipt.createdAt), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF2E6F40), letterSpacing: 0.3), maxLines: 1, overflow: TextOverflow.ellipsis)),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _showReceiptDetails(context, receipt),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF68BA7F).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFF2E6F40).withOpacity(0.3), width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.visibility_rounded, size: 14, color: Color(0xFF253D2C)),
                        SizedBox(width: 4),
                        Text('VIEW', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF253D2C), letterSpacing: 0.8)),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 6),
                GestureDetector(
                  onTap: () => _confirmDelete(context, index),
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.4), width: 1.5),
                    ),
                    child: Icon(Icons.delete_rounded, size: 16, color: Colors.red[700]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    if (diff.inDays == 1) return 'Yesterday at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFFCFFFDC),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.red[700]!.withOpacity(0.2), Colors.red[700]!.withOpacity(0.1)]), borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.warning_rounded, color: Colors.red[700], size: 24),
            ),
            SizedBox(width: 12),
            Text('DELETE RECEIPT', style: TextStyle(color: Color(0xFF253D2C), fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)),
          ],
        ),
        content: Container(
          padding: EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF68BA7F).withOpacity(0.2), Color(0xFF68BA7F).withOpacity(0.1)]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xFF2E6F40).withOpacity(0.3), width: 1.5),
          ),
          child: Text('This receipt will be permanently deleted. This action cannot be undone.', style: TextStyle(color: Color(0xFF2E6F40), fontSize: 14, height: 1.5, fontWeight: FontWeight.w600)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: Text('CANCEL', style: TextStyle(color: Color(0xFF2E6F40), fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 13)),
          ),
          ElevatedButton(
            onPressed: () {
              StorageService.deleteReceipt(index);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700], foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: Text('DELETE', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  void _showReceiptDetails(BuildContext context, Receipt receipt) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: 500, maxHeight: MediaQuery.of(context).size.height * 0.8),
          decoration: BoxDecoration(
            color: Color(0xFFCFFFDC),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Color(0xFF2E6F40).withOpacity(0.4), width: 2),
            boxShadow: [BoxShadow(color: Color(0xFF2E6F40).withOpacity(0.3), blurRadius: 30, offset: Offset(0, 15))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF68BA7F).withOpacity(0.4), Color(0xFF68BA7F).withOpacity(0.2)]),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(26), topRight: Radius.circular(26)),
                  border: Border(bottom: BorderSide(color: Color(0xFF2E6F40).withOpacity(0.3), width: 2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xFF253D2C), Color(0xFF2E6F40)]),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Color(0xFF253D2C).withOpacity(0.4), blurRadius: 8, offset: Offset(0, 4))],
                      ),
                      child: Icon(Icons.receipt_long_rounded, color: Color(0xFFCFFFDC), size: 24),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('RECEIPT DETAILS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF2E6F40), letterSpacing: 2)),
                          SizedBox(height: 4),
                          Text(receipt.storeName, style: TextStyle(color: Color(0xFF253D2C), fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.5), maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (receipt.amount != null) ...[
                        Container(
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Color.fromARGB(255, 255, 234, 116).withOpacity(0.4), Color.fromARGB(255, 245, 218, 88).withOpacity(0.3)]),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Color.fromARGB(255, 200, 170, 60).withOpacity(0.4), width: 2),
                            boxShadow: [BoxShadow(color: Color.fromARGB(255, 200, 170, 60).withOpacity(0.2), blurRadius: 12, offset: Offset(0, 4))],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Color(0xFF253D2C).withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                                child: Icon(Icons.currency_rupee_rounded, color: Color(0xFF253D2C), size: 28),
                              ),
                              SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('TOTAL AMOUNT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF2E6F40), letterSpacing: 1.5)),
                                    SizedBox(height: 4),
                                    Text('₹${receipt.amount}', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF253D2C), letterSpacing: 1), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF68BA7F).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Color(0xFF2E6F40).withOpacity(0.25), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time_rounded, color: Color(0xFF2E6F40), size: 18),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('DATE & TIME', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF2E6F40).withOpacity(0.8), letterSpacing: 1.5)),
                                  SizedBox(height: 4),
                                  Text('${receipt.createdAt.day}/${receipt.createdAt.month}/${receipt.createdAt.year} at ${receipt.createdAt.hour}:${receipt.createdAt.minute.toString().padLeft(2, '0')}', style: TextStyle(color: Color(0xFF253D2C), fontSize: 13, fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF68BA7F).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Color(0xFF2E6F40).withOpacity(0.25), width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.description_rounded, color: Color(0xFF2E6F40), size: 18),
                                SizedBox(width: 8),
                                Text('FULL TEXT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF2E6F40).withOpacity(0.8), letterSpacing: 1.5)),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(receipt.fullText, style: TextStyle(color: Color(0xFF253D2C), fontSize: 12, height: 1.6, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF253D2C), foregroundColor: Color(0xFFCFFFDC), padding: EdgeInsets.symmetric(vertical: 14), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: Text('CLOSE', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}