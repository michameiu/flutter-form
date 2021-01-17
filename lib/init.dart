

import 'package:onesignal_flutter/onesignal_flutter.dart';

class Init{
  static Future initializeApp({userId:null}) async {
    await oneSignalInitialization(userId:userId);
  }

  static _registerServices() async {
    //TODO register services
  }

  static _loadSettings() async {
    //TODO load settings
    print("starting loading settings");
    await Future.delayed(Duration(seconds: 1));
    print("finished loading settings");
  }

  static oneSignalInitialization({userId:null}) async {
//    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.init(
        "4644018d-31a0-4ced-8fe0-e7f43eae4516",
        iOSSettings: {
          OSiOSSettings.autoPrompt: false,
          OSiOSSettings.inAppLaunchUrl: false
        }
    );
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    var playerId = status.subscriptionStatus.userId;
    print("player ID $playerId");
    if(userId !=null){
      oneSingalSetUserId(userId);
    }
// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//    await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
  }

  static oneSingalSetUserId(userId) async{
    print("setting user id $userId");
    var res= await OneSignal.shared.setExternalUserId(userId.toString());
    print(res);
  }

}