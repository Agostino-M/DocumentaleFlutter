import 'package:documentale_flutter/calendar_page.dart';
import 'package:documentale_flutter/folder_list_page.dart';
import 'package:documentale_flutter/nav_drawer.dart';
import 'package:documentale_flutter/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import 'folder_details_page.dart';

const List<String> list = <String>[
  '-- Tipologia --',
  'Scontrino',
  'Fattura',
  'Biglietto da visita',
  'Contratto',
  'Generico'
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String dropdownValue = list.first;
  bool textScanning = false;
  XFile? imageFile;
  String scannedText = '';
  TextEditingController descrizioneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(11, 81, 187, 1),
            title: const Text('Nuovo Fascicolo'),
          ),
          drawer: const NavDrawer(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64),
            child: Center(
              child: Column(
                children: intersperse(
                  const SizedBox(
                    height: 32,
                  ),
                  [
                    DropdownButtonFormField<String>(
                      //TODO aprirlo sempre in basso
                      value: dropdownValue,
                      hint: const Text('Tipologia'),
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    ),
                    SimpleTextField(
                      textEditingController: descrizioneController,
                      hintText: "Descrizione",
                      labelText: "Descrizione",
                      minLines: 1,
                      maxLines: 25,
                      textInputType: TextInputType.multiline,
                      onChanged: (text) {
                        setState(() {});
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.cloud_upload),
                      onPressed: () {
                        getImage(ImageSource
                            .gallery); //Navigator.of(context).pushReplacement(_createRoute());
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                        minimumSize:
                            MaterialStateProperty.all(const Size(150, 45)),
                        maximumSize:
                            MaterialStateProperty.all(const Size(400, 50)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                        textStyle: MaterialStateProperty.all(
                          const TextStyle(fontSize: 18),
                        ),
                      ),
                      label: const Text('Primo File'),
                    ),
                  ],
                ).toList(),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: const Color.fromRGBO(11, 81, 187, 1),
            unselectedItemColor: const Color.fromRGBO(11, 81, 187, 1),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.cloud_upload),
                label: 'Acquisisci',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Calendario',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Lista',
              ),
            ],
            currentIndex: 0,
            //selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
        ),
        //Visibility(
        //visible: isLoading,
        //child: const LoadingSpinner(),
        //),
      ],
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    await textRecognizer.close();
    scannedText = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = "$scannedText${line.text}\n";
      }
    }
    textScanning = false;

    descrizioneController.text = descrizioneController.text +
        (descrizioneController.text.isNotEmpty
            ? "\n$scannedText"
            : scannedText);

    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      Widget route = widget;
      switch (index) {
        case 0:
          route = const HomePage();
          break;
        case 1:
          //route = const CalendarPage();
          break;
        case 2:
          route = const FolderListPage();
          break;
        default:
      }
      if (index != 0) {
        Navigator.of(context).pushReplacement(_createRoute(route));
      }
    });
  }
}

Route _createRoute(Widget route) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => route,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
