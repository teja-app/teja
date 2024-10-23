import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:share_handler/share_handler.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/presentation/error_handler/error_handler.dart';
import 'package:teja/theme/dark_theme.dart';
import 'package:teja/theme/light_theme.dart';
import 'package:teja/theme/theme_service.dart';
import 'package:toastification/toastification.dart';

// class App extends StatelessWidget {
//   final Store<AppState> store;
//   final GoRouter router;

//   const App({
//     Key? key,
//     required this.store,
//     required this.router,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StoreProvider<AppState>(
//       store: store,
//       child: ChangeNotifierProvider(
//         create: (_) => ThemeService(),
//         child: Consumer<ThemeService>(
//           builder: (context, themeService, child) {
//             return MaterialApp.router(
//               title: 'Teja',
//               debugShowCheckedModeBanner: false,
//               darkTheme: darkTheme,
//               themeMode: themeService.themeMode,
//               theme: lightTheme,
//               routerConfig: router,
//               // navigatorObservers: [PosthogObserver()],
//               builder: (context, child) {
//                 return ToastificationConfigProvider(
//                   config: const ToastificationConfig(
//                     alignment: Alignment.topRight,
//                     itemWidth: 440,
//                     animationDuration: Duration(milliseconds: 500),
//                   ),
//                   child: ErrorHandler(
//                     child: MaterialApp.router(
//                       title: 'Teja',
//                       debugShowCheckedModeBanner: false,
//                       darkTheme: darkTheme,
//                       themeMode: themeService.themeMode,
//                       theme: lightTheme,
//                       routerConfig: router,
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  StreamSubscription<SharedMedia>? _streamSubscription;
  SharedMedia? media;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    final handler = ShareHandlerPlatform.instance;
    media = await handler.getInitialSharedMedia();
    _streamSubscription = handler.sharedMediaStream.listen((SharedMedia media) {
      if (!mounted) return;
      setState(() => this.media = media);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Share Handler Example',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Share Handler'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Text(
                'Shared to conversation identifier: ${media?.conversationIdentifier}',
              ),
              const SizedBox(height: 10),
              Text('Shared text: ${media?.content}'),
              const SizedBox(height: 10),
              Text('Shared files: ${media?.attachments?.length}'),
              ...(media?.attachments ?? []).map((attachment) {
                final path = attachment?.path;
                if (path != null &&
                    attachment?.type == SharedAttachmentType.image) {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          ShareHandlerPlatform.instance.recordSentMessage(
                            conversationIdentifier:
                                'custom-conversation-identifier',
                            conversationName: 'John Doe',
                            conversationImageFilePath: path,
                            serviceName: 'custom-service-name',
                          );
                        },
                        child: const Text('Record message'),
                      ),
                      const SizedBox(height: 10),
                      Image.file(File(path)),
                    ],
                  );
                }
                return Text(
                  '${attachment?.type} Attachment: ${attachment?.path}',
                );
              }),
            ],
          ),
        ));
  }
}
