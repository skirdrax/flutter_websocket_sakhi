import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late WebSocketChannel channel;
  final TextEditingController controller = TextEditingController();
  List<String> messages = [];

  @override
  void initState() {
    super.initState();

    channel = WebSocketChannel.connect(Uri.parse('wss://wssimple.arinov.com'));

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
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        appBar: AppBar(
          title: const Text('WebSocket ListView Example'),
          backgroundColor: const Color.fromARGB(255, 12, 145, 81),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Menampilkan daftar pesan
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(messages[index]),
                      leading: const Icon(
                        Icons.message,
                        color: Color.fromARGB(255, 12, 155, 162),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),

              // Input field untuk mengirim pesan
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Kirim pesan',
                ),
              ),
              const SizedBox(height: 10),

              // Tombol Kirim
              ElevatedButton(
                onPressed: () {
                  final text = controller.text;
                  if (text.isNotEmpty) {
                    channel.sink.add(text); // Kirim pesan ke server
                    controller.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 13, 168, 103),
                ),
                child: const Text(
                  'Kirim',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
