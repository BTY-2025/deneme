import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfaireader/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

void main() {
  setUp(() async {
    final List<Map<String, String>> mockFiles = List.generate(12, (index) {
      if (index == 0) return {'name': 'Annual_Report_2026.pdf', 'meta': '2.4 MB · 24 sayfa', 'path': '/mock/path1', 'time': '2h ago'};
      if (index == 1) return {'name': 'Marketing_Strategy_2026.pdf', 'meta': '1.2 MB · 12 sayfa', 'path': '/mock/path2', 'time': '3h ago'};
      if (index == 2) return {'name': 'User_Guide_Draft.pdf', 'meta': '800 KB · 8 sayfa', 'path': '/mock/path3', 'time': '5h ago'};
      return {'name': 'Mock_File_$index.pdf', 'meta': '1.0 MB · 10 sayfa', 'path': '/mock/path_$index', 'time': '${index}h ago'};
    });
    SharedPreferences.setMockInitialValues({
      'recent_files_list': jsonEncode(mockFiles),
    });
    await EasyLocalization.ensureInitialized();
    
    // Mock asset loader for Google Fonts to prevent HTTP fetching and bypass checksum checks
    final fontData = await rootBundle.load('packages/cupertino_icons/assets/CupertinoIcons.ttf');
    final binaryMessenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    
    binaryMessenger.setMockMessageHandler(
      'flutter/assets',
      (ByteData? message) async {
        if (message == null) return null;
        final key = utf8.decode(message.buffer.asUint8List());
        if (key.startsWith('google_fonts/')) {
          return fontData;
        }
        if (key == 'AssetManifest.json') {
          final manifest = {
            'google_fonts/Inter-Regular.ttf': ['google_fonts/Inter-Regular.ttf'],
            'google_fonts/Inter-Medium.ttf': ['google_fonts/Inter-Medium.ttf'],
            'google_fonts/Inter-Bold.ttf': ['google_fonts/Inter-Bold.ttf'],
            'google_fonts/Inter-SemiBold.ttf': ['google_fonts/Inter-SemiBold.ttf'],
          };
          return ByteData.view(Uint8List.fromList(utf8.encode(jsonEncode(manifest))).buffer);
        }
        if (key == 'AssetManifest.bin') {
          final manifest = {
            'google_fonts/Inter-Regular.ttf': ['google_fonts/Inter-Regular.ttf'],
            'google_fonts/Inter-Medium.ttf': ['google_fonts/Inter-Medium.ttf'],
            'google_fonts/Inter-Bold.ttf': ['google_fonts/Inter-Bold.ttf'],
            'google_fonts/Inter-SemiBold.ttf': ['google_fonts/Inter-SemiBold.ttf'],
          };
          return StandardMessageCodec().encodeMessage(manifest);
        }
        try {
          final file = File('build/unit_test_assets/$key');
          if (await file.exists()) {
            final bytes = await file.readAsBytes();
            return ByteData.view(bytes.buffer);
          }
        } catch (_) {}
        return null;
      },
    );
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
      null,
    );
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: const [
            Locale('en'),
            Locale('tr'),
          ],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          assetLoader: const JsonAssetLoader(),
          child: const MyApp(),
        ),
      );
      // Allow filesystem I/O to complete
      await Future.delayed(const Duration(milliseconds: 100));
      await tester.pump();
    });
    await tester.pumpAndSettle();
  }

  testWidgets('Splash screen layout test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await pumpApp(tester);

    // Verify that the logo text/application title is present.
    expect(find.text('PDF AI Reader'), findsOneWidget);

    // Verify that the main slogan heading is present.
    expect(find.text('Smarter PDFs,\nBetter Decisions.'), findsOneWidget);

    // Verify that the subtitle is present.
    expect(
      find.text('Read, summarize, convert, and chat with your PDFs using the power of AI'),
      findsOneWidget,
    );

    // Verify that the "Get Started" button text is present.
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('Splash screen to HomeScreen navigation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await pumpApp(tester);

    // Verify "Get Started" is visible, scroll it into view, and tap it
    final getStartedButton = find.text('Get Started');
    expect(getStartedButton, findsOneWidget);
    await tester.ensureVisible(getStartedButton);
    await tester.pumpAndSettle();
    
    await tester.tap(getStartedButton);
    await tester.pumpAndSettle(); // Wait for navigation transition to finish

    // Verify we are on the HomeScreen and dashboard elements are present
    expect(find.text('User0123374123'), findsOneWidget);
    expect(find.text('Upload a PDF'), findsOneWidget);
    expect(find.text('Recent Files'), findsOneWidget);
    expect(find.text('See All'), findsOneWidget);
    expect(find.text('Quick Tools'), findsOneWidget);
    
    // Verify tools are present
    expect(find.text('PDF to Word'), findsOneWidget);
    expect(find.text('Chat PDF'), findsOneWidget);
    expect(find.text('PDF Summary'), findsOneWidget);
  });

  testWidgets('HomeScreen navigation and tab views test', (WidgetTester tester) async {
    await pumpApp(tester);

    // Navigate to HomeScreen from Splash Screen
    final getStartedButton = find.text('Get Started');
    await tester.ensureVisible(getStartedButton);
    await tester.pumpAndSettle();
    await tester.tap(getStartedButton);
    await tester.pumpAndSettle();

    // Verify initial state is Home Dashboard
    expect(find.text('Upload a PDF'), findsOneWidget);
    expect(find.text('12 recent files'), findsNothing); // only visible on Recent tab

    // Tap "See All" and verify transition to Recent Files screen
    final seeAllButton = find.text('See All');
    expect(seeAllButton, findsOneWidget);
    await tester.tap(seeAllButton);
    await tester.pumpAndSettle();

    // Verify "Recent Files" view content
    expect(find.text('12 recent files'), findsOneWidget);
    expect(find.text('Search recent files...'), findsOneWidget);
    expect(find.text('Annual_Report_2026.pdf'), findsOneWidget);
    expect(find.text('Marketing_Strategy_2026.pdf'), findsOneWidget);
    expect(find.text('User_Guide_Draft.pdf'), findsOneWidget);
    expect(find.text('Upload a PDF'), findsNothing); // should not be visible on Recent Files tab

    // Tap "Tools" tab in bottom navigation and verify transition to Tools view
    final toolsTab = find.text('Tools');
    expect(toolsTab, findsOneWidget);
    await tester.tap(toolsTab);
    await tester.pumpAndSettle();

    // Verify "Tools" view content
    expect(find.text('AI Assistant'), findsOneWidget);
    expect(find.text('PDF Summary'), findsOneWidget);
    expect(find.text('Chat PDF'), findsOneWidget);
    expect(find.text('PDF to Word'), findsOneWidget);
    expect(find.text('Start Converting'), findsOneWidget);
    expect(find.text('Search recent files...'), findsNothing); // should not be visible on Tools tab

    // Tap "Home" tab in bottom navigation and verify transition back to Home Dashboard
    final homeTab = find.text('Home');
    expect(homeTab, findsOneWidget);
    await tester.tap(homeTab);
    await tester.pumpAndSettle();

    // Verify we are back on Home Dashboard
    expect(find.text('Upload a PDF'), findsOneWidget);
  });
}

class JsonAssetLoader extends AssetLoader {
  const JsonAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final file = File('assets/translations/${locale.languageCode}.json');
    final content = await file.readAsString();
    return jsonDecode(content) as Map<String, dynamic>;
  }
}

class TestHttpOverrides extends HttpOverrides {
  final Uint8List fontBytes;
  TestHttpOverrides(this.fontBytes);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return MockHttpClient(fontBytes);
  }
}

class MockHttpClient implements HttpClient {
  final Uint8List fontBytes;
  MockHttpClient(this.fontBytes);

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return MockHttpClientRequest(fontBytes);
  }

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async {
    return MockHttpClientRequest(fontBytes);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return null;
  }
}

class MockHttpClientRequest implements HttpClientRequest {
  final Uint8List fontBytes;
  MockHttpClientRequest(this.fontBytes);

  @override
  final HttpHeaders headers = MockHttpHeaders();

  @override
  Future<dynamic> addStream(Stream<List<int>> stream) async {}

  @override
  Future<HttpClientResponse> close() async {
    return MockHttpClientResponse(fontBytes);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return null;
  }
}

class MockHttpHeaders implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return null;
  }
}

class MockHttpClientResponse implements HttpClientResponse {
  final Uint8List fontBytes;
  MockHttpClientResponse(this.fontBytes);

  @override
  int get statusCode => 200;

  @override
  int get contentLength => fontBytes.length;

  @override
  final HttpHeaders headers = MockHttpHeaders();

  @override
  bool get isRedirect => false;

  @override
  String get reasonPhrase => 'OK';

  @override
  List<RedirectInfo> get redirects => const [];

  @override
  bool get persistentConnection => true;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    final stream = Stream<List<int>>.fromIterable([fontBytes]);
    return stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return null;
  }
}
