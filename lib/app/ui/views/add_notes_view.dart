// create a UI to add notes with a button to save the notes, editable text view to edit notes and a button with a mic icon

import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/ui/widgets/button_widget.dart';
import 'package:MoreThanInvoice/app/ui/widgets/flushbar_widget.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';
import 'package:MoreThanInvoice/backend/shared_preferences_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'client_and_appointment_details_view.dart';

class AddNotesView extends StatefulWidget {
  final String userEmail;
  final String clientEmail;
  const AddNotesView(
      {super.key, required this.userEmail, required this.clientEmail});

  @override
  _AddNotesViewState createState() => _AddNotesViewState();
}

class _AddNotesViewState extends State<AddNotesView> {
  late final TextEditingController _notesController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FlushBarWidget flushBarWidget = FlushBarWidget();
  ApiMethod apiMethod = ApiMethod();

  late stt.SpeechToText _speechToText;
  bool _speechEnabled = false;
  final prefs = SharedPreferences.getInstance();
  String notes = '';
  String accumulatedText = '';

  _onFinalResult(text) {
    setState(() {
      notes += text;
    });
  }

  @override
  void initState() {
    super.initState();
    //loadNotes();
    _speechToText = stt.SpeechToText();
    _initSpeechToText();
    _notesController.addListener(() {
      setState(() {});
    });
  }

  void _initSpeechToText() async {
    bool isAvailable = await _speechToText.initialize();
    if (isAvailable) {
      setState(() {
        _speechEnabled = true;
      });
    }
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _toggleSpeech() {
    if (!_speechToText.isListening) {
      _speechToText.listen(onResult: _onSpeechResult);
    } else {
      accumulatedText = '';
      _speechToText.stop();
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (result.finalResult) {
      setState(() {
        accumulatedText += '${result.recognizedWords} ';
      });

      _notesController.text = accumulatedText;
      print('note controller: ${_notesController.text}');
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // key for flushbar
      appBar: AppBar(
        title: const Text(
          'Add Notes',
          style: TextStyle(
            color: AppColors.colorBlack,
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: AppColors.colorWhite,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.colorBlack,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.colorWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.colorPrimary,
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  child: TextField(
                    maxLines: null,
                    controller: _notesController,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Add notes',
                      hintStyle: TextStyle(
                        color: AppColors.colorGrey,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ButtonWidget(
              title: 'Save',
              hasBorder: false,
              onPressed: () async {
                print(_notesController.text);
                final response = await apiMethod.uploadNotes(widget.userEmail,
                    widget.clientEmail, _notesController.text);

                flushBarWidget
                    .flushBar(
                      title: response.title,
                      message: response.message,
                      backgroundColor: response.backgroundColor,
                      context: _scaffoldKey.currentContext!,
                    )
                    .show(_scaffoldKey.currentContext!);
                print(Navigator.of(_scaffoldKey.currentContext!).widget);

                pushNewScreenWithRouteSettings(
                  _scaffoldKey.currentContext!,
                  settings: RouteSettings(
                    name: '/home/ClientAndAppointmentDetails',
                    arguments: {
                      'userEmail': widget.userEmail,
                      'clientEmail': widget.clientEmail,
                    },
                  ),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  screen: ClientAndAppointmentDetails(
                      userEmail: widget.userEmail,
                      clientEmail: widget.clientEmail),
                );
              },
            ),
            // button with mic icon
            const SizedBox(
              height: 20.0,
            ),
            Text(
              _speechToText.isListening
                  ? accumulatedText
                  : _speechEnabled
                      ? 'Tap to start listening...'
                      : 'Speech not available',
            ),
            SizedBox(
              width: double.infinity,
              height: 60.0,
              child: ElevatedButton(
                onPressed: () async {
                  await microphonePermission();
                  _toggleSpeech();
                  // _speechToText.isNotListening
                  //     ? _startListening
                  //     : _stopListening;
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    AppColors.colorPrimary,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: Icon(
                  _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
                  color: AppColors.colorWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> microphonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isGranted) {
      return true;
    } else {
      status = await Permission.microphone.request();
      return status.isGranted;
    }
  }
}
