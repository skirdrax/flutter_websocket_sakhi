import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late WebSocketChannel channel;
  final TextEditingController controller = TextEditingController();
  List<String> messages = []; // Menyimpan semua pesan

  @override
  void initState() {
    super.initState();

    channel = WebSocketChannel.connect(Uri.parse("wss://wssimple.arincov.com"));

    // Listen message
    channel.stream.listen((event) {
      setState(() {
        messages.add(event.toString());
      });
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("WebSocket ListView Example")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text(messages[index]));
                  },
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Kirim pesan",
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    channel.sink.add(controller.text);
                    controller.clear();
                  }
                },
                child: Text("Kirim"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
