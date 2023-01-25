import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String? _userID;
CollectionReference usersRank = FirebaseFirestore.instance.collection("user");

class Home extends StatelessWidget {
  Home({super.key});
  final List points = [];
  final controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    _userID = user.uid;
    return Theme(
        data: ThemeData.dark(),
        child: Scaffold(
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("user")
                .doc(_userID)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: const [
                      Text("Something went wrong"),
                      Text("Check your internet connection")
                    ],
                  ),
                );
              } else if (snapshot.hasData) {
                return const AppBody();
              } else {
                return const Text("What happened huu?");
              }
            },
          ),
        ));
  }
}

class AppBody extends StatelessWidget {
  const AppBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Divider(),
      NumberRecorder(),
      Divider(),
      Actions(),
      Divider(),
      Add(),
      Divider()
    ]);
  }
}

class NumberRecorder extends StatefulWidget {
  const NumberRecorder({super.key});

  @override
  State<NumberRecorder> createState() => _NumberRecorderState();
}

class _NumberRecorderState extends State<NumberRecorder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: usersRank.doc(_userID).collection("improve").doc("1").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.14,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(snapshot.data!["DateBad"][DateTime.now()
                                  .toIso8601String()
                                  .split("T")[0]]
                              .toString()),
                          Text(snapshot.data!["BadTotal"].toString()),
                          Text("Bad",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 247, 13, 13),
                                  fontSize: 16))
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [Text("Daily"), Text("Total"), Text("")]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(snapshot.data!["DateGood"][DateTime.now()
                                  .toIso8601String()
                                  .split("T")[0]]
                              .toString()),
                          Text(snapshot.data!["GoodTotal"].toString()),
                          Text("Good",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 36, 214, 0),
                                  fontSize: 16))
                        ])
                  ]));
        }
        return Text("Www");
      },
    );
  }
}

final controllers = PageController(initialPage: 0);

class Actions extends StatefulWidget {
  const Actions({super.key});

  @override
  State<Actions> createState() => _ActionsState();
}

