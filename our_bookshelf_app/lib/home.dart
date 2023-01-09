import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_bookshelf_app/book.dart';
import 'package:our_bookshelf_app/insert.dart';
import 'package:our_bookshelf_app/message.dart';
import 'package:our_bookshelf_app/update.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:our_bookshelf_app/auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My BookShelf List'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Insert(),
                    ));
              },
              icon: const Icon(Icons.add_outlined))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              child: Text(user?.email ?? 'User email'),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.logout_outlined,
                color: Colors.black,
              ),
              title: const Text('Logout'),
              onTap: () {
                signOut();
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('books')
              .orderBy('code', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final documents = snapshot.data!.docs;
            return ListView(
              children: documents.map((e) => _buildItemWidget(e)).toList(),
            );
          }),
    );
  }

  // Function
  Widget _buildItemWidget(DocumentSnapshot doc) {
    final book = Book(
        code: doc['code'],
        title: doc['title'],
        isbn: doc['isbn'],
        thumbnail: doc['thumbnail']);

    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_forever),
      ),
      key: ValueKey(doc),
      onDismissed: (direction) {
        FirebaseFirestore.instance.collection('books').doc(doc.id).delete();
      },
      child: Container(
        color: Colors.amberAccent,
        child: GestureDetector(
          onTap: () {
            Message.id = doc.id;
            Message.code = doc['code'];
            Message.title = doc['title'];
            Message.isbn = doc['isbn'];
            Message.thumbnail = doc['thumbnail'];
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Update(),
              ),
            );
          },
          child: Card(
            child: ListTile(
              leading: Image.network(book.thumbnail),
              title: Text(
                  '코드 : ${book.code} \n제목 : ${book.title}\nISBN : ${book.isbn}'),
            ),
          ),
        ),
      ),
    );
  }
} //
