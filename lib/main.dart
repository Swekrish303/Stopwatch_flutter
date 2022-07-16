import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stopwatch',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'Stopwatch'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int seconds = 0;
  late Timer time;
  bool _timeOn = false;
  bool _reset = false;
  bool _stop = true;
  final _laps = <int>[];

  void _incrementCount(Timer time) {
    setState(
      () {
        ++seconds;
      },
    );
  }

  void _startFunction() {
    time = Timer.periodic(const Duration(seconds: 1), _incrementCount);
    setState(
      () {
        seconds = 0;
        _timeOn = true;
        _reset = !_reset;
        _laps.clear();
      },
    );
  }

  void _resetFunction() {
    setState(() {
      seconds = 0;
      _reset = !_reset;
      _stop = true;
    });
  }

  void _resumeFunction() {
    time = Timer.periodic(const Duration(seconds: 1), _incrementCount);
    setState(() {
      _timeOn = true;
      _stop = !_stop;
    });
  }

  void _stopFunction() {
    time.cancel();

    setState(
      () {
        _timeOn = false;
        _stop = !_stop;
      },
    );
  }

  void _lapFunction() {
    setState(
      () {
        _laps.add(seconds);
      },
    );
  }

  String _hours(seconds) {
    int hours = (seconds / 3600).toInt();
    if (hours != 0) {
      if (hours > 9) {
        return '$hours';
      } else {
        return '0$hours';
      }
    } else {
      return '00';
    }
  }

  String _minutes(seconds) {
    int minutes = (seconds / 60).toInt() - ((seconds / 3600).toInt() * 60);
    if (minutes != 0) {
      if (minutes > 9) {
        return '$minutes';
      } else {
        return '0$minutes';
      }
    } else {
      return '00';
    }
  }

  String _seconds(seconds) {
    int second = seconds -
        ((seconds / 60).toInt() * 60) -
        ((seconds / 3600).toInt() * 3600);
    if (second != 0) {
      if (second > 9) {
        return '$second';
      } else {
        return '0$second';
      }
    } else {
      return '00';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(child: _buildlaps(context)),
            Expanded(child: _lapDisplay()),
          ],
        ),
      ),
    );
  }

  Widget _buildlaps(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          '${_hours(seconds)}:${_minutes(seconds)}:${_seconds(seconds)}',
          style: Theme.of(context).textTheme.headline2,
        ),
        const SizedBox(height: 20),
        _buildButtons(),
      ],
    );
  }

  Row _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Visibility(
          visible: _reset ? false : true,
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: _timeOn ? null : _startFunction,
              child: const Text('Start')),
        ),
        Visibility(
          visible: _reset && !_stop ? true : false,
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: _timeOn ? null : _resetFunction,
              child: const Text('Reset')),
        ),
        Visibility(
          visible: _stop && seconds != 0,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: _timeOn ? _lapFunction : null,
            child: const Text('Lap'),
          ),
        ),
        Visibility(
          visible: seconds != 0 && !_stop ? true : false,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: _timeOn ? null : _resumeFunction,
            child: const Text('Resume'),
          ),
        ),
        Visibility(
          visible: _stop,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: _timeOn ? _stopFunction : null,
            child: const Text('Stop'),
          ),
        ),
      ],
    );
  }

  Widget _lapDisplay() {
    return ListView(
      children: [
        for (int i in _laps)
          ListTile(
            title: Text(
                'Lap ${_laps.indexOf(i) + 1}: ${_hours(i)}:${_minutes(i)}:${_seconds(i)}'),
          )
      ],
    );
  }
}
