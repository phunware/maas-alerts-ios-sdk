//
//  PWAlerts.h
//  PWAlerts
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PWAlerts/PWAlert.h>
#import <PWAlerts/PWAlertSegment.h>

/**
  `PWAlerts` enables easy implementation of alerts and notifications. It encapsulates advanced push features such as subscriber groups and fetching extra information related to a push notification.
 
 ## Alert Segments
 
 PWAlerts provides the ability to provide users with a hierarchy of alert segments from which one or more filtered alerts and notifications can be received. There are two methods that facilitate this: `getAlertSegmentsWithSuccess:failure:` and `updateAlertSegments:success:failure:`.
 
 ## Development
 
 During the development of your application, you may want to utilize Apple's push notification sandbox. To enable development mode for PWAlerts you would call `[PWAlerts setDevelopmentModeEnabled:YES]`. If you omit this call, PWAlerts will default to Apple's production push notification system.
 */

extern NSString *const kPWAlertsDeepLinkURL;

typedef void (^PWAlertsSegmentSuccess)(NSArray *segments);
typedef void (^PWAlertsSegmentFailure)(NSError *error);

@interface PWAlerts : NSObject

///-----------------------
/// @name Required Methods
///-----------------------

/**
 Call inside `application:didRegisterForRemoteNotificationsWithDeviceToken:`
 
 @param devToken A token that identifies the device to Apple Push Notification Service (APNS). The token is an opaque data type because that is the form that the provider needs to submit to the APNS servers when it sends a notification to a device. For performance reasons, the APNS servers require a binary format.
 */
