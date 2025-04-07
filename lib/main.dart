import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:provider/provider.dart';


void main() => runApp(
	MultiProvider(
		providers: [
			ChangeNotifierProvider(create: (context) => EventModel()),
		],
		child: MyApp(),
	),
);

class TheZoneEngine {
	static final SERVER = "https://thezoneengine.onrender.com";

	static Future<List<Event>> getEventsMock() {
		final uri = Uri.parse('${SERVER}/event?day=2025-10-10');
		return
			http.get(uri)
				.then((response) {
					final scheduleRaw = jsonDecode(response.body);
					final List<Event> newEvents = <Event>[];
					for (final eventRaw in scheduleRaw["events"]) {
						final event = Event.fromMap(eventRaw);
						newEvents.add(event);
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

	static Event fromMap(Map<String, dynamic> eventRaw) {
		final startTime = DateTime.parse("${eventRaw["date"]} ${eventRaw["start_time"]}Z");
		final endTime   = DateTime.parse("${eventRaw["date"]} ${eventRaw["end_time"]}Z");
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
				FloatingActionButton(
					onPressed: () {},
					child: Icon(Icons.add),
				),
		);
	}
}

class AddPage extends StatefulWidget {
	@override
	State<Page> createState() => AddPageState();
}

class AddPageState extends State<AddPage> {
}
