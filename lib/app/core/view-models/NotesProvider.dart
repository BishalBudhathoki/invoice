import 'package:flutter/cupertino.dart';

class NotesProvider extends ChangeNotifier {
  String _notes = '';

  String get notes => _notes;

  updateNotes(text) {
    _notes += text;
    notifyListeners();
  }
}