+ (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken;

/**
 Call inside `application:didFailToRegisterForRemoteNotificationsWithError:`
 
 @param error An NSError object that encapsulates information that explains why registration did not succeed. The application can display this information to the user.
 */
+ (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

/**
 Called inside `application:didReceiveRemoteNotification:`. This method assumes all notifications received were opened by the user and triggers a push analytics payload.
 
 @param userInfo A dictionary that contains information related to the remote notification (specifically, a badge number for the application icon, a notification identifier and possibly custom data). The provider originates it as a JSON-defined dictionary that AppKit converts to an NSDictionary object. The dictionary may contain only property-list objects plus NSNull.
 */
+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

/**
 Called when you want to explicitly trigger a push analytics event. This method should only be called when the user consumes a push notification.

 @param pushID The remote notification pushID. The pushID can be found in the `application:didReceiveRemoteNotification:` userInfo, `[userInfo objectForKey:@"pid"].
 */
+ (void)didReceiveRemoteNotificationForPushID:(NSString *)pushID;

///--------------------------
/// @name Alert Segments
///--------------------------

/**
 Get list of all alert segments and and their current subscription status.
 
 @param success A block object to be executed when `getAlertSegmentsWithSuccess:failure:` succeeds.  This block has no return value and takes on argument: the alert segments received from the server (an `NSArray` object that contains the alert segments as `PWAlertSegment` objects.
 @param failure A block object to be executed when `getAlertSegmentsWithSuccess:failure:` fails.  This block has no return value and takes one argument: an NSError object describing the error that occurred.
 @discussion This method replaces the deprecated method `getSubscriptionGroupsWithSuccess:failure:`.
 */

+ (void)getAlertSegmentsWithSuccess:(PWAlertsSegmentSuccess)success failure:(PWAlertsSegmentFailure)failure;

/**
 Update the alert segment subscriptions.
 
 @param segments An array of one or more `PWAlertSegment` objects that represent the alert subscriptions.
 @param success A block object to be executed when `updateAlertSegments:success:failure` succeeds.  This block has no return value and takes no arguments.
 @param failure A block object to be executed when `updateAlertSegments:success:failure:` fails.  This block has no return value and takes one argument: an `NSError` object describing the error that occurred.
 @discussion This method replaces the deprecated method `subscribeToGroupsWithIDs:success:failure:`. It's very important that you always pass back all known PWAlertSegment objects as this method will subscribe to all `PWAlertSegments` objects that are marked for subscription and unsubscribe from all other segments.
 */

+ (void)updateAlertSegments:(NSArray *)segments success:(void(^)())success failure:(PWAlertsSegmentFailure)failure;


///--------------------------
/// @name Subscription Groups (Deprecated)
///--------------------------

/**
 Get subscription groups list. Returns an NSArray of available subscription groups or an NSError object.
 
 @param success A block object to be executed when `getSubscriptionGroupsWithSuccess:success:failure:` succeeds. This block has no return value and takes one argument: the groups received from the server (an `NSArray` object that contains the subscription groups in the following format `{@"id" : @"12", @"name" : @"Subscription group name"}`).
 @param failure A block object to be executed when `getSubscriptionGroupsWithSuccess:success:failure:` fails. This block has no return value and takes one argument: an NSError object describing the error that occurred.
  @discussion This method has been deprecated. Please use `getAlertSegmentsWithSuccess:failure:`.
 */
+ (void)getSubscriptionGroupsWithSuccess:(void (^)(NSArray *groups))success failure:(void (^)(NSError *error))failure __attribute__((deprecated));

/**
 Subscribe to a list of groups.
 
 @param groupIDs An array of one or more `NSString` objects that represent the group IDs being subscribed to.
 @param success A block object to be executed when `subscribeToGroupsWithIDs:success:failure:` succeeds. This block has no return value and takes no arguments.
 @param failure A block object to be executed when `subscribeToGroupsWithIDs:success:failure:` fails. This block has no return value and takes one argument: an `NSError` object describing the error that occurred.
 @discussion This method has been deprecated. Please use `updateAlertSegments:success:failure:`.
 */
+ (void)subscribeToGroupsWithIDs:(NSArray *)groupIDs success:(void(^)())success failure:(void (^)(NSError *error))failure __attribute__((deprecated));

///--------------------
/// @name Other Methods
///--------------------

/**
 Optionally called inside `application:didFinishLaunchingWithOptions:`. By default, your application will use Apple's production push notification servers. If you would like to use the sandbox push notificiation servers you would call `[PWAlerts setDevelopmentModeEnabled:YES]`. Note that even if development mode is enabled, push notifications will not work in the simulator.
 
 @param enabled A boolean variable that indicates whether or not push development mode is enabled.
 */
+ (void)setDevelopmentModeEnabled:(BOOL)enabled;

/**
 Get extra push information associated for the specified pushID. This method is deprecated and will be removed in the future. Please use `getExtraInformationForAlert:success:failure:`.
 
 @param pushID The ID of the push notification for which extra information is requested.
 @param success A block object to be executed when `getExtraInformationForPushID:success:failure:` succeeds. This block has no return value and takes one argument: the extra information received from the server. The return object will always be an `NSDictionary`.
 @param failure A block object to be executed when `getExtraInformationForPushID:success:failure:` fails. This block has no return value and takes one argument: an `NSError` object describing the error that occurred.
 */
+ (void)getExtraInformationForPushID:(NSString *)pushID success:(void(^)(NSDictionary *extraInformation))success failure:(void (^)(NSError *error))failure __attribute__((deprecated));

/**
 Get extra push information associated for the specified alert.
 
 @param alert The alert for which extra information is requested.
 @param success A block object to be executed when `getExtraInformationForAlert:success:failure:` succeeds. This block has no return value and takes one argument: the extra information received from the server. The return object will always be an `NSDictionary`.
 @param failure A block object to be executed when `getExtraInformationForAlert:success:failure:` fails. This block has no return value and takes one argument: an `NSError` object describing the error that occurred.
 */
+ (void)getExtraInformationForAlert:(PWAlert *)alert success:(void(^)(NSDictionary *extraInformation))success failure:(void (^)(NSError *error))failure;

/**
 Returns 'MaaSAlerts'.
 */
+ (NSString *)serviceName;

/**
 Checks push opt-in status.
 */
+ (BOOL)isOptIn;

/**
 Returns Apple push token. Call after `didRegisterForRemoteNotificationsWithDeviceToken:`. Calling before will return nil.
 */
+ (NSString *)APNSToken;

@end
