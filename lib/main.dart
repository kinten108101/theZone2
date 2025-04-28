// @dart = 3.0
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter/foundation.dart';

void main() => runApp(
	MultiProvider(
		providers: [
			ChangeNotifierProvider(create: (context) => EventModel()),
			ChangeNotifierProvider(create: (context) => NavigationModel()),
		],
		child: MyApp(),
	),
);

class TheZoneEngine {
	static final SERVER = "https://zone-engine-v2-2326111669.asia-southeast1.run.app";

	static Future<List<Event>> getEventsMock() {
		final uri = Uri.parse('${SERVER}/mock');
		return
			http.get(uri)
				.then((response) {
					final schedulesRaw = jsonDecode(response.body);
					final List<Event> newEvents = <Event>[];
					for (final scheduleRaw in schedulesRaw) {
						for (final eventRaw in scheduleRaw["events"]) {
							try {
								final event = Event.fromMap(eventRaw);
								newEvents.add(event);
							} on FormatException catch (e) {
								print("oopsie $e");
							}
						}
					}
					return newEvents;
				});
	}
}

class Event {
	DateTime? startTime;
	DateTime? endTime;
	String? title;

	Event(
		this.startTime,
		this.endTime,
		this.title
	);
	
	static String from12to24(String s) {
		String third = s.split(" ")[1];
		var u = s.split(" ")[0].split(":");
		String first = u[0];
		String second = u[1];
		if (third == "PM") {
			first = (int.parse(first) + 12).toString();
		}
		return "$first:$second";
	}

	static Event fromMap(Map<String, dynamic> eventRaw) {
		final startTime = DateTime.parse("${eventRaw["date"]} ${Event.from12to24(eventRaw["start_time"])}:00Z");
		final endTime   = DateTime.parse("${eventRaw["date"]} ${Event.from12to24(eventRaw["end_time"])}:00Z");
		final title     = eventRaw["title"];
		return
			Event(
				startTime,
				endTime,
				title
			);
	}
}

class EventModel extends ChangeNotifier {
	final List<Event> _data = [];

	List<Event> get events => this._data;

	void fill(List<Event> newEvents) {
		this._data.clear();
		this._data.addAll(newEvents);
		this.notifyListeners();
	}
}

class NavigationModel extends ChangeNotifier {
	String _currentName = "home";

	String get currentName => this._currentName;

	void setCurrentPage(String name) {
		if (name == this._currentName) return;
		this._currentName = name;
		this.notifyListeners();
	}
}

class EventDataSource extends CalendarDataSource {
	EventDataSource(List<Event> source) {
		this.appointments = source;
	}
	
	@override
	DateTime getStartTime(int index) {
		return this.appointments![index].startTime!;
	}

	@override
	DateTime getEndTime(int index) {
		return this.appointments![index].endTime!;
	}

	@override
	String getSubject(int index) {
		return this.appointments![index].title!;
	}

	@override
	Color getColor(int index) {
		return Colors.blue[400]!;
	}

	@override
	bool isAllDay(int index) {
		return false;
	}
}

class MyApp extends StatelessWidget {
	void onLoad(eventModel) {
		TheZoneEngine.getEventsMock()
			.then((newEvents) {
				eventModel.fill(newEvents);
			});
	}

	@override
	Widget build(BuildContext ctx) {
		return MaterialApp(
			theme: ThemeData(
				useMaterial3: true,
				colorScheme: ColorScheme.fromSeed(
					seedColor: Colors.lime,
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
					title: Text('The Zone'),
					actions: <Widget>[
						Consumer<EventModel>(
							builder: (context, eventModel, child) =>
								OutlinedButton(
									child: Text("Load"),
									onPressed: () {
										onLoad(eventModel);
									},
								),
						),
					],
				),
				body: Consumer<NavigationModel>(
					builder: (context, model, child) {
						final name = model.currentName;
						final widget = switch (name) {
							"home" => Page(),
							"add"  => AddPage(),
							"event" => EventPage(),
							_      => throw Exception("wtf"),
						};
						return widget;
					},
				),
			),
		);
	}
}

class Page extends StatefulWidget {
	@override
	State<Page> createState() => PageState();
}

class PageState extends State<Page> {
	Widget build(BuildContext context) {
		ThemeData theme = Theme.of(context);
		return Scaffold(
			body:
				Consumer<EventModel>(
					builder: (context, eventModel, child) =>
						SfCalendar(
							view: CalendarView.month,
							dataSource: EventDataSource(eventModel.events),
							monthViewSettings: MonthViewSettings(
								showAgenda: true,
								appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
							),
						),
				),
			floatingActionButton:
				Consumer<NavigationModel>(
					builder: (context, model, child) =>
						FloatingActionButton(
							onPressed: () {
								model.setCurrentPage("add");
							},
							child: Icon(Icons.add),
						),
				),
		);
	}
}

class AddPage extends StatefulWidget {
	@override
	State<AddPage> createState() => AddPageState();
}

class AddPageState extends State<AddPage> {
	Widget build(BuildContext context) {
		return Scaffold(
			body: LayoutGrid(
				areas: """
					switchlabel switch
				""",
				columnSizes: [1.fr, 64.px],
				rowSizes: [64.px],
				children: [
					Text(
						"All-day",
						textAlign: TextAlign.center,
					)
						.inGridArea("switchlabel"),
					Switch(
						value: true,
						onChanged: (bool value){},
					)
						.inGridArea("switch")
				],
			),
		);
	}
}

class EventPage extends StatefulWidget {
	State<EventPage> createState() => EventPageState();
}

class EventPageState extends State<EventPage> {
	Widget build(BuildContext context) {
		return Scaffold(
		);
	}
}
