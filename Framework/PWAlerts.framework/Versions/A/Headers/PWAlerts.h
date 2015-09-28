//
//  PWAlerts.h
//  PWAlerts
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PWAlerts/PWAlert.h>
#import <PWAlerts/PWAlertSegment.h>
#import <PWAlerts/PWAlertsVersion.h>

/**
 `PWAlerts` enables easy implementation of alerts and notifications. It encapsulates advanced push features like subscriber groups and the ability to fetch extra information related to a push notification.
 
 ## Alert Segments
 
 `PWAlerts` allows you to provide users with a hierarchy of alert segments from which one or more filtered alerts and notifications can be received. There are two methods that facilitate this: `getAlertSegmentsWithSuccess:failure:` and `updateAlertSegments:success:failure:`.
 
 ## Development
 
 During the development of your application, you may want to utilize Apple's push notification sandbox. To enable development mode for PWAlerts, would call `[PWAlerts setDevelopmentModeEnabled:YES]`. If you omit this call, PWAlerts will default to Apple's production push notification system.
 */

extern NSString *__nonnull const kPWAlertsDeepLinkURL;

typedef void (^PWAlertsSegmentSuccess)(NSArray *__nonnull segments);
typedef void (^PWAlertsSegmentFailure)(NSError *__nonnull error);

@interface PWAlerts : NSObject

///-----------------------
/// @name Required Methods
///-----------------------

/**
 Call this inside `application:didRegisterForRemoteNotificationsWithDeviceToken:`.
 
 @param devToken A token that identifies the device to Apple Push Notification service (APNS). The provider needs the token to be an opaque data type in order to submit it to the APNs servers when sending a notification to a device. For performance reasons, the APNs servers require a binary format.
 */
+ (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *__nonnull)devToken;

/**
 Call this inside `application:didFailToRegisterForRemoteNotificationsWithError:`.
 
 @param error An NSError object that encapsulates information explaining why registration did not succeed. The application can display this information to the user.
 */
+ (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *__nonnull)error;

/**
 Called inside `application:didReceiveRemoteNotification:`. This method assumes all notifications received were opened by the user and triggers a push analytics payload.
 
 @param userInfo A dictionary that contains information related to the remote notification (specifically, a badge number for the application icon, a notification identifier and possibly custom data). The provider originates it as a JSON-defined dictionary that AppKit converts to an NSDictionary object. The dictionary may contain only property-list objects plus NSNull.
 */
+ (void)didReceiveRemoteNotification:(NSDictionary *__nonnull)userInfo;

/**
 Called to explicitly trigger a push analytics event. This method should only be called when the user consumes a push notification.

 @param pushID The remote notification pushID. The pushID can be found in the `application:didReceiveRemoteNotification:` userInfo, `[userInfo objectForKey:@"pid"].
 */
+ (void)didReceiveRemoteNotificationForPushID:(NSString *__nonnull)pushID;

///--------------------------
/// @name Alert Segments
///--------------------------

/**
 Get list of all alert segments and their current subscription status.
 
 @param success A block object to be executed when `getAlertSegmentsWithSuccess:failure:` succeeds. This block has no return value and takes one argument: the alert segments received from the server (an `NSArray` object that contains the alert segments as `PWAlertSegment` objects).
 @param failure A block object to be executed when `getAlertSegmentsWithSuccess:failure:` fails.This block has no return value and takes one argument: an NSError object describing the error that occurred.
 @discussion This method replaces the deprecated method `getSubscriptionGroupsWithSuccess:failure:`.
 */

+ (void)getAlertSegmentsWithSuccess:(__nullable PWAlertsSegmentSuccess)success failure:(__nullable PWAlertsSegmentFailure)failure;

/**
 Update the alert segment subscriptions.
 
 @param segments An array of one or more `PWAlertSegment` objects that represent the alert subscriptions.
 @param success A block object to be executed when `updateAlertSegments:success:failure` succeeds. This block has no return value and takes no arguments.
 @param failure A block object to be executed when `updateAlertSegments:success:failure:` fails. This block has no return value and takes one argument: an `NSError` object describing the error that occurred.
 @discussion This method replaces the deprecated method `subscribeToGroupsWithIDs:success:failure:`. It's very important that you always pass back all known PWAlertSegment objects as this method will subscribe to all `PWAlertSegments` objects marked for subscription and unsubscribe from all other segments.
 */

+ (void)updateAlertSegments:(NSArray *__nonnull)segments success:(void(^__nullable)())success failure:(__nullable PWAlertsSegmentFailure)failure;

///--------------------
/// @name Other Methods
///--------------------

/**
 Get extra push information associated for the specified alert.
 
 @param alert The alert for which extra information is requested.
 @param success A block object to be executed when `getExtraInformationForAlert:success:failure:` succeeds. This block has no return value and takes one argument: the extra information received from the server. The return object will always be an `NSDictionary`.
 @param failure A block object to be executed when `getExtraInformationForAlert:success:failure:` fails. This block has no return value and takes one argument: an `NSError` object describing the error that occurred.
 */
+ (void)getExtraInformationForAlert:(PWAlert *__nonnull)alert success:(void(^__nullable)(NSDictionary *__nonnull extraInformation))success failure:(void (^__nullable)(NSError *__nonnull error))failure;

/**
 Returns 'MaaSAlerts'.
 */
+ (NSString *__nonnull)serviceName;

/**
 Returns the Apple Push Notification service (APNs) token. Call this after `didRegisterForRemoteNotificationsWithDeviceToken:`.
 @discussion Calling this method prior to registering for remote notifications will return `nil`.
 */
+ (NSString *__nullable)APNSToken;

/**
 Optionally called inside `application:didFinishLaunchingWithOptions:`. By default, your application will use Apple's production push notification servers. If you would like to use the sandbox push notificiation servers, call `[PWAlerts setDevelopmentModeEnabled:YES]`. Note that even if development mode is enabled, push notifications will not work in the simulator.
 
 @param enabled A Boolean variable that indicates whether push development mode is enabled.
 */
+ (void)setDevelopmentModeEnabled:(BOOL)enabled;

/**
 Checks push opt-in status.
 */
+ (BOOL) isOptIn __deprecated_msg("Use +alertsEnabled instead");

/**
 A Boolean value indicating whether Phunware alerts are enabled on the device.
 @discussion Alerts are enabled by default. Developers can opt-out of Phunware remote notifications by calling `[PWAlerts disableAlerts]`. Developers can opt back in to Phunware alerts by calling `[PWAlerts enableAlerts]`.
 */
+ (BOOL)alertsEnabled;

/**
 */
+ (void)enableAlerts;

/**
 
 */
+ (void)disableAlerts;

@end
