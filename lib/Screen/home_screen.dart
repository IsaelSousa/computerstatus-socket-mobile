import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:percent_indicator/percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late IO.Socket socket;
  bool isConnect = false;
  double cpusage = 0;
  double freememory = 0;
  double totalmemory = 0;
  List<String> hourAndMinute = ['00', '00', '00'];

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  Future<void> initSocket() async {
    socket = IO.io('http://192.168.0.106:8080',
        IO.OptionBuilder().setTransports(['websocket']).build());

    socket.connect();
    socket.onConnect((_) {
      print('connected to websocket');
    });

    socket.on('connect', (data) {
      setState(() {
        isConnect = true;
      });
    });

    socket.on('cpusage', (data) {
      setState(() {
        cpusage = data;
      });
    });

    socket.on('freememory', (data) {
      setState(() {
        freememory = (100 - data) as double;
      });
    });

    socket.on('cputotalmemory', (data) {
      setState(() {
        totalmemory = data;
      });
    });

    socket.on('uptimehour', (data) {
      setState(() {
        hourAndMinute[0] = (data / 60 / 60 % 60).toString().substring(0, 2).padLeft(2, '0');
        hourAndMinute[1] = (data / 60 % 60).toString().substring(0, 2).padLeft(2, '0');
        hourAndMinute[2] = (data % 60).toString().padLeft(2, '0');
      });
    });

    socket.on('disconnect', (data) {
      setState(() {
        isConnect = false;
        cpusage = 0;
        freememory = 0;
        totalmemory = 0;
        hourAndMinute = ['00', '00', '00'];
      });
    });
  }

  @override
  void dispose() {
    socket.dispose();
    setState(() {
      isConnect = false;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigo,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor:
                        isConnect == true ? Colors.green : Colors.red,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('CPU Usage',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18)),
                      CircularPercentIndicator(
                        lineWidth: 10,
                        radius: 30,
                        percent: double.parse(
                            '0.${cpusage.toString().substring(0, 2).replaceAll('.', '').padLeft(2, '0')}'),
                        center: Text(
                            "${cpusage.toString().substring(0, 2).replaceAll('.', '')}%",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      const Text('RAM Usage',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          )),
                      CircularPercentIndicator(
                        lineWidth: 10,
                        radius: 30,
                        percent: double.parse(
                            '0.${freememory.toString().substring(0, 2).replaceAll('.', '').padLeft(2, '0')}'),
                        center: Text(
                            "${freememory.toString().substring(0, 2).replaceAll('.', '')}%",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Total RAM',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18),
                      ),
                      CircularPercentIndicator(
                        lineWidth: 10,
                        radius: 30,
                        animation: true,
                        percent: double.parse(
                            '0.${totalmemory.toString().substring(0, 2).replaceAll('.', '').padLeft(2, '0')}'),
                        center: Text(
                            "${totalmemory.toString().substring(0, 2).replaceAll('.', '')} GB",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [Text('Uptime Hours', style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900
                    ))],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(hourAndMinute.isNotEmpty
                          ? '${hourAndMinute[0]}:${hourAndMinute[1]}:${hourAndMinute[2]}'
                          : '', style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
