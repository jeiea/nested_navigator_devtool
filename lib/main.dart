import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Nested navigator',
    home: ForwardNavigator(
      initialRoute: '/home',
      onGenerateRoute: generateRoute,
    ),
  ));
}

class ForwardNavigator extends StatefulWidget {
  ForwardNavigator(
      {Key key,
      this.initialRoute,
      this.onGenerateRoute,
      this.onPopPage,
      this.pages = const <Page<dynamic>>[]})
      : super(key: key);

  final String initialRoute;
  final RouteFactory onGenerateRoute;
  final PopPageCallback onPopPage;
  final List<Page<dynamic>> pages;
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  _ForwardNavigatorState createState() => _ForwardNavigatorState();
}

class _ForwardNavigatorState extends State<ForwardNavigator> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (widget.navigatorKey.currentState.canPop()) {
            widget.navigatorKey.currentState.pop();
            return false;
          }
          return true;
        },
        child: Navigator(
          key: widget.navigatorKey,
          initialRoute: widget.initialRoute,
          onGenerateRoute: widget.onGenerateRoute,
          onPopPage: widget.onPopPage,
          pages: widget.pages,
        ));
  }
}

Route generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/list':
      return _noTransitionRoute(() => Page2());
    case '/home':
    default:
      return _noTransitionRoute(() => Page1());
  }
}

PageRoute _noTransitionRoute(Widget Function() builder) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => builder(),
    transitionDuration: Duration(seconds: 0),
  );
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabNavigation(
        tabIndex: 0, body: Container(child: Center(child: Text('page 1'))));
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabNavigation(
        tabIndex: 1, body: Container(child: Center(child: Text('page 2'))));
  }
}

class TabNavigation extends StatelessWidget {
  TabNavigation({@required this.tabIndex, this.body});

  final Widget body;

  final int tabIndex;

  void _changeTab(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/list');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
            return false;
          }
          return true;
        },
        child: Scaffold(
            appBar: AppBar(),
            body: this.body,
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: (index) => _changeTab(context, index),
              currentIndex: tabIndex,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
              ],
            )));
  }
}
