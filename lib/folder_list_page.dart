import 'package:documentale_flutter/folder_details_page.dart';
import 'package:documentale_flutter/main%20copy%202.dart';
import 'package:documentale_flutter/main.dart';
import 'package:documentale_flutter/nav_drawer.dart';
import 'package:documentale_flutter/simple_text_field.dart';
import 'package:flutter/material.dart';

import 'calendar_page.dart';
import 'home_page.dart';

class FolderListPage extends StatefulWidget {
  const FolderListPage({super.key});

  @override
  _FolderListPage createState() => _FolderListPage();
}

class _FolderListPage extends State<FolderListPage> {
  List<Folder> itemsFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';
  DateTime selectedDate = DateTime.now();

  /*final RestorableDateTimeN _startDate = RestorableDateTimeN(DateTime(2021));
  final RestorableDateTimeN _endDate =
      RestorableDateTimeN(DateTime(2021, 1, 5));
  late final RestorableRouteFuture<DateTimeRange?>
      _restorableDateRangePickerRouteFuture =
      RestorableRouteFuture<DateTimeRange?>(
    onComplete: _selectDateRange,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator
          .restorablePush(_dateRangePickerRoute, arguments: <String, dynamic>{
        'initialStartDate': _startDate.value?.millisecondsSinceEpoch,
        'initialEndDate': _endDate.value?.millisecondsSinceEpoch,
      });
    },
  );

  void _selectDateRange(DateTimeRange? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _startDate.value = newSelectedDate.start;
        _endDate.value = newSelectedDate.end;
      });
    }
  }

  static Route<DateTimeRange?> _dateRangePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTimeRange?>(
      context: context,
      builder: (BuildContext context) {
        return DateRangePickerDialog(
          restorationId: 'date_picker_dialog',
          initialDateRange:
              _initialDateTimeRange(arguments! as Map<dynamic, dynamic>),
          firstDate: DateTime(2021),
          currentDate: DateTime(2021, 1, 25),
          lastDate: DateTime(2022),
        );
      },
    );
  }

  static DateTimeRange? _initialDateTimeRange(Map<dynamic, dynamic> arguments) {
    if (arguments['initialStartDate'] != null &&
        arguments['initialEndDate'] != null) {
      return DateTimeRange(
        start: DateTime.fromMillisecondsSinceEpoch(
            arguments['initialStartDate'] as int),
        end: DateTime.fromMillisecondsSinceEpoch(
            arguments['initialEndDate'] as int),
      );
    }
    return null;
  }*/

  @override
  void initState() {
    super.initState();
    itemsFiltered = items;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(11, 81, 187, 1),
          title: const Text('Lista Fascicoli'),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.calendar_month),
                tooltip: 'Seleziona periodo',
                onPressed: () => _selectDate(context)
                //_restorableDateRangePickerRouteFuture.present(),
                ),
          ],
        ),
        drawer: const NavDrawer(),
        body: ListView(children: <Widget>[
          Center(
            child: SimpleTextField(
              onChanged: (value) {
                setState(() {
                  _searchResult = value;
                  itemsFiltered = items
                      .where((item) =>
                          item.type.contains(_searchResult) ||
                          item.date.contains(_searchResult) ||
                          item.user.contains(_searchResult))
                      .toList();
                });
              },
              prefixIconData: Icons.search,
              hintText: 'Cerca',
              fillColor: Colors.white,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
            ),
          ),
          DataTable(
            showCheckboxColumn: false,
            columns: const [
              DataColumn(
                  label: Text('Tipologia',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Data',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Utente',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold))),
            ],
            rows: List.generate(
              itemsFiltered.length,
              (index) => DataRow(
                cells: [
                  DataCell(
                    Text(
                      itemsFiltered[index].type,
                      style: const TextStyle(
                          //decoration: TextDecoration.underline,
                          //decorationColor: Colors.green,
                          color: Color.fromRGBO(11, 81, 187, 1)),
                    ),
                    showEditIcon: false,
                    placeholder: false,
                    onTap: () {
                      _openFolderDetails();
                    },
                  ),
                  DataCell(
                    Text(itemsFiltered[index].date),
                    showEditIcon: false,
                    placeholder: false,
                  ),
                  DataCell(
                    Text(itemsFiltered[index].user),
                    showEditIcon: false,
                    placeholder: false,
                  ),
                ],
              ),
            ).toList(),
          ),
        ]),
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
          currentIndex: 2,
          //selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      Widget route = widget;
      switch (index) {
        case 0:
          route = const HomePage();
          break;
        case 1:
          // route = const CalendarPage();
          break;
        case 2:
          route = const FolderListPage();
          break;
        default:
      }
      if (index != 2) {
        Navigator.of(context).pushReplacement(_createRoute(route));
      }
    });
  }

  void _openFolderDetails() {
    Navigator.of(context).push(_createRoute(const FolderDetailsPage()));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                  primary: Color.fromRGBO(11, 81, 187, 1)),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}

class Folder {
  String type;
  String date;
  String time;
  String user;
  String description;

  Folder({
    required this.type,
    required this.date,
    required this.time,
    required this.user,
    required this.description,
  });
}

var items = <Folder>[
  Folder(
    type: 'Scontrino',
    date: '30/01/2023',
    time: '10:35',
    user: 'Agostino',
    description: 'Fascicolo numero 1',
  ),
  Folder(
    type: 'Contratto',
    date: '15/01/2023',
    time: '10:35',
    user: 'Agostino',
    description: 'Fascicolo numero 1',
  ),
  Folder(
    type: 'Fattura',
    date: '18/01/2023',
    time: '10:35',
    user: 'Agostino',
    description: 'Fascicolo numero 1',
  ),
  Folder(
    type: 'Generico',
    date: '12/01/2023',
    time: '10:35',
    user: 'Agostino',
    description: 'Fascicolo numero 1',
  ),
  Folder(
    type: 'Generico',
    date: '28/12/2022',
    time: '10:35',
    user: 'Agostino',
    description: 'Fascicolo numero 1',
  ),
  Folder(
    type: 'Contratto',
    date: '29/12/2022',
    time: '10:35',
    user: 'Agostino',
    description: 'Fascicolo numero 1',
  ),
];

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
