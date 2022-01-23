import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

abstract class BaseWallet extends StatefulWidget {
  final String title;

  const BaseWallet(this.title, {Key? key}) : super(key: key);

  @override
  BaseWalletState createState();
}

abstract class BaseWalletState<T extends BaseWallet> extends State<T> {
  List<String> logs = [];

  void showLog(String log) {
    logs.add(log);
  }

  late final Logger logger;

  Widget _buildLogs() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Text(
          logs[index],
          style: TextStyle(fontSize: 12),
        );
      },
      itemCount: logs.length,
    );
  }

  @override
  void initState() {
    super.initState();
    logger = Logger(
      output: MyConsoleOutput(showLog),
      filter: MylogFilter(),
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 0,
        lineLength: 30,
        printEmojis: true,
        printTime: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildLogs(),
    );
  }
}

class MyConsoleOutput extends LogOutput {
  final Function(String) myPrint;

  MyConsoleOutput(this.myPrint);

  @override
  void output(OutputEvent event) {
    event.lines.forEach(myPrint);
  }
}

class MylogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}