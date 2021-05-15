import 'package:flutter/services.dart';

class SpamClassifier {
  final _vocabFile = 'count_dict_new.txt';

  // Maximum length of sentence
  final int _sentenceLen = 5000;

  Map<String, int> _dict;
  var reversed;

  SpamClassifier() {
    _loadDictionary();
  }

  void _loadDictionary() async {
    final vocab = await rootBundle.loadString('assets/$_vocabFile');
    var dict = <String, int>{};
    final vocabList = vocab.split('\n');
    for (var i = 0; i < 5000; i++) {
      var entry = vocabList[i].trim().split(' ');
      dict[entry[0]] = int.parse(entry[1]);
    }
    reversed = dict.map((k, v) => MapEntry(v, k));

    _dict = dict;
    print('Dictionary loaded successfully');
  }

  List<double> tokenizeInputText(String text) {
    // Whitespace tokenization
    final toks = text.split(' ');
    print('hello from toks');
    print(toks);

    // Create a list of length==_sentenceLen filled with the value <pad>
    var vec = List<double>.filled(_sentenceLen, 0);
    var index = 0;

    // For each word in sentence find corresponding index in dict
    for (var tok in toks) {
      if (index > _sentenceLen) {
        break;
      }

      if (_dict.containsKey(tok)) {
        vec[_dict[tok]] = vec[_dict[tok]] + 1;
      }
    }
    return vec;
  }
}
