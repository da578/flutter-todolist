import 'package:flutter/material.dart';

class UpdateTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;

  const UpdateTextField({
    super.key,
    required this.labelText,
    required this.controller,
  });

  @override
  createState() => _UpdateTextFieldState();
}

class _UpdateTextFieldState extends State<UpdateTextField> {
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus(); // Fokus otomatis setelah widget dimuat
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: widget.controller,
            focusNode: focusNode,
            maxLines: null,
            // Biarkan TextField scrollable jika diperlukan
            style: TextStyle(
              fontSize: 36, // Font besar
              fontWeight: FontWeight.w500, // Font tebal
              color: Colors.white, // Warna teks putih (untuk tema gelap)
            ),
            decoration: InputDecoration(
              border: InputBorder.none, // Hilangkan garis bawah
              hintText: 'Enter ${widget.labelText.toLowerCase()}...',
              hintStyle: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w500,
                color: Colors.grey[400], // Warna placeholder
              ),
            ),
          ),
        ],
      ),
    );
  }
}
