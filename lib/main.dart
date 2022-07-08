import 'package:flutter/material.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final WatchConnectivityBase _watch;
  List<Map> data = [
    {"recentCgm" : 124.6, "unit" : "mg/dl", "isConnect" : true, "iob" : 45, "cob" : 20},
    {"recentCgm" : 80, "unit" : "mg/dl", "isConnect" : true, "iob" : 99, "cob" : 0},
    {"recentCgm" : 168.2, "unit" : "mg/dl", "isConnect" : true, "iob" : 52, "cob" : 49},
    {"recentCgm" : 95, "unit" : "mg/dl", "isConnect" : true, "iob" : 19, "cob" : 37},
  ];
  var _count = 0;

  var _supported = false;
  var _paired = false;
  var _reachable = false;
  var _context = <String, dynamic>{};
  var _receivedContexts = <Map<String, dynamic>>[];
  final _log = <String>[];

  double _recentCgm = 0.0;
  String _unit = "";
  bool _isConnect = false;
  double _iob = 0.0;
  double _cob = 0.0;

  @override
  void initState() {
    super.initState();
    _watch = WatchConnectivity();
    // _watch.messageStream
    //     .listen((e) => setState(() => _log.add('Received message: $e')));

    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void initPlatformState() async {
    _supported = await _watch.isSupported;
    _paired = await _watch.isPaired;
    _reachable = await _watch.isReachable;

    setState(() {});
  }

  void _sendWidget() {
    final message = {'recentCgm': _recentCgm, 'unit' : _unit, 'isConnect' : _isConnect, 'iob' : _iob, 'cob' : _cob};
    _watch.sendMessage(message);
    setState(() => _log.add('Sent message: $message'));
  }

  Widget _widgetList(Map data) {
    void onPressed() {
      setState((){
       _recentCgm = data['recentCgm'];
       _unit = data['unit'];
       _isConnect = data['isConnect'];
       _iob = data['iob'];
       _cob = data['cob'];
      });
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            children: [
              Row(
                children: [
                  const Text("현재혈당"),
                  const SizedBox(width: 10),
                  Text('${data['recentCgm']}'),
                ],
              ),
              Row(
                children: [
                  const Text("연결 여부"),
                  const SizedBox(width: 10),
                  Text('${data['isConnect']}'),
                ],
              ),
              Row(
                children: [
                  const Text("iob(%)"),
                  const SizedBox(width: 10),
                  Text('${data['iob']}'),
                ],
              ),
              Row(
                children: [
                  const Text("cob(%)"),
                  const SizedBox(width: 10),
                  Text('${data['cob']}'),
                ],
              ),
            ],
          ),
          const SizedBox(width: 50),
          TextButton(onPressed: onPressed, child: const Text("Set Data"))
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Supported: $_supported'),
                  Text('Paired: $_paired'),
                  Text('Reachable: $_reachable'),
                  ...data.map((e) => _widgetList(e)),
                  const Divider(height: 20),
                  TextButton(onPressed: _sendWidget, child: const Text("Send Data")),
                  const Text('Log'),
                  ..._log.reversed.map((e) => Text(e)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}