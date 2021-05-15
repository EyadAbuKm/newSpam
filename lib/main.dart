import 'package:flutter/material.dart';
import 'models/dart_decision_tree.dart';
import 'models/logistic.dart';
import 'text_processing/spam_classifier.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Widget> _children;
  SpamClassifier _classifier;
  TextEditingController _controller;

  var dtcList, logistList;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _classifier = SpamClassifier();
    _children = [];
    _children.add(Container());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: const Text('Spam Classification'),
        ),
        body: Container(
          width: 400,
          padding: const EdgeInsets.all(4),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                itemCount: _children.length,
                itemBuilder: (_, index) {
                  return _children[index];
                },
              )),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.orangeAccent)),
                child: Row(children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                          hintText: 'Write some text here'),
                      controller: _controller,
                    ),
                  ),
                  TextButton(
                    child: const Text('Classify'),
                    onPressed: () {
                      final text = _controller.text;

                      final prediction = _classifier.tokenizeInputText(text);

                      var y = LogisticRegression.score(prediction);
                      double logistList = double.tryParse(
                          '0.' + y.toString().split('.')[1].substring(0, 2));

                      print('logistic' + logistList.toString());

                      dtcList = DartDecisionTree.score(prediction);
                      print("dct  :" + dtcList.toString());

                      setState(() {
                        _children.add(Dismissible(
                          key: GlobalKey(),
                          onDismissed: (direction) {},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Card(
                                child: Container(
                                  width: 400,
                                  padding: const EdgeInsets.all(16),
                                  color: Colors.blue[200],
                                  child: Text(
                                    "Input: $text",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Card(
                                child: Container(
                                  width: 400,
                                  padding: const EdgeInsets.all(16),
                                  // color: prediction[0] >= 0.5
                                  //     ? Colors.lightGreen
                                  //     : Colors.redAccent,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      modelResult1(
                                          'Logistic Regression', logistList),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      modelResult('Decision Tree', dtcList),
                                      SizedBox(
                                        height: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ));
                        _controller.clear();
                      });
                    },
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget modelResult(String name, List<double> value) {
    return Container(
      width: 300,
      // padding: const EdgeInsets.all(16),
      child: Card(
        color: value[0] >= 0.5 ? Colors.lightGreen : Colors.redAccent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            value[0] <= 0.5
                ? Text("   Spam: ${value[1]}")
                : Text("   Ham: ${value[0]}"),
          ],
        ),
      ),
    );
  }

  Widget modelResult1(String name, var value) {
    return Container(
      width: 300,
      // padding: const EdgeInsets.all(16),
      child: Card(
        color: value >= 0.5 ? Colors.lightGreen : Colors.redAccent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("   Spam: ${1 - value}"),
            Text("   Ham: ${value}"),
          ],
        ),
      ),
    );
  }
}
// flutter run --no-sound-null-safety
