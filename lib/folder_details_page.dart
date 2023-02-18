import 'package:documentale_flutter/home_page.dart';
import 'package:documentale_flutter/loading_spinner.dart';
import 'package:documentale_flutter/main.dart';
import 'package:documentale_flutter/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'calendar_page.dart';
import 'folder_list_page.dart';
import 'nav_drawer.dart';

class FolderDetailsPage extends StatefulWidget {
  const FolderDetailsPage({super.key});

  @override
  _FolderDetailsPageState createState() => _FolderDetailsPageState();
}

class _FolderDetailsPageState extends State<FolderDetailsPage> {
  TextEditingController descrizioneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool textScanning = false;
  XFile? imageFile;
  String scannedText = '';

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(11, 81, 187, 1),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Documenti",
                ),
                Tab(
                  text: "Informazioni",
                ),
              ],
            ),
            title: const Text('Fascicolo'),
          ),
          body: TabBarView(
            children: [
              docsTab,
              infoTab,
            ],
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
            //currentIndex: 1,
            //selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
        ),
      ),
    ]);
  }

  void _onItemTapped(int index) {
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
    if (route != widget) {
      Navigator.of(context).pushReplacement(_createRoute(route));
    }
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
        scannedText = scannedText + line.text + "\n";
      }
    }
    textScanning = false;

    descrizioneController.text = descrizioneController.text +
        (descrizioneController.text.isNotEmpty
            ? "\n$scannedText"
            : scannedText);

    setState(() {});
  }
}

Widget docsTab = ListView(children: <Widget>[
  Center(
    child: ElevatedButton.icon(
      icon: const Icon(Icons.cloud_upload),
      onPressed: () {
        //getImage(ImageSource
        //   .gallery); //Navigator.of(context).pushReplacement(_createRoute());
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
        minimumSize: MaterialStateProperty.all(const Size.fromHeight(50)),
        shape: MaterialStateProperty.all(const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        )),
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 18),
        ),
      ),
      label: const Text('Nuovo File'),
    ),
  ),
  Padding(
    padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
    child: Center(
      child: Column(
        children: intersperse(
          const SizedBox(
            height: 32,
          ),
          [
            const Text(
              "File 1 - 133.34 kB",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Text(
              "Autore: Agostino",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600),
            ),
            const Text(
              "Il: 30/01/2023",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600),
            ),
            const Text(
              "ERICE - TRAPANI",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.grey, boxShadow: [
                BoxShadow(
                  blurRadius: 10.0,
                  offset: Offset(0, 4),
                ),
              ]),
              child: Image.asset(
                'assets/images/main.jpeg',
              ),
            ),
            const Text(
              "Titolo: Titolo molto bello",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600),
            ),
            const Text(
              "Descrizione: ",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
                minimumSize: MaterialStateProperty.all(const Size(150, 45)),
                maximumSize: MaterialStateProperty.all(const Size(400, 50)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                )),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(fontSize: 18),
                ),
              ),
              child: const Text('Modifica'),
            )
          ],
        ).toList(),
      ),
    ),
  )
]);

Widget infoTab = Padding(
  padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
  child: Center(
    child: Column(
      children: intersperse(
        const SizedBox(
          height: 32,
        ),
        [
          DropdownButtonFormField<String>(
            //TODO aprirlo sempre in basso
            //value: dropdownValue,
            hint: const Text('Tipologia'),
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              //setState(() {
              // dropdownValue = value!;
              //}
              //);
            },
          ),
          SimpleTextField(
            //textEditingController: descrizioneController,
            hintText: "Descrizione",
            labelText: "Descrizione",
            minLines: 1,
            maxLines: 25,
            textInputType: TextInputType.multiline,
            onChanged: (text) {
              //setState(() {});
            },
          ),
          const SimpleTextField(
            hintText: "Giorno emissione",
            labelText: "Giorno emissione",
          ),
          const SimpleTextField(
            hintText: "Ora emissione",
            labelText: "Ora emissione",
          ),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
              minimumSize: MaterialStateProperty.all(const Size(150, 45)),
              maximumSize: MaterialStateProperty.all(const Size(400, 50)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )),
              textStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 18),
              ),
            ),
            child: const Text('Aggiorna'),
          )
        ],
      ).toList(),
    ),
  ),
);

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
