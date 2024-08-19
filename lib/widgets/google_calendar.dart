import 'dart:io';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as google_api;
import 'package:http/io_client.dart' show IOClient, IOStreamedResponse;
import 'package:http/http.dart' as http; // Corrected import
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:oauth2/oauth2.dart' as oauth2; // Ensure proper usage of oauth2
import 'package:hive_flutter/hive_flutter.dart'; // Store user in hive box

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
  List<google_api.Event>? _events;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _signInSilently();
    });
  }

  Future<void> _signInSilently() async {
    try {
      final box = Hive.box('google_user');
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

        _fetchGoogleEvents();
      } else {
        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          _showSignInDialog();
        }
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      _showSignInDialog(); // Show the sign-in dialog if silent sign-in fails
    }
  }

  Future<void> _fetchGoogleEvents() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (_client != null) {
        final calendarApi = google_api.CalendarApi(_client!);
        final calEvents = await calendarApi.events.list("primary");
        final appointments = <google_api.Event>[];
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

  Future<void> _handleSignIn() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Generate the authorization URL
      final authorizationUrl = _grant.getAuthorizationUrl(
        Uri.parse('http://localhost:8080/'),
        scopes: [google_api.CalendarApi.calendarScope],
      );

      // Launch the URL for user to authorize
      await launchUrl(authorizationUrl, mode: LaunchMode.externalApplication);

      // Start a server to handle the redirect URI
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
      server.listen((HttpRequest request) async {
        final code = request.uri.queryParameters['code'];
        if (code != null) {
          // Exchange the authorization code for credentials
          final tempCredentials =
              await _grant.handleAuthorizationResponse({'code': code});

          final credentials = tempCredentials.credentials;

          // Create an AutoRefreshingAuthClient using the credentials
          _client = auth.autoRefreshingClient(
              auth.ClientId(_grant.identifier, _grant.secret),
              auth.AccessCredentials(
                  auth.AccessToken('Bearer', credentials.accessToken,
                      credentials.expiration!.toUtc()),
                  credentials.refreshToken,
                  credentials.scopes!,
                  idToken: credentials.idToken),
              http.Client());

          // Save credentials to Hive box so we can use it later

          final box = Hive.box('google_user');
          box.put('credentials', credentials.toJson());

          _fetchGoogleEvents();

          // Send a response to the browser
          final response = request.response;
          response
            ..statusCode = HttpStatus.ok
            ..write('You can close this window.')
            ..close();
        }

        await server.close();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSignInDialog() {
    if (!_isDialogShown) {
      _isDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
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
                  },
                ),
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _isLoading =
                          false; // Ensure loading is stopped if user cancels
                    });
                  },
                ),
              ],
            );
          },
        ).then((_) {
          _isDialogShown = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SfCalendar(
                view: CalendarView.month,
                dataSource: GoogleDataSource(events: _events),
                monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
                ),
              ));
  }
}

class GoogleDataSource extends CalendarDataSource {
  GoogleDataSource({required List<google_api.Event>? events}) {
    appointments = events;
  }

  @override
  DateTime getStartTime(int index) {
    final google_api.Event event = appointments![index];
    return event.start?.date ?? event.start!.dateTime!.toLocal();
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].start.date != null;
  }

  @override
  DateTime getEndTime(int index) {
    final google_api.Event event = appointments![index];
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
    final google_api.Event event = appointments![index];
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
