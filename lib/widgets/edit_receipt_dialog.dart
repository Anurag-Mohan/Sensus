import 'package:flutter/material.dart';

class EditReceiptDialog extends StatefulWidget {
  final String? initialStoreName;
  final String? initialAmount;
  final String fullText;

  const EditReceiptDialog({
    super.key,
    this.initialStoreName,
    this.initialAmount,
    required this.fullText,
  });

  @override
  State<EditReceiptDialog> createState() => _EditReceiptDialogState();
}

class _EditReceiptDialogState extends State<EditReceiptDialog> {
  late TextEditingController _storeController;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _storeController = TextEditingController(text: widget.initialStoreName);
    _amountController = TextEditingController(text: widget.initialAmount);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Receipt'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _storeController,
            decoration: const InputDecoration(
              labelText: 'Store Name *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixText: '₹ ',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_storeController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Store name is required')),
              );
              return;
            }
            Navigator.pop(context, {
              'storeName': _storeController.text.trim(),
              'amount': _amountController.text.trim().isEmpty ? null : _amountController.text.trim(),
            });
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _storeController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}