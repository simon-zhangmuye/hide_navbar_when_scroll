import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isNavbarVisible = true; // Initially, the navbar is visible

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // Hide navbar when ListView is scrolling
    if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse ||
        _scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
      if (_isNavbarVisible) {
        setState(() {
          _isNavbarVisible = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Floating Navbar on Scroll'),
      ),
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              // Show navbar when user stops scrolling
              if (notification is UserScrollNotification &&
                  notification.direction == ScrollDirection.idle) {
                if (!_isNavbarVisible) {
                  setState(() {
                    _isNavbarVisible = true;
                  });
                }
              }
              return true;
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 100,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text("Item $index"),
                );
              },
            ),
          ),
          Positioned(
            bottom: 10, // Adjust space from bottom
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _isNavbarVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: Container(
                // This container represents the floating navbar
                color: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.event),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.person),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}
