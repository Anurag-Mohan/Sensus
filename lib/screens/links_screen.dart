import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/link.dart';
import '../services/storage_service.dart';
import 'package:url_launcher/url_launcher.dart';

class LinksScreen extends StatelessWidget {
  const LinksScreen({super.key});

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
                Icons.link_rounded,
                color: Color(0xFF253D2C),
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'LINKS',
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
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF253D2C).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF253D2C), size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<LinkItem>('links').listenable(),
        builder: (context, Box<LinkItem> box, _) {
          final links = box.values.toList();
          if (links.isEmpty) {
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
                      Icons.link_off_rounded,
                      size: 80,
                      color: Color(0xFF2E6F40).withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'NO LINKS FOUND',
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
                      'Add your first link using the\nfloating button below',
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
          
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 100, 16, 100),
            itemCount: links.length,
            itemBuilder: (ctx, i) {
              final link = links[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildLinkCard(context, link, i),
              );
            },
          );
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF253D2C).withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _showAddLinkDialog(context),
          backgroundColor: Color(0xFF253D2C),
          elevation: 0,
          icon: const Icon(Icons.add_rounded, color: Color(0xFFCFFFDC)),
          label: Text(
            'ADD LINK',
            style: TextStyle(
              color: Color(0xFFCFFFDC),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLinkCard(BuildContext context, LinkItem link, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Color(0xFF68BA7F).withOpacity(0.4),
            Color(0xFF68BA7F).withOpacity(0.25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Color(0xFF2E6F40).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2E6F40).withOpacity(0.15),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2E6F40).withOpacity(0.1),
                      Colors.transparent,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFF253D2C).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.label_rounded,
                          color: Color(0xFF253D2C),
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TITLE',
                              style: TextStyle(
                                color: Color(0xFF2E6F40).withOpacity(0.7),
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              link.title,
                              style: TextStyle(
                                color: Color(0xFF253D2C),
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _confirmDelete(context, index),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.delete_rounded,
                            color: Colors.red[700],
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Color(0xFF2E6F40).withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                 
                  GestureDetector(
                    onTap: () => _launchURL(link.url),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 232, 209, 119),
                            Color.fromARGB(255, 223, 182, 58),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Color(0xFF2E6F40).withOpacity(0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 151, 107, 3).withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFF2E6F40).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.link_rounded,
                              color: Color(0xFF2E6F40),
                              size: 18,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'URL',
                                  style: TextStyle(
                                    color: Color(0xFF2E6F40).withOpacity(0.8),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  link.url,
                                  style: TextStyle(
                                    color: Color(0xFF2E6F40),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 151, 107, 3),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 116, 86, 9).withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.open_in_new_rounded,
                              color: Color(0xFFCFFFDC),
                              size: 20,
                            ),
                          ),
                        ],
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
              'DELETE LINK',
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
              StorageService.deleteLink(index);
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

  void _showAddLinkDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final urlController = TextEditingController();

    final result = await showDialog<bool>(
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
                Icons.add_link_rounded,
                color: Color(0xFF253D2C),
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'NEW LINK',
              style: TextStyle(
                color: Color(0xFF253D2C),
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF68BA7F).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color(0xFF2E6F40).withOpacity(0.2),
                  ),
                ),
                child: TextField(
                  controller: urlController,
                  decoration: InputDecoration(
                    labelText: 'URL',
                    hintText: 'https://example.com',
                    prefixIcon: Icon(Icons.link_rounded, color: Color(0xFF2E6F40)),
                    labelStyle: TextStyle(
                      color: Color(0xFF2E6F40),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                    hintStyle: TextStyle(color: Color(0xFF2E6F40).withOpacity(0.5)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  style: TextStyle(
                    color: Color(0xFF253D2C),
                    fontWeight: FontWeight.w600,
                  ),
                  keyboardType: TextInputType.url,
                  autofocus: true,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF68BA7F).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color(0xFF2E6F40).withOpacity(0.2),
                  ),
                ),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'TITLE',
                    hintText: 'Give it a name',
                    prefixIcon: Icon(Icons.label_rounded, color: Color(0xFF2E6F40)),
                    labelStyle: TextStyle(
                      color: Color(0xFF2E6F40),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                    hintStyle: TextStyle(color: Color(0xFF2E6F40).withOpacity(0.5)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  style: TextStyle(
                    color: Color(0xFF253D2C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
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
            onPressed: () async {
              final url = urlController.text.trim();
              final title = titleController.text.trim();

              if (url.isEmpty || title.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.error_rounded, color: Colors.white),
                        SizedBox(width: 12),
                        Text('All fields are required'),
                      ],
                    ),
                    backgroundColor: Colors.red[700],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
                return;
              }

              if (!url.startsWith('http://') && !url.startsWith('https://')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.error_rounded, color: Colors.white),
                        SizedBox(width: 12),
                        Text('URL must start with http:// or https://'),
                      ],
                    ),
                    backgroundColor: Colors.red[700],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
                return;
              }

              await StorageService.addLink(LinkItem(
                title: title,
                url: url,
                createdAt: DateTime.now(),
              ));

              if (ctx.mounted) Navigator.pop(ctx, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF253D2C),
              foregroundColor: Color(0xFFCFFFDC),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'SAVE',
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

    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                'Link saved successfully',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: Color(0xFF68BA7F),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}