import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_bookshelf_app/message.dart';

class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  late TextEditingController codeController;
  late TextEditingController titleController;
  late TextEditingController authorsController;
  late TextEditingController isbnController;

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController();
    titleController = TextEditingController();
    isbnController = TextEditingController();

    codeController.text = Message.code;
    titleController.text = Message.title;
    isbnController.text = Message.isbn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update'),
      ),
      body: Center(
        child: Column(children: [
          TextField(
            controller: codeController,
            decoration: const InputDecoration(labelText: '책번호을 입력하세요.'),
            keyboardType: TextInputType.text,
          ),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: '책제목을 입력하세요.'),
            keyboardType: TextInputType.text,
          ),
          TextField(
            controller: isbnController,
            decoration: const InputDecoration(labelText: 'ISBN을 입력하세요.'),
            keyboardType: TextInputType.text,
          ),
          ElevatedButton(
              onPressed: () {
                String code = codeController.text;
                String title = titleController.text;
                String isbn = isbnController.text;

                updateAction(code, title, isbn);
              },
              child: const Text('수정'))
        ]),
      ),
    );
  }

  // Function
  updateAction(String code, String title, String isbn) {
    FirebaseFirestore.instance
        .collection('books')
        .doc(Message.id)
        .update({'code': code, 'title': title, 'isbn': isbn});
    _showDialog(context);
  }

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('수정 결과'),
          content: const Text('수정이 완료되었습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
} // End
