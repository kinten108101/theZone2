import 'package:flutter/material.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext ctx) {
		return MaterialApp(
			theme: ThemeData(useMaterial3: true),
			home: Scaffold(
				appBar: AppBar(
					title: Text('Helo!'),
					actions: <Widget>[
						IconButton(
							icon: Icon(Icons.undo),
							onPressed: () {},
						),
						IconButton(
							icon: Icon(Icons.redo),
							onPressed: () {},
						),
						OutlinedButton(
							child: Text("Lưu"),
							onPressed: () {},
						)
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
			bottomNavigationBar:
				NavigationBar(
					onDestinationSelected:
						(int selected) {
							setState(() {
								currentPage = selected;
							});
						},
					indicatorColor: Colors.amber,
					selectedIndex: currentPage,
					destinations:
						const <Widget>[
							NavigationDestination(selectedIcon: Icon(Icons.home), icon: Icon(Icons.home_outlined), label: "Chủ đề"),
							NavigationDestination(icon: Icon(Icons.messenger_sharp), label: "Âm thanh"),
							NavigationDestination(icon: Icon(Icons.messenger_sharp), label: "Clip"),
							NavigationDestination(icon: Icon(Icons.messenger_sharp), label: "Hiệu ứng"),
							NavigationDestination(icon: Icon(Icons.messenger_sharp), label: "Màu sắc"),
						],
				),
				body:
					Card(
						shadowColor: Colors.transparent,
						margin: const EdgeInsets.all(8.0),
						child: SizedBox.expand(
							child: Center(child: Text('Home page', style: theme.textTheme.titleLarge)),
						),
					),
		);
	}
}
