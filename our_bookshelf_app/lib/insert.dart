import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Insert extends StatefulWidget {
  const Insert({super.key});

  @override
  State<Insert> createState() => _InsertState();
}

class _InsertState extends State<Insert> {
  late List data;
  late TextEditingController codeEditingController;
  //late TextEditingController titleEditingController;
  late TextEditingController isbnEditingController;
  //late TextEditingController thumbnailEditingController;
  late List result;
  late FocusNode myFocusNode;

  String title = "";
  var authors = "";
  var isbn = "";
  var thumbnail =
      "https://play-lh.googleusercontent.com/_tslXR7zUXgzpiZI9t70ywHqWAxwMi8LLSfx8Ab4Mq4NUTHMjFNxVMwTM1G0Q-XNU80=w480-h960-rw";

  @override
  void initState() {
    super.initState();
    codeEditingController = TextEditingController();
    isbnEditingController = TextEditingController();
    data = [];
    result = [];
    myFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insert Book'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: codeEditingController,
              decoration: const InputDecoration(labelText: 'Book Code를 입력하세요'),
            ),
            TextField(
              controller: isbnEditingController,
              decoration: const InputDecoration(labelText: 'ISBN을 입력하세요'),
              focusNode: myFocusNode,
            ),
            Text(title),
            Image.network(
              thumbnail,
              height: 100,
              width: 100,
            ),
            ElevatedButton(
              onPressed: () {
                String code = codeEditingController.text;
                String isbn = isbnEditingController.text;

                addAction(code, title, isbn, thumbnail);
              },
              child: const Text('추가'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (isbnEditingController.text.isEmpty) {
              myFocusNode.requestFocus();
            } else {
              getJSONData();
            }
          },
          child: const Icon(Icons.file_download)),
    );
  }

  // Function

  Future<String> getJSONData() async {
    isbn = isbnEditingController.text;
    var url = Uri.parse(
        "https://dapi.kakao.com/v3/search/book?target=isbn&query=${isbn}");
    var response = await http.get(url,
        headers: {"Authorization": "KakaoAK cd8242132c60180548aac27881f3218d"});
    var dateConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    result = dateConvertedJSON['documents'];

    setState(() {
      data.addAll(result);
    });
    title = data[0]['title'];
    thumbnail = data[0]['thumbnail'];

    return "success";
  }

  addAction(String code, String title, String isbn, String thumbnail) {
    FirebaseFirestore.instance.collection('books').add(
        {'code': code, 'title': title, 'isbn': isbn, 'thumbnail': thumbnail});
    _showDialog(context);
  }

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('입력 결과'),
          content: const Text('입력이 완료되었습니다.'),
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
