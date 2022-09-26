import 'package:computerstatussocketmobile/Screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  var controller = TextEditingController();

  asyncFunc(TextEditingController  control) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ip', control.text);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigo,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
    
            SizedBox(
              width: 300,
              child: TextField(
                scrollPadding: const EdgeInsets.all(10),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Informe o endereço IP.',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.white
                  )
                ),
                controller: controller,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () { 
                    asyncFunc(controller);
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => const HomePage()
                    ));
                   },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 45, 59, 141),
                    textStyle: const TextStyle(
                      color: Colors.white
                    )
                  ),
                  child: const Text('Iniciar')
                  ),
              ],
            ),
    
          ],
        ),
      ),
    );
  }
}