// Most of this code is an adaptation of https://github.com/SyncfusionExamples/add-google-event-calendar-to-flutter-event-calendar
// The repo used only demonstrated how to connect the two together, but didn't account on how to show sign in dialogs and how to log in silently

// Imports were organized and using ChatGPT
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as calendar_api;
import 'package:http/io_client.dart' show IOClient, IOStreamedResponse;
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive/hive.dart';

// These two conflict with each other and require separate definitions because of it
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:oauth2/oauth2.dart' as oauth2;

import 'package:provider/provider.dart';
import '../providers/moving_provider/settings_provider.dart';

class GoogleCalendar extends StatefulWidget {
  const GoogleCalendar({super.key});

  @override
  State<GoogleCalendar> createState() => _GoogleCalendarState();
}

class _GoogleCalendarState extends State<GoogleCalendar> {
  late oauth2.AuthorizationCodeGrant _grant;
  auth.AutoRefreshingAuthClient? _client;
  bool _isLoading = true;
  bool _isDialogShown = false;
  bool _isSigningIn = false;
  late Uri _authorizationUrl;
  Box box = Hive.box("google_user");
  late oauth2.Credentials _credentials;
  List<calendar_api.Event>? _events;

  @override
  void initState() {
    super.initState();

    String clientId =
        const String.fromEnvironment('CLIENT_ID', defaultValue: '');
    String clientSecret =
        const String.fromEnvironment("CLIENT_SECRET", defaultValue: '');

    _grant = oauth2.AuthorizationCodeGrant(
      clientId,
      Uri.parse('https://accounts.google.com/o/oauth2/auth'),
      Uri.parse('https://oauth2.googleapis.com/token'),
      secret: clientSecret,
    );
  }

  Future<void> _signInSilently() async {
    try {
      final credentialsJson = box.get('credentials');

      if (credentialsJson != null) {
        final credentials = oauth2.Credentials.fromJson(credentialsJson);

        _client = auth.autoRefreshingClient(
          auth.ClientId(_grant.identifier, _grant.secret),
          auth.AccessCredentials(
            auth.AccessToken('Bearer', credentials.accessToken,
                credentials.expiration!.toUtc()),
            credentials.refreshToken,
            credentials.scopes!,
            idToken: credentials.idToken,
          ),
          http.Client(),
        );

        await _getUserProfile(box);

        // Check to see whether the google calendar scope was granted or not
        if (!credentials.scopes!
            .contains(calendar_api.CalendarApi.calendarScope)) {
          throw Exception("Calendar scope not granted");
        }

        _fetchGoogleEvents();
        setState(() {
          _isSigningIn = true;
        });
      } else {
        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          _showSignInDialog();
        }
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _isSigningIn = false;
      });
      _showSignInDialog(); // Show the sign-in dialog if silent sign-in fails
    }
  }

  Future<void> _getUserProfile(Box<dynamic> box) async {
    // Suggested by ChatGPT and then modified accordingly
    final response = await _client!
        .get(Uri.parse('https://www.googleapis.com/oauth2/v2/userinfo'));
    if (response.statusCode == 200) {
      final profile = json.decode(response.body);
      box.put('name', profile['name']);
      box.put('picture', profile['picture']);
    } else {
      throw Exception('Failed to load profile info');
    }
  }

  Future<void> _fetchGoogleEvents() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
      try {
        if (_client != null) {
          final calendarApi = calendar_api.CalendarApi(_client!);
          final calEvents = await calendarApi.events.list("primary");
          final appointments = <calendar_api.Event>[];
          if (calEvents.items != null) {
            for (final event in calEvents.items!) {
              if (event.start != null) {
                appointments.add(event);
              }
            }
          }
          setState(() {
            _events = appointments;
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Authorization boilerplate generated by ChatGPT
  Future<void> _handleSignIn() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Generate the authorization URL
      try {
        _authorizationUrl = _grant.getAuthorizationUrl(
          Uri.parse('http://localhost:8080/'),
          scopes: [
            'https://www.googleapis.com/auth/userinfo.profile',
            calendar_api.CalendarApi.calendarScope,
          ],
        );
      } catch (_) {}
      // Launch the URL for user to authorize
      await launchUrl(_authorizationUrl, mode: LaunchMode.inAppWebView);
      // Start a server to handle the redirect URI
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
      server.listen((HttpRequest request) async {
        final code = request.uri.queryParameters['code'];
        if (code != null) {
          try {
            // Exchange the authorization code for credentials
            final tempCredentials =
                await _grant.handleAuthorizationResponse({'code': code});
            _credentials = tempCredentials.credentials;
          } catch (_) {}

          // Create an AutoRefreshingAuthClient using the credentials
          _client = auth.autoRefreshingClient(
              auth.ClientId(_grant.identifier, _grant.secret),
              auth.AccessCredentials(
                  auth.AccessToken('Bearer', _credentials.accessToken,
                      _credentials.expiration!.toUtc()),
                  _credentials.refreshToken,
                  _credentials.scopes!,
                  idToken: _credentials.idToken),
              http.Client());

          // Send a response to the browser
          final response = request.response;
          response
            ..statusCode = HttpStatus.ok
            ..write('You can close this window.')
            ..close();
        }

        final box = Hive.box('google_user');
        box.put('credentials', _credentials.toJson());

        await _getUserProfile(box);

        _fetchGoogleEvents();

        await server.close();
      });
    } finally {
      setState(() {
        _isLoading = false;
        _isSigningIn = false;
      });
    }
  }

  // The SignInDialog was created using ChatGPT
  void _showSignInDialog() {
    if (!_isDialogShown) {
      _isDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _isSigningIn = true;
        });
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Sign in required"),
              content: const Text(
                  "Please sign in with Google to view your calendar."),
              actions: <Widget>[
                TextButton(
                  child: const Text("Sign In"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _handleSignIn();
                    setState(() {
                      // Ensure loading is stopped if user cancels
                      _isSigningIn = true;
                    });
                  },
                ),
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      // Ensure loading is stopped if user cancels
                      _isSigningIn = false;
                    });
                  },
                ),
              ],
            );
          },
        ).then((_) {
          setState(() {
            _isLoading = false;
          });
          _isDialogShown = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        Box navBox = Hive.box('navigation_settings');
        int selectedIndex = navBox.get('selectedIndex', defaultValue: 0);

        if (selectedIndex == 0 && _isLoading == true && _isSigningIn == false) {
          _signInSilently();
        }

        if (settingsProvider.requestLogIn == true && _isSigningIn == false) {
          _signInSilently();
          settingsProvider.requestLogIn = false;
        }

        if (_events != null && !settingsProvider.loggedIn) {
          settingsProvider.login();
        }

        if (box.isEmpty) {
          _events = null;
          _isSigningIn = false;
        }

        return Scaffold(
          body: (_isLoading)
              ? const Center(child: CircularProgressIndicator())
              : SfCalendar(
                  view: CalendarView.month,
                  dataSource: GoogleDataSource(events: _events),
                  monthViewSettings: const MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment,
                  ),
                ),
        );
      },
    );
  }
}

class GoogleDataSource extends CalendarDataSource {
  GoogleDataSource({required List<calendar_api.Event>? events}) {
    appointments = events;
  }

  @override
  DateTime getStartTime(int index) {
    final calendar_api.Event event = appointments![index];
    return event.start?.date ?? event.start!.dateTime!.toLocal();
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].start.date != null;
  }

  @override
  DateTime getEndTime(int index) {
    final calendar_api.Event event = appointments![index];
    return event.endTimeUnspecified != null && event.endTimeUnspecified!
        ? (event.start?.date ?? event.start!.dateTime!.toLocal())
        : (event.end?.date != null
            ? event.end!.date!.add(const Duration(days: -1))
            : event.end!.dateTime!.toLocal());
  }

  @override
  String getLocation(int index) {
    return appointments![index].location ?? '';
  }

  @override
  String getNotes(int index) {
    return appointments![index].description ?? '';
  }

  @override
  String getSubject(int index) {
    final calendar_api.Event event = appointments![index];
    return event.summary == null || event.summary!.isEmpty
        ? 'No Title'
        : event.summary!;
  }
}

class GoogleAPIClient extends IOClient {
  final Map<String, String> _headers;

  GoogleAPIClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(http.BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) =>
      super.head(url,
          headers: (headers != null ? (headers..addAll(_headers)) : headers));
}
