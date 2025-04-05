import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
/* driver func */
void main() => runApp(MyApp());
/* driver class */
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
					title: Text('March 2025'),
					actions: <Widget>[
						IconButton(icon: Icon(Icons.undo), onPressed: () {}),
						IconButton(icon: Icon(Icons.redo), onPressed: () {}),
						OutlinedButton(child: Text("Lưu"), onPressed: () {})
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

class Event {
	DateTime startTime;
	Duration duration;

	DateTime getStartTime() => startTime;

	DateTime getEndTime() {
		return startTime.add(duration);
	}
}
