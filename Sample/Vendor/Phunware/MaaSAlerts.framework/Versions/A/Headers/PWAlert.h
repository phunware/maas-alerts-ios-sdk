//
//  PWAlert.h
//  MaaSAlerts
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSInteger const kPWAlertsInvalidAlertID;

/**
 `PWAlert` object encapsulates
 */

@interface PWAlert : NSObject <NSCoding, NSCopying>

/**
 An `NSString` value that identifies the alert message.
 */
@property (nonatomic, strong) NSString *message;

/**
 An `NSInteger` value that identifies the alert ID.
 */
@property (nonatomic, strong) NSString *alertID;

/**
 An `NSString` value that identifies the `NSDictionary` payload that was used to initialize the `PWAlert` object. You can use this payload to fetch custom arguments
 */
@property (nonatomic, strong) NSDictionary *payload;

/**
 Initializes a `PWAlert` object. You can only initialize a `PWAlert` object with a valid userInfo dictionary.
 
 @param userInfo The userInfo which encapsulates the notification. This is fetched from the following locations:
 
 - `application:didReceiveRemoteNotification:` passed a userInfo `NSDictionary`. You can use this dictionary to instantiate a `PWAlert` object.
 -  `application:didFinishLaunchingWithOptions:` may have a `UIApplicationLaunchOptionsRemoteNotificationKey` if the application was launched through a push notification. You can extract the userInfo from the launchOptions `NSDictionary` using the aformentioned key.
 */
- (instancetype)initWithNotificationUserInfo:(NSDictionary *)userInfo;



@end
