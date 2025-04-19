import 'package:chatbot/message.dart';
import 'package:chatbot/themeNotifier.dart';
import 'package:chatbot/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:chatbot/splash_screen.dart'; // Import the splash screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chatbot',
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: themeMode,
      home: SplashScreen(), // Set splash screen as the initial screen
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];

  bool isLoading = false;

  callGeminiModel() async {
    if (_controller.text.isEmpty || isLoading) return;

    setState(() {
      isLoading = true;
      _messages.add(Message(text: _controller.text, isUser: true));
    });

    final String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      print("Error: API Key is missing!");
      setState(() => isLoading = false);
      return;
    }

    try {
      final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);
      final response = await model.generateContent([Content.text(_controller.text.trim())]);

      if (response.text != null) {
        setState(() {
          _messages.add(Message(text: response.text!, isUser: false));
        });
      } else {
        print("Error: Response is empty");
      }
    } catch (e) {
      print("Error in callGeminiModel: $e");
    } finally {
      setState(() {
        isLoading = false;
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        elevation: 1,
        title: Row(
          children: [
            Image.asset('assets/gpt-robot.png', height: 30),
            const SizedBox(width: 8),
            Text(
              'ZephAI',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onBackground,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(ref.watch(themeProvider) == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: message.isUser ? theme.colorScheme.primary : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      decoration: const InputDecoration(
                        hintText: 'Write your message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: isLoading
                        ? const CircularProgressIndicator()
                        : Image.asset('assets/send.png', width: 24, height: 24),
                    onPressed: isLoading ? null : callGeminiModel,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
