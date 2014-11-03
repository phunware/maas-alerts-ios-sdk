#PWAlerts Changelog

##1.3.2 (Monday, November 3rd, 2014)
 * Added support for encryption

##1.3.1 (Wednesday, September 17th, 2014)
 * Updated PWAlerts to be compatible with iOS 8
 * **NOTE**: This is a required update. If you compile against the iOS 8 SDK using an older version of PWAlerts SDK **it will not register properly for remote notifications in iOS 8**.
 * The application developer is now responsible for registering for remote notifications using the apple provided APIs.  The following code or something like it should be present your application delegate or when you want to register for remote notifications:
 ```
if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    else {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];
    }
```

##1.3.0 (Friday, April 11th, 2014)
 * Renamed MaaSAlerts to PWAlerts
 * Added PWAlertSegment class which allows easy management of segment subscriptions
 * Moved subscription management state into the PWAlerts SDK leveraging PWAlertSegment -- see documentation for more details
 * Added support for nested alert segments
 * Added new method: `getAlertSegmentsWithSuccess:failure:`
 * Deprecated method: `getSubscriptionGroupsWithSuccess:failure:`
 * Added new method: `updateAlertSegments:success:failure:`
 * Deprecated method: `subscribeToGroupsWithIDs:success:failure:`

##1.2.1 (Wednesday, March 26th, 2014)
 * Adding arm64 support

##1.2.0 (Monday, December 23rd, 2013)
 * Added support for custom alerts (direct, location based, etc)
 * Added new object to encapsulate a notification, PWAlert
 * Added new method: `getExtraInformationForAlert:success:failure`
 * Deprecated `getExtraInformationForPushID:success:failure`

##1.1.1 (Friday, November 8th, 2013)
 * Re-enabled alerts registration with MaaS on application launch

##1.1.0 (Thursday, November 7th, 2013)
 * Updated MaaSAlerts to support registration on subscription group update
 * Now only triggering an alerts registration event when the device token changes
 * Network optimizations & bug fixes

##1.0.0 (Friday, June 30th, 2013)
 * Initial release