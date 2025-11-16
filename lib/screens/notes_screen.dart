import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/note.dart';
import '../services/storage_service.dart';
import '../widgets/empty_state.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFFFDC),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF68BA7F).withOpacity(0.95),
                  Color(0xFF68BA7F).withOpacity(0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF2E6F40).withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
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
              child: Icon(
                Icons.description_rounded,
                color: Color(0xFF253D2C),
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'NOTES',
              style: TextStyle(
                color: Color(0xFF253D2C),
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Note>('notes').listenable(),
        builder: (context, Box<Note> box, _) {
          final notes = box.values.toList();
          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF68BA7F).withOpacity(0.3),
                          Color(0xFF2E6F40).withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.note_outlined,
                      size: 80,
                      color: Color(0xFF2E6F40).withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'NO NOTES YET',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF253D2C),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 48),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF68BA7F).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Color(0xFF2E6F40).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Scan any text document\nto save as note',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF2E6F40),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            padding: EdgeInsets.only(top: 100),
            child: Stack(
              children: [
                
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.5,
                  child: CustomPaint(
                    size: Size(2, notes.length * 200.0 + 100),
                    painter: CurvedPathPainter(itemCount: notes.length),
                  ),
                ),
                
                Column(
                  children: List.generate(notes.length, (i) {
                    final note = notes[i];
                    final isLeft = i % 2 == 0;
                    return Container(
                      height: 200,
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                        bottom: 20,
                      ),
                      child: Stack(
                        children: [
                          
                          Positioned(
                            left: isLeft ? 0 : MediaQuery.of(context).size.width * 0.5 + 30,
                            right: isLeft ? MediaQuery.of(context).size.width * 0.5 + 30 : 0,
                            child: _buildNoteCard(context, note, i),
                          ),
                          
                          Positioned(
                            left: isLeft ? MediaQuery.of(context).size.width * 0.5 + 30 : 0,
                            right: isLeft ? 0 : MediaQuery.of(context).size.width * 0.5 + 30,
                            top: 60,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 255, 234, 116),
                                    Color.fromARGB(255, 245, 218, 88),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Color(0xFF2E6F40).withOpacity(0.25),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 200, 170, 60).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                _formatDate(note.createdAt),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF2E6F40),
                                  fontWeight: FontWeight.w700,
                                  height: 1.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, Note note, int index) {
  return GestureDetector(
    onTap: () => _showNoteDetails(context, note),
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF68BA7F).withOpacity(0.45),
            Color(0xFF68BA7F).withOpacity(0.35),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFF2E6F40).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          
          BoxShadow(
            color: Color(0xFF2E6F40).withOpacity(0.25),
            blurRadius: 15,
            spreadRadius: 1,
            offset: Offset(0, 8),
          ),
          
          BoxShadow(
            color: Color(0xFF1A4D2C).withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
          
          BoxShadow(
            color: Colors.white.withOpacity(0.15),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
          
          BoxShadow(
            color: Color(0xFF2E6F40).withOpacity(0.18),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(-2, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF253D2C).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.description_rounded,
                  color: Color(0xFF253D2C),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  note.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF253D2C),
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () => _confirmDelete(context, index),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.delete_rounded,
                    color: Colors.red[700],
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFF2E6F40).withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Text(
              note.content,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF2E6F40),
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}\n${date.hour}:${date.minute.toString().padLeft(2, '0')}';
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
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.warning_rounded,
                color: Colors.red[700],
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'DELETE NOTE',
              style: TextStyle(
                color: Color(0xFF253D2C),
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        content: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF68BA7F).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color(0xFF2E6F40).withOpacity(0.2),
            ),
          ),
          child: Text(
            'This action cannot be undone',
            style: TextStyle(
              color: Color(0xFF2E6F40),
              fontSize: 13,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'CANCEL',
              style: TextStyle(
                color: Color(0xFF2E6F40),
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
                fontSize: 12,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              StorageService.deleteNote(index);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'DELETE',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNoteDetails(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFFCFFFDC),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF253D2C).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.description_rounded,
                color: Color(0xFF253D2C),
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                note.title,
                style: TextStyle(
                  color: Color(0xFF253D2C),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF68BA7F).withOpacity(0.15),
                Color(0xFF68BA7F).withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Color(0xFF2E6F40).withOpacity(0.2),
            ),
          ),
          child: SingleChildScrollView(
            child: Text(
              note.content,
              style: TextStyle(
                color: Color(0xFF2E6F40),
                fontSize: 13,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF253D2C),
              foregroundColor: Color(0xFFCFFFDC),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'CLOSE',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CurvedPathPainter extends CustomPainter {
  final int itemCount;

  CurvedPathPainter({required this.itemCount});

  @override
  void paint(Canvas canvas, Size size) {
    
    final dashPaint = Paint()
      ..color = Color(0xFF253D2C).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    
    final shadowPaint = Paint()
      ..color = Color(0xFF253D2C).withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);

    final path = Path();
    path.moveTo(0, 50);
    
    for (int i = 0; i < itemCount; i++) {
      final startY = i * 200.0 + 50;
      final controlY1 = startY + 50;
      final controlY2 = startY + 150;
      final endY = startY + 200;
      
      if (i % 2 == 0) {
        path.cubicTo(-60, controlY1, -70, controlY2, 0, endY);
      } else {
        path.cubicTo(60, controlY1, 70, controlY2, 0, endY);
      }
    }

    
    _drawDashedPath(canvas, path, shadowPaint);
    
    _drawDashedPath(canvas, path, dashPaint);

    
    final dotPaint = Paint()
      ..color = Color(0xFF253D2C)
      ..style = PaintingStyle.fill;

    final dotOutlinePaint = Paint()
      ..color = Color(0xFFCFFFDC)
      ..style = PaintingStyle.fill;

    for (int i = 0; i <= itemCount; i++) {
      final y = i * 200.0 + 50;
      
      canvas.drawCircle(Offset(0, y), 7, dotOutlinePaint);
      
      canvas.drawCircle(Offset(0, y), 5, dotPaint);
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        final segment = metric.extractPath(distance, distance + 15);
        canvas.drawPath(segment, paint);
        distance += 25;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}