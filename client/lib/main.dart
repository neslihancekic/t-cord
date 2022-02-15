import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tcord/models/authentication/authentication_data.dart';
import 'package:tcord/models/notification/notification_model.dart';
import 'package:tcord/models/user/user_model.dart';
import 'package:tcord/services/comment_service.dart';
import 'package:tcord/services/composition_service.dart';
import 'package:tcord/services/developer_service.dart';
import 'package:tcord/services/notification_service.dart';
import 'package:tcord/services/upload_service.dart';
import 'package:tcord/services/user_service.dart';
import 'package:tcord/views/edit/edit.dart';
import 'package:tcord/views/generic/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tcord/views/home/home.dart';
import 'package:tcord/views/notifications/notifications.dart';
import 'package:tcord/views/profile/myProfile.dart';
import 'package:tcord/views/profile/profile.dart';
import 'package:tcord/views/record/record.dart';
import 'package:tcord/views/search/search.dart';
import 'services/authentication_service.dart';
import 'services/network/api_service.dart';
import 'views/generic/actions.dart';
import 'views/generic/templates.dart';
import 'views/generic/themes.dart';
import 'views/login/login.dart';
import 'package:flutter/foundation.dart';
import 'package:tcord/utils/extensions.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {
  runZonedGuarded(() async {
    await GetStorage.init();
    await Firebase.initializeApp();
    await initServices();
    WidgetsFlutterBinding.ensureInitialized();
    FirebaseMessaging.onBackgroundMessage(_messageHandler);
    FlutterError.onError = (FlutterErrorDetails details) async {
      FirebaseCrashlytics.instance.recordFlutterError(details);
    };
    runApp(MainWidget());
  }, (error, stackTrace) async {
    //final _developerService = Get.put(DeveloperService());
    //FirebaseCrashlytics.instance.recordError(error, stackTrace);
    // await _developerService.sendLogs(error: true);
  });
}

Future initServices() async {
  var _authenticationService = Get.put(AuthenticationService());
  await _authenticationService.init();
  Get.put(ApiService());
  var _userService = Get.put(UserService());
  Get.put(CompositionService());
  Get.put(UploadService());
  Get.put(NotificationService());
  Get.put(CommentService());
  var messaging = FirebaseMessaging.instance;
  if (await _authenticationService.isUserAuthenticated()) {
    messaging.getToken().then((value) {
      _userService.updateFCM(UserModel(fcmToken: value));
    });
  }
  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    print("message recieved"); // show a notification at top of screen.
    showSimpleNotification(
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: AppTheme.Opal,
                  boxShadow: [CustomBoxShadow()],
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: AppTheme.White,
                      borderRadius: BorderRadius.circular(34)),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: event.notification!.android!.imageUrl == null
                        ? Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(27)),
                            child: new Icon(
                              Icons.person,
                              size: 15,
                            ),
                          )
                        : Container(
                            clipBehavior: Clip.hardEdge,
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                color: AppTheme.Opal,
                                borderRadius: BorderRadius.circular(50)),
                            child: CachedNetworkImage(
                              imageUrl: event.notification!.android!.imageUrl!,
                              placeholder: (context, url) => Center(
                                  child: Container(
                                      width: 50,
                                      height: 50,
                                      child: Image.asset(
                                          'assets/images/loading.gif'))),
                              errorWidget: (context, url, error) => new Icon(
                                Icons.error_outline,
                                size: 15,
                              ),
                              fit: BoxFit.cover,
                            )),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              event.notification!.body ?? "",
              style: TextStyle(
                  fontFamily: "Circular",
                  fontWeight: FontWeight.w700,
                  fontSize: AppTheme.FootnoteFontSize13,
                  color: AppTheme.Xiketic),
            ),
          ],
        ),
        background: AppTheme.GhostWhite,
        duration: Duration(seconds: 4));
    print(event.notification!.body);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((message) async {
    var _notificationService = Get.put(NotificationService());
    var request = NotificationModel(isRead: true);
    await _notificationService.readNotification(message.data["id"]!, request);
    print('Message clicked!');
  });
}

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

class MainWidget extends StatelessWidget {
  const MainWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    FirebaseAnalytics analytics = FirebaseAnalytics();
    return OverlaySupport.global(
        child: GetMaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate, // Add this line
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', ''), // English, no country code
              const Locale('tr', ''), // Turkish, no country code
            ],
            title: 'T-cord',
            theme: ThemeData(
                fontFamily: "Circular",
                primaryColor: AppTheme.DarkJungleGreen,
                scaffoldBackgroundColor: AppTheme.PageBackgroundColor),
            initialRoute: '/',
            getPages: [
              GetPage(name: "/", page: () => LaunchPage()),
              GetPage(name: "/mainPage", page: () => MainPage()),
            ],
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: analytics)
            ]));
  }
}

class LaunchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  AuthenticationService authenticationService = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.Opal, AppTheme.Opal, AppTheme.Lilac])),
            child: Column(
              children: [
                SizedBox(height: 40),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'T-cord',
                      style: TextStyle(
                          fontFamily: "Circular",
                          fontWeight: FontWeight.w700,
                          fontSize: 50,
                          color: AppTheme.White),
                    ),
                  ),
                ),
              ],
            )));
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 5))
        .then((value) async => checkUserAuthenticated());

    super.initState();
  }

  void checkUserAuthenticated() {
    authenticationService.isUserAuthenticated().then((value) {
      if (value == null) return;
      if (value) {
        Get.offAll(() => MainPage(), transition: Transition.noTransition);
      } else {
        Get.offAll(() => LoginPage(), transition: Transition.noTransition);
      }
    });
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TabNavController navController = Get.put(TabNavController(context));

    final List<Widget> pages = [
      HomePage(),
      SearchPage(),
      RecordPage(),
      NotificationsPage(),
      MyProfilePage(),
    ];

    Future<bool> _onWillPop() async {
      showCustomGeneralDialog(
          context,
          SvgPicture.asset(
            'inboundSelected'.toSvgPath(),
            width: 0,
            height: 0,
          ),
          AppLocalizations.of(context)!.exitApp,
          AppLocalizations.of(context)!.leave,
          cancelText: AppLocalizations.of(context)!.cancel,
          okPressed: () => SystemNavigator.pop(),
          cancelPressed: () => Get.back(),
          top: 0.0);
      return true;
    }

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            body: Obx(() => pages[navController.selectedIndex]),
            bottomNavigationBar: BottomAppBar(
              color: Colors.amber.withOpacity(0),
              elevation: 50,
              notchMargin: 5,
              shape: CircularNotchedRectangle(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                color: AppTheme.White,
                height: 55,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {
                          navController.selectedIndex = 0;
                          HomePageController controller =
                              Get.put(HomePageController(context));
                          controller.onInit();
                        },
                        icon: Obx(() => navController.selectedIndex == 0
                            ? SvgPicture.asset('homeSelected'.toSvgPath(),
                                color: AppTheme.DarkJungleGreen)
                            : SvgPicture.asset('home'.toSvgPath(),
                                color: AppTheme.DarkJungleGreen.withOpacity(
                                    0.3)))),
                    IconButton(
                        onPressed: () => navController.selectedIndex = 1,
                        icon: Obx(() => navController.selectedIndex == 1
                            ? SvgPicture.asset('search'.toSvgPath(),
                                color: AppTheme.DarkJungleGreen)
                            : SvgPicture.asset('search'.toSvgPath(),
                                color: AppTheme.DarkJungleGreen.withOpacity(
                                    0.3)))),
                    IconButton(
                      onPressed: () => navController.selectedIndex = 2,
                      padding: const EdgeInsets.all(0),
                      icon: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [CustomBoxShadow()],
                            color: AppTheme.Opal),
                        child: Center(
                          child: SvgPicture.asset(
                            'mic'.toSvgPath(),
                            color: AppTheme.White,
                            width: 25,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () => navController.selectedIndex = 3,
                        icon: Obx(() => navController.selectedIndex == 3
                            ? SvgPicture.asset('notificationOff'.toSvgPath(),
                                width: 24, color: AppTheme.DarkJungleGreen)
                            : SvgPicture.asset('notificationOff'.toSvgPath(),
                                width: 25,
                                color: AppTheme.DarkJungleGreen.withOpacity(
                                    0.3)))),
                    IconButton(
                        onPressed: () => navController.selectedIndex = 4,
                        icon: Obx(() => navController.selectedIndex == 4
                            ? Icon(
                                Icons.person_outlined,
                                size: 24,
                                color: AppTheme.DarkJungleGreen,
                              )
                            : Icon(Icons.person_outlined,
                                size: 24,
                                color: AppTheme.DarkJungleGreen.withOpacity(
                                  0.3,
                                )))),
                  ],
                ),
              ),
            )));
  }
}

class TabNavController extends BaseGetxController {
  late DateTime pauseTime;

  final _selectedIndex = 0.obs;
  TabNavController(BuildContext context) : super(context);

  get selectedIndex => this._selectedIndex.value;
  set selectedIndex(index) => this._selectedIndex.value = index;
}
