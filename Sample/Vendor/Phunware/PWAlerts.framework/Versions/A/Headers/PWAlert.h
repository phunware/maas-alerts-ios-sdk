//
//  PWAlert.h
//  PWAlerts
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSInteger const kPWAlertsInvalidAlertID;

/**
 A `PWAlert` object encapsulates all information related to an alert. This includes but is not limited to: the message, the alert ID and the payload dictionary.
 */

@interface PWAlert : NSObject <NSCoding, NSCopying>

/**
 An `NSString` value that represents the alert message.
 */
@property (strong, readonly) NSString *message;

/**
 An `NSInteger` value that represents the alert ID.
 */
@property (readonly) NSInteger alertID;

/**
 An `NSDictionary` value that represents the payload used to initialize the `PWAlert` object. You can use this payload to fetch custom arguments.
 */
@property (strong, readonly) NSDictionary *payload;

/**
 Initializes a `PWAlert` object. You can only initialize a `PWAlert` object with a valid userInfo dictionary.
 
 @param userInfo The userInfo that encapsulates the notification. This is fetched from the following locations:
 
 - `application:didReceiveRemoteNotification:` passed a userInfo `NSDictionary`. You can use this dictionary to instantiate a `PWAlert` object.
 - `application:didFinishLaunchingWithOptions:` may have a `UIApplicationLaunchOptionsRemoteNotificationKey` if the application was launched through a push notification. You can extract the userInfo from the launchOptions `NSDictionary` using the aformentioned key.
 */
- (instancetype)initWithNotificationUserInfo:(NSDictionary *)userInfo;



@end
