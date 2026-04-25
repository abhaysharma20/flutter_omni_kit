import 'package:flutter/material.dart';
import 'package:flutter_omni_kit/flutter_omni_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize OmniStorage for the demo
  await OmniStorage.init();
  runApp(const OmniKitShowcase());
}

class OmniKitShowcase extends StatelessWidget {
  const OmniKitShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Omni Kit Showcase',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ShowcaseHome(),
    );
  }
}

class ShowcaseHome extends StatefulWidget {
  const ShowcaseHome({super.key});

  @override
  State<ShowcaseHome> createState() => _ShowcaseHomeState();
}

class _ShowcaseHomeState extends State<ShowcaseHome> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MediaPage(),
    const UIPage(),
    const UtilsPage(),
    const ExtensionsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.play_circle), label: 'Media'),
          NavigationDestination(icon: Icon(Icons.auto_awesome), label: 'UI'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Utils'),
          NavigationDestination(icon: Icon(Icons.extension), label: 'Extensions'),
        ],
      ),
    );
  }
}

// --- MEDIA PAGE ---
class MediaPage extends StatelessWidget {
  const MediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Media & Documents'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Omni Video Player", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          const OmniVideoPlayer(
            url: 'https://www.w3schools.com/html/mov_bbb.mp4',
            useBackgroundValidation: true,
          ),
          const SizedBox(height: 24),
          const Text("Omni Audio Player", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          const OmniAudioPlayer(
            url: 'https://www.w3schools.com/html/horse.mp3',
            useBackgroundValidation: true,
          ),
          const SizedBox(height: 24),
          const Text("File Previewer (Asset Example)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          const Center(child: Text("Previewing images/PDFs is as easy as passing the path!")),
        ],
      ),
    );
  }
}

// --- UI PAGE ---
class UIPage extends StatelessWidget {
  const UIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modern UI Components'), centerTitle: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade300, Colors.deepPurple.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const OmniGlassCard(
              blur: 15,
              opacity: 0.15,
              child: Column(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.white, size: 48),
                  SizedBox(height: 12),
                  Text(
                    "OmniGlassCard",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Ultra-smooth glassmorphism container with backdrop blur.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "OmniShimmer (Loading States)", 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              color: Colors.white.withAlpha(230),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: OmniShimmer.listTile(count: 3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- UTILS PAGE ---
class UtilsPage extends StatefulWidget {
  const UtilsPage({super.key});

  @override
  State<UtilsPage> createState() => _UtilsPageState();
}

class _UtilsPageState extends State<UtilsPage> {
  String _savedName = "Not set";

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  void _loadName() {
    setState(() {
      _savedName = OmniStorage.read<String>('user_name') ?? "Not set";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Infrastructure Utils'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const OmniGlassCard(
              blur: 5,
              color: Colors.deepPurple,
              opacity: 0.05,
              child: Text("One-liner Storage & Network", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text("OmniStorage Demo"),
              subtitle: Text("Stored Name: $_savedName"),
              trailing: ElevatedButton(
                onPressed: () async {
                  await OmniStorage.write('user_name', 'Abhay Sharma');
                  _loadName();
                },
                child: const Text("Save 'Abhay'"),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.wifi),
              title: const Text("OmniNetwork Demo"),
              subtitle: const Text("Perform background API check"),
              onTap: () async {
                final net = OmniNetwork();
                bool connected = await net.isConnected;
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text(connected ? "Online! Connectivity working." : "Offline! No connection."),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// --- EXTENSIONS PAGE ---
class ExtensionsPage extends StatelessWidget {
  const ExtensionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dart Extensions'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _extTile("String.capitalize", "hello world".capitalize),
          _extTile("String.maskEmail", "abhay.sharma@email.com".maskEmail()),
          _extTile("DateTime.timeAgo", DateTime.now().subtractDays(2).timeAgo()),
          _extTile("Num.toCompact", 2500000.toCompact()),
          _extTile("Num.toCurrency", 5432.10.toCurrency(symbol: '₹')),
        ],
      ),
    );
  }

  Widget _extTile(String title, String result) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(result, style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}