class _ActionsState extends State<Actions> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: usersRank.doc(_userID).collection("improve").doc("1").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {}
        if (snapshot.connectionState == ConnectionState.waiting) {}
        if (snapshot.hasData) {
          return Expanded(
              child: Column(children: [
            const Text("Bad"),
            const Text("Good"),
            Expanded(
                child: PageView(
                    controller: controllers,
                    scrollDirection: Axis.horizontal,
                    children: [
                  Container(
                      margin: EdgeInsets.all(10),
                      child: Column(children: [
                        Text("Bad"),
                        Divider(),
                        Expanded(
                            child: GridView.builder(
                                itemCount: snapshot.data!["Bad"].values
                                    .toList()
                                    .length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        crossAxisCount: 2),
                                itemBuilder: (context, index) {
                                  final badTask = snapshot
                                      .data!["Bad"]["${index}"].keys
                                      .toList()[0];
                                  return SizedBox(
                                      height: 44,
                                      width: 44,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color.fromARGB(
                                                          255, 23, 23, 23))),
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                      child: SizedBox(
                                                          height: 100,
                                                          width: 200,
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(badTask),
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () async {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      int?
                                                                          nToday;
                                                                      int?
                                                                          nTotal;
                                                                      final datas = await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'user')
                                                                          .doc(
                                                                              _userID)
                                                                          .collection(
                                                                              "improve")
                                                                          .doc(
                                                                              "1");
                                                                      final dataReadOkay =
                                                                          await datas
                                                                              .get();
                                                                      try {
                                                                        if (dataReadOkay['DateBad'].containsKey("${DateTime.now().toIso8601String().split("T")[0]}") ==
                                                                                true &&
                                                                            dataReadOkay['Bad.${index}.${snapshot.data!["Bad"]["${index}"].keys.toList()[0]}'].containsKey("${DateTime.now().toIso8601String().split("T")[0]}") ==
                                                                                true) {
                                                                          todayBad =
                                                                              dataReadOkay['DateBad.${DateTime.now().toIso8601String().split("T")[0]}'];
                                                                          badTotal =
                                                                              dataReadOkay["BadTotal"];
                                                                          nTotal =
                                                                              dataReadOkay['Bad.${index}.${snapshot.data!["Bad"]["${index}"].keys.toList()[0]}.Total'];
                                                                          nToday =
                                                                              dataReadOkay['Bad.${index}.${snapshot.data!["Bad"]["${index}"].keys.toList()[0]}.${DateTime.now().toIso8601String().split("T")[0]}'];
                                                                          await datas
                                                                              .update({
                                                                            'DateBad.${DateTime.now().toIso8601String().split("T")[0]}':
                                                                                todayBad! + 1,
                                                                            'BadTotal':
                                                                                badTotal! + 1,
                                                                            'Bad.${index}.${snapshot.data!["Bad"]["${index}"].keys.toList()[0]}.Total':
                                                                                nTotal! + 1,
                                                                            'Bad.${index}.${snapshot.data!["Bad"]["${index}"].keys.toList()[0]}.${DateTime.now().toIso8601String().split("T")[0]}':
                                                                                nToday! + 1
                                                                          });
                                                                        } else if (dataReadOkay['DateBad'].containsKey("${DateTime.now().toIso8601String().split("T")[0]}") ==
                                                                                true &&
                                                                            dataReadOkay['Bad.${index}.${snapshot.data!["Bad"]["${index}"].keys.toList()[0]}'].containsKey("${DateTime.now().toIso8601String().split("T")[0]}") ==
                                                                                false) {
                                                                          todayBad =
                                                                              dataReadOkay['DateBad.${DateTime.now().toIso8601String().split("T")[0]}'];
                                                                          badTotal =
                                                                              dataReadOkay["BadTotal"];
                                                                          nTotal =
                                                                              dataReadOkay['Bad.${index}.${snapshot.data!["Bad"]["${index}"].keys.toList()[0]}.Total'];
                                                                          await datas
                                                                              .update({
                                                                            'DateBad.${DateTime.now().toIso8601String().split("T")[0]}':
                                                                                todayBad! + 1,
                                                                            'BadTotal':
                                                                                badTotal! + 1,
                                                                            'Bad.${index}.${snapshot.data!["Bad"]["${index}"].keys.toList()[0]}.Total':
                                                                                nTotal! + 1,
                                                                            'Bad.${index}.${snapshot.data!["Bad"]["${index}"].keys.toList()[0]}.${DateTime.now().toIso8601String().split("T")[0]}':
                                                                                1
                                                                          });
                                                                        } else if (dataReadOkay['DateBad'].containsKey("${DateTime.now().toIso8601String().split("T")[0]}") ==
                                                                                false &&
                                                                            dataReadOkay['Bad.${index}.${snapshot.data!["Bad"]["${index}"].keys.toList()[0]}'].containsKey("${DateTime.now().toIso8601String().split("T")[0]}") ==
                                                                                false) {
                                                                          badTotal =
                                                                              dataReadOkay["BadTotal"];
                                                                          nTotal =
                                                                              dataReadOkay['Bad.${index}.${snapshot.data!["Bad"]["${index}"].keys.toList()[0]}.Total'];
                                                                          await datas
                                                                              .update({
                                                                            'DateBad.${DateTime.now().toIso8601String().split("T")[0]}':
                                                                                1,
                                                                            'BadTotal':
                                                                                badTotal! + 1,
                                                                            'Bad.${index}.${snapshot.data!["Bad"]["${index}"].keys.toList()[0]}.Total':
                                                                                nTotal! + 1,
                                                                            'Bad.${index}.${snapshot.data!["Bad"]["${index}"].keys.toList()[0]}.${DateTime.now().toIso8601String().split("T")[0]}':
                                                                                1
                                                                          });
                                                                        }
                                                                      } catch (e) {}
                                                                    },
                                                                    child: Text(
                                                                        "Confirm"))
                                                              ])));
                                                });
                                          },
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    snapshot.data!["Bad"]
                                                            ["${index}"][
                                                            "${snapshot.data!["Bad"]["${index}"].keys.toList()[0]}"]
                                                            [
                                                            "${DateTime.now().toIso8601String().split("T")[0]}"]
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 26)),
                                                Text(
                                                    snapshot.data!["Bad"]
                                                            ["${index}"][
                                                            "${snapshot.data!["Bad"]["${index}"].keys.toList()[0]}"]
                                                            ["Total"]
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 26)),
                                                Text(badTask,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 247, 13, 13),
                                                        fontSize: 16))
                                              ])));
                                }))
                      ])),
                  Container(
                      margin: EdgeInsets.all(10),
                      child: Column(children: [
                        Text("Good"),
                        Divider(),
                        Expanded(
                            child: GridView.builder(
                                itemCount: snapshot.data!["Good"].values
                                    .toList()
                                    .length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        crossAxisCount: 2),
                                itemBuilder: (context, index) {
                                  final goodTask = snapshot
                                      .data!["Good"]["${index}"].keys
                                      .toList()[0];
                                  return SizedBox(
                                      height: 44,
                                      width: 44,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color.fromARGB(
                                                          255, 23, 23, 23))),
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                      child: SizedBox(
                                                          height: 100,
                                                          width: 200,
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(goodTask),
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () async {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      int?
                                                                          nToday;
                                                                      int?
                                                                          nTotal;
                                                                      final datas = await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'user')
                                                                          .doc(
                                                                              _userID)
                                                                          .collection(
                                                                              "improve")
                                                                          .doc(
                                                                              "1");
                                                                      final dataReadOkay =
                                                                          await datas
                                                                              .get();
                                                                      try {
                                                                        if (dataReadOkay['DateGood'].containsKey("${DateTime.now().toIso8601String().split("T")[0]}") ==
                                                                                true &&
                                                                            dataReadOkay['Good.${index}.${snapshot.data!["Good"]["${index}"].keys.toList()[0]}'].containsKey("${DateTime.now().toIso8601String().split("T")[0]}") ==
                                                                                true) {
                                                                          todayGood =
                                                                              dataReadOkay['DateGood.${DateTime.now().toIso8601String().split("T")[0]}'];
                                                                          goodTotal =
                                                                              dataReadOkay["GoodTotal"];
                                                                          nTotal =
                                                                              dataReadOkay['Good.${index}.${snapshot.data!["Good"]["${index}"].keys.toList()[0]}.Total'];
                                                                          nToday =
                                                                              dataReadOkay['Good.${index}.${snapshot.data!["Good"]["${index}"].keys.toList()[0]}.${DateTime.now().toIso8601String().split("T")[0]}'];
                                                                          await datas
                                                                              .update({
                                                                            'DateGood.${DateTime.now().toIso8601String().split("T")[0]}':
                                                                                todayGood! + 1,
                                                                            'GoodTotal':
                                                                                goodTotal! + 1,
                                                                            'Good.${index}.${snapshot.data!["Good"]["${index}"].keys.toList()[0]}.Total':
                                                                                nTotal! + 1,
                                                                            'Good.${index}.${snapshot.data!["Good"]["${index}"].keys.toList()[0]}.${DateTime.now().toIso8601String().split("T")[0]}':
                                                                                nToday! + 1
                                                                          });
                                                                        } else if (dataReadOkay['DateGood'].containsKey("${DateTime.now().toIso8601String().split("T")[0]}") ==
                                                                                true &&
                                                                            dataReadOkay['Good.${index}.${snapshot.data!["Good"]["${index}"].keys.toList()[0]}'].containsKey("${DateTime.now().toIso8601String().split("T")[0]}") ==
                                                                                false) {
                                                                          todayGood =
                                                                              dataReadOkay['DateGood.${DateTime.now().toIso8601String().split("T")[0]}'];
                                                                          goodTotal =
                                                                              dataReadOkay["GoodTotal"];
                                                                          nTotal =
                                                                              dataReadOkay['Good.${index}.${snapshot.data!["Good"]["${index}"].keys.toList()[0]}.Total'];
                                                                          await datas
                                                                              .update({
                                                                            'DateGood.${DateTime.now().toIso8601String().split("T")[0]}':
                                                                                todayGood! + 1,
                                                                            'GoodTotal':
                                                                                goodTotal! + 1,
                                                                            'Good.${index}.${snapshot.data!["Good"]["${index}"].keys.toList()[0]}.Total':
                                                                                nTotal! + 1,
                                                                            'Good.${index}.${snapshot.data!["Good"]["${index}"].keys.toList()[0]}.${DateTime.now().toIso8601String().split("T")[0]}':
                                                                                1
                                                                          });
                                                                        } else if (dataReadOkay['DateGood'].containsKey("${DateTime.now().toIso8601String().split("T")[0]}") ==
                                                                                false &&
                                                                            dataReadOkay['Good.${index}.${snapshot.data!["Good"]["${index}"].keys.toList()[0]}'].containsKey("${DateTime.now().toIso8601String().split("T")[0]}") ==
                                                                                false) {
                                                                          goodTotal =
                                                                              dataReadOkay["GoodTotal"];
                                                                          nTotal =
                                                                              dataReadOkay['Good.${index}.${snapshot.data!["Good"]["${index}"].keys.toList()[0]}.Total'];
                                                                          await datas
                                                                              .update({
                                                                            'DateGood.${DateTime.now().toIso8601String().split("T")[0]}':
                                                                                1,
                                                                            'GoodTotal':
                                                                                goodTotal! + 1,
                                                                            'Good.${index}.${snapshot.data!["Good"]["${index}"].keys.toList()[0]}.Total':
                                                                                nTotal! + 1,
                                                                            'Good.${index}.${snapshot.data!["Good"]["${index}"].keys.toList()[0]}.${DateTime.now().toIso8601String().split("T")[0]}':
                                                                                1
                                                                          });
                                                                        }
                                                                      } catch (e) {}
                                                                    },
                                                                    child: Text(
                                                                        "Confirm"))
                                                              ])));
                                                });
                                          },
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    snapshot.data!["Good"]
                                                            ["${index}"][
                                                            "${snapshot.data!["Good"]["${index}"].keys.toList()[0]}"]
                                                            [
                                                            "${DateTime.now().toIso8601String().split("T")[0]}"]
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 26)),
                                                Text(
                                                    snapshot.data!["Good"]
                                                            ["${index}"][
                                                            "${snapshot.data!["Good"]["${index}"].keys.toList()[0]}"]
                                                            ["Total"]
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 26)),
                                                Text(goodTask,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 36, 214, 0),
                                                        fontSize: 16))
                                              ])));
                                }))
                      ]))
                ])),
          ]));
        }
        return Text("Www");
      },
    );
  }
}

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                    child: SizedBox(
                        height: 200,
                        width: 300,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Text"),
                              TextField(controller: controller),
                              ElevatedButton(
                                  onPressed: () async {
                                    final userDocuments =
                                        await FirebaseFirestore.instance
                                            .collection("user")
                                            .doc(_userID)
                                            .collection("improve")
                                            .doc("1")
                                            .get();
                                    if (controllers.page == 0) {
                                      await FirebaseFirestore.instance
                                          .collection("user")
                                          .doc(_userID)
                                          .collection("improve")
                                          .doc("1")
                                          .update({
                                        'Bad.${userDocuments["Bad"].length}.${controller.text}.${DateTime.now().toIso8601String().split("T")[0]}':
                                            0,
                                        'Bad.${userDocuments["Bad"].length}.${controller.text}.Total':
                                            0
                                      });
                                    }
                                    if (controllers.page == 1) {
                                      await FirebaseFirestore.instance
                                          .collection("user")
                                          .doc(_userID)
                                          .collection("improve")
                                          .doc("1")
                                          .update({
                                        'Good.${userDocuments["Good"].length}.${controller.text}.${DateTime.now().toIso8601String().split("T")[0]}':
                                            0,
                                        'Good.${userDocuments["Good"].length}.${controller.text}.Total':
                                            0
                                      });
                                    }
                                    setState(() {
                                      controller.text = "";
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Ok"))
                            ])));
              });
        },
        child: Icon(Icons.add, size: 36));
  }
}

class PageNow extends StatelessWidget {
  const PageNow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Bad",
          style: TextStyle(
              color: controllers.page == 0
                  ? Color.fromARGB(255, 0, 90, 180)
                  : Color.fromARGB(255, 1, 2, 3))),
      Text("Good",
          style: TextStyle(
              color: controllers.page == 0
                  ? Color.fromARGB(255, 0, 90, 180)
                  : Color.fromARGB(255, 1, 2, 3))),
    ]);
  }
}

int? todayBad;
int? todayGood;
int? goodTotal;
int? badTotal;
