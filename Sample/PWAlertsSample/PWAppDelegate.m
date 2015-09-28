//
//  PWAppDelegate.m
//  PWAlertsSample
//
//  Created by Sam Odom on 4/10/14.
//  Copyright (c) 2014 Phunware, Inc. All rights reserved.
//

#import <PWCore/PWCore.h>
#import <PWAlerts/PWAlerts.h>

#import "PWAppDelegate.h"

#import "PWLogger.h"

@implementation PWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

#warning Update these credentials with your own from MaaS Portal
    // Initialize MaaSCore with your credentials
    [PWCore setApplicationID:@"YOUR_APPLICATION_ID"
                     accessKey:@"YOUR_ACCESS_KEY"
                  signatureKey:@"YOUR_SIGNATURE_KEY"
                 encryptionKey:@"nada"];

    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    else {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];
    }

    return YES;
}

#pragma mark - Apple Push Methods

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    [PWAlerts didRegisterForRemoteNotificationsWithDeviceToken:devToken];
    [PWLogger log:[NSString stringWithFormat:@"didRegisterForRemoteNotificationsWithDeviceToken %@", devToken]];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    [PWAlerts didFailToRegisterForRemoteNotificationsWithError:err];
    [PWLogger log:[NSString stringWithFormat:@"didFailToRegisterForRemoteNotificationsWithError %@", err]];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:nil];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self logRemoteNotificationReceipt:userInfo];
    
    [self clearNotificationCenter];
    [PWAlerts didReceiveRemoteNotification:userInfo];
    
    if (application.applicationState == UIApplicationStateActive) {
        [self displayAlert:userInfo];
    }
    
    PWAlert *alert = [[PWAlert alloc] initWithNotificationUserInfo:userInfo];
    [PWLogger log:[NSString stringWithFormat:@"PWAlert = %@", alert]];
    [self logAlert:alert];
}

- (void)logRemoteNotificationReceipt:(NSDictionary*)userInfo {
    [PWLogger log:[NSString stringWithFormat:@"didReceiveRemoteNotification: %@", userInfo]];
}

- (void)displayAlert:(NSDictionary*)userInfo {
    NSString *message = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"PWAlerts" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)logAlert:(PWAlert*)alert {
    if (alert) {
        [PWAlerts getExtraInformationForAlert:alert success:^(NSDictionary *extraInformation) {
            [PWLogger log:[NSString stringWithFormat:@"Fetched extra information for alert. Extra information: %@", extraInformation]];
        } failure:^(NSError *error) {
            [PWLogger log:[NSString stringWithFormat:@"Unable to fetch extra information for alert! -> %@", error]];
        }];
    }
    else {
        [PWLogger log:@"WARNING: PWAlert was nil! This shouldn't happen!!!"];
    }
}


#pragma mark - Convenience

- (void)clearNotificationCenter {
    UIApplication *application = [UIApplication sharedApplication];
    NSInteger badgeCount = [application applicationIconBadgeNumber];
    [application setApplicationIconBadgeNumber:badgeCount + 1];
    [application cancelAllLocalNotifications];
    [application setApplicationIconBadgeNumber:badgeCount];
}

@end
