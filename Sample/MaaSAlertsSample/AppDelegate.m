//
//  AppDelegate.m
//  MaaSAlertsSample
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import "AppDelegate.h"

#import "InfoViewController.h"
#import "SubscriptionViewController.h"
#import "ConsoleViewController.h"

#import "PWLogger.h"

@implementation AppDelegate

@synthesize window;


#pragma mark - Memory Management

- (void)dealloc
{
    
}


#pragma mark - Application Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Clear the notification center and all local notification
    [self clearNotificationCenter];
    
    // Initialize MaaSCore with your credentials
    [MaaSCore setApplicationID:@"14"
                     accessKey:@"6b361d18846e5f5ccc1ae619ff713473733856a8"
                  signatureKey:@"1d470cd175c93aadc7fa891962532e3f7c3c3106"
                 encryptionKey:@"nada"];
    
    // Set the log level to debug so we can see what's going on
    [MaaSCore setLoggingLevel:MaaSLogLevel_Debug forService:[MaaSAlerts serviceName]];
    
    // Setup our application
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0 green:182/255.0f blue:235/255.0f alpha:1]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    InfoViewController *info = [InfoViewController new];
    UITabBarItem *infoTab = [[UITabBarItem alloc] initWithTitle:@"Info" image:[UIImage imageNamed:@"info"] tag:0];
    info.tabBarItem = infoTab;
    
    SubscriptionViewController *subscription = [SubscriptionViewController new];
    UITabBarItem *subscriptionTab = [[UITabBarItem alloc] initWithTitle:@"Subscriptions" image:[UIImage imageNamed:@"subscriptions"] tag:1];
    subscription.tabBarItem = subscriptionTab;
    
    ConsoleViewController *console = [ConsoleViewController new];
    UITabBarItem *consoleTab = [[UITabBarItem alloc] initWithTitle:@"Console" image:[UIImage imageNamed:@"console"] tag:1];
    console.tabBarItem = consoleTab;
    
    UITabBarController *tabBar = [[UITabBarController alloc] init];
    tabBar.viewControllers = @[info, subscription, console];
    
    self.window.rootViewController = tabBar;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Clear the notification center and all local notification
    [self clearNotificationCenter];
}


#pragma mark - Apple Push Methods

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    [MaaSAlerts didRegisterForRemoteNotificationsWithDeviceToken:devToken];
    [PWLogger log:[NSString stringWithFormat:@"didRegisterForRemoteNotificationsWithDeviceToken %@", devToken]];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    [MaaSAlerts didFailToRegisterForRemoteNotificationsWithError:err];
    [PWLogger log:[NSString stringWithFormat:@"didFailToRegisterForRemoteNotificationsWithError %@", err]];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self clearNotificationCenter];
    [MaaSAlerts didReceiveRemoteNotification:userInfo];
    [PWLogger log:[NSString stringWithFormat:@"didReceiveRemoteNotification: %@", userInfo]];
    
    NSString *message = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"MaaSAlerts" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [a show];
}


#pragma mark - Convenience

- (void)clearNotificationCenter
{
    int badgeCount = [UIApplication sharedApplication].applicationIconBadgeNumber;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeCount + 1];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeCount];
}


@end
