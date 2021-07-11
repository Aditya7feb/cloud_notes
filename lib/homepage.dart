import 'dart:math';

import 'package:cloud_notes/create_note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notes');

  List<Color> myColors = [
    Colors.yellow.shade200,
    Colors.red.shade200,
    Colors.green.shade200,
    Colors.deepPurple.shade200,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            "Notes",
            style: TextStyle(
              color: Colors.white60,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => CreateNote()))
                .then((value) {
              setState(() {});
            });
          },
          child: Icon(Icons.note_add_outlined),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: ref.get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: SafeArea(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Random random = new Random();
                      Color bg = myColors[random.nextInt(4)];
                      Map? data = snapshot.data!.docs[index].data() as Map?;
                      DateTime myDateTime = data!['created'].toDate();
                      return Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ExpansionTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data['title']}',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  DateFormat.yMMMd().format(myDateTime),
                                  style: TextStyle(),
                                ),
                              ),
                            ],
                          ),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          expandedAlignment: Alignment.centerLeft,
                          children: [
                            data['description'] != null
                                ? Text('${data['description']}')
                                : Container(),
                            ElevatedButton(
                                onPressed: () async {
                                  await snapshot.data!.docs[index].reference
                                      .delete();
                                  setState(() {});
                                },
                                child: Text("Delete"))
                          ],
                          collapsedBackgroundColor: bg,
                          childrenPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          backgroundColor: bg,
                        ),
                      );
                    },
                  ),
                ),
              );
            } else {
              return Center(
                child: Text("Loading"),
              );
            }
          },
        ));
  }
}
