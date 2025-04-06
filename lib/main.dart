import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:convert';

final SERVER = "10.130.101.252:8089";

void main() => runApp(MyApp());

Future<http.Response> fetchAlbum() {
  return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
}

Future<http.Response> fetchZoneEventRead() {
  return http.get(Uri.parse('http://${SERVER}/event/read'));
}

Future<http.Response> fetchZoneEventCreate() {
  return http.get(Uri.parse('http://${SERVER}/event/read'));
}

class Event {
	string startTimeStr = ""
}

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext ctx) {
		return MaterialApp(
			theme: ThemeData(
				useMaterial3: true,
				colorScheme: ColorScheme.fromSeed(
					seedColor: Colors.lime,
					// ···
					brightness: Brightness.light,
    ),
			),
			home: Scaffold(
				drawer: Drawer(
					child: Text("Test")
				),
				appBar: AppBar(
					leading: Builder(
						builder: (context) =>
							IconButton(icon: Icon(Icons.menu), onPressed: () {
								Scaffold.of(context).openDrawer();
							}),
					),
					title: Text('April 2025'),
					actions: <Widget>[
						IconButton(icon: Icon(Icons.undo), onPressed: () {}),
						IconButton(icon: Icon(Icons.redo), onPressed: () {}),
						OutlinedButton(child: Text("Lưu"), onPressed: () {
							fetchZone().then((response) {
								final a = jsonDecode(response.body);
								print(a["events"]);
							});
						})
					],
				),
				body: Page(),
			),
		);
	}
}

class Page extends StatefulWidget {
	@override
	State<Page> createState() => PageState();
}

class PageState extends State<Page> {
	int currentPage = 0;
	Widget build(BuildContext context) {
		ThemeData theme = Theme.of(context);
		return Scaffold(
				body: SfCalendar(
					view: CalendarView.month
				)
		);
	}
}

