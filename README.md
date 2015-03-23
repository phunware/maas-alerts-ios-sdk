MaaS Alerts SDK for iOS
==================

Version 1.3.2

This is Phunware's iOS SDK for the Alerts & Notifications module. Visit http://maas.phunware.com/ for more details and to sign up.


Requirements
------------

- MaaSCore v1.3.0 or greater
- iOS 6.0 or greater
- Xcode 5 or greater



Installation
------------

The recommended way to use PWAlerts is via [CocoaPods](http://cocoapods.org). Add the following pod to your `Podfile` to use PWAlerts:
````
pod 'PWAlerts', '~>1.3.0'
````

PWAlerts has a dependency on MaaSCore.framework, which is available here: https://github.com/phunware/maas-core-ios-sdk

It's recommended that you add the MaaS frameworks to the 'Vendor/Phunware' directory. Then add the MaaSCore.framework and PWAlerts.framework to your Xcode project.

The following frameworks are required:
````
MaaSCore.framework
````

Scroll down for implementation details.



Documentation
------------

PWAlerts documentation is included in the Documents folder in the repository as both HTML and as a .docset. You can also find the latest documentation here: http://phunware.github.io/maas-alerts-ios-sdk/

Here are some resources to help you configure your app for Apple Push Notifications:
- [Apple's documentation](https://developer.apple.com/library/ios/#documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Introduction.html)
- [Apple Push Notification services (APNs) Tutorial (1/2)](http://www.raywenderlich.com/32960/apple-push-notification-services-in-ios-6-tutorial-part-1)
- [Apple Push Notification services (APNs) tutorial (2/2)](http://www.raywenderlich.com/32963/apple-push-notification-services-in-ios-6-tutorial-part-2)



Application Setup
-----------------
At the top of your application delegate (.m) file, add the following:

````objective-c
#import <MaaSCore/MaaSCore.h>
#import <PWAlerts/PWAlerts.h>
````

Inside your application delegate, you will need to initialize MaaSCore in the application:didFinishLaunchingWithOptions: method. For more detailed MaaSCore installation instructions, please see: https://github.com/phunware/maas-core-ios-sdk#installation

````objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // These values can be found for your application in the MaaS portal.
    [MaaSCore setApplicationID:@"APPLICATION_ID"
    			  setAccessKey:@"ACCESS_KEY"
                  signatureKey:@"SIGNATURE_KEY"
                 encryptionKey:@"ENCRYPT_KEY"]; // Currently unused. You can place any NSString value here.
    ...
}
````

As of PWAlerts v1.3.1, the *application developer* is responsible with registering for remote notifications with Apple. The following code (or something like it) should be present in the application delegate or when the developer wants to register for remote notifications:

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

Apple has three primary methods for handling remote notifications. You will need to implement these in your application delegate, forwarding the results to PWAlerts:

````objective-c
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    [PWAlerts didRegisterForRemoteNotificationsWithDeviceToken:devToken];
    ...
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    [PWAlerts didFailToRegisterForRemoteNotificationsWithError:err];
    ...
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PWAlerts didReceiveRemoteNotification:userInfo];
    ...
}
````

For a complete example, see https://github.com/phunware/maas-alerts-ios-sdk/tree/master/Sample



Alert Segments
--------------

The MaaS portal provides the ability to set up alert segments for filtered alerts and notifications. There are two PWAlerts SDK methods that facilitate this: *getAlertSegmentsWithSuccess:failure:* and *updateAlertSegments:success:failure:*.

````objective-c
// Fetch an array of the available subscriptions.
[PWAlerts getAlertSegmentsWithSuccess:^(NSArray *segments) {
        // Display the available alert segments to the user.
        // The segments array will contain PWAlertSegment objects.
    } failure:^(NSError *error) {
		// Handle error.
    }];
    
    
// To update the alert segments, make the following call:
NSArray *alertSegments = @[segmentOne, segmentFour, ...];
[PWAlerts updateAlertSegments:alertSegments success:^{
        // Handle success.
    } failure:^(NSError *error) {
        // Handle error.
    }];
}
````

The alert segments are represented by PWAlertSegment objects. These objects have a name (NSString), an identifier (NSString), a subscription flag and an array of child segments. When updating alert segment subscriptions, the subscription flag should be set or cleared on each segment as needed. Segments not passed will be treated as unsubscribed. The developer no longer has to maintain a list of subscribed alert segments as the SDK now does that automatically.

*NOTE*: Please use the new methods above for managing alert segments as the following methods have been deprecated:
- getSubscriptionGroupsWithSuccess:failure:
- subscribeToGroupsWithIDs:success:failure:


Push Notification Metadata
--------

Fetching metadata associated with a push notification using PWAlerts can be done by using: *getExtraInformationForAlert:success:failure:* 

````objective-c
// When receiving a notification, you can save save the data in a PWAlert object.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PWAlerts didReceiveRemoteNotification:userInfo];
    
    PWAlert *alert = [PWAlert alloc] initWithNotificationUserInfo:userInfo];
    ...
}

// Pass the PWAlert object to retrieve extra information.
[PWAlerts getExtraInformationForAlert:alert success:^(NSDictionary *extraInformation) {
        // Process the extra information.
    } failure:^(NSError *error) {
        // Handle error.
    }];
````
