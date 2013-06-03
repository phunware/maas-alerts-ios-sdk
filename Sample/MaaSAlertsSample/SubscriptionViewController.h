//
//  SubscriptionViewController.h
//  MaaSAlertsSample
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MaaSAlerts/MaaSAlerts.h>

@interface SubscriptionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    __weak UITableView *_tableView;
    
    NSMutableArray *_subscriptions;
    NSArray *_subscriberGroups;
}

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *subscriptions;
@property (nonatomic, strong) NSArray *subscriberGroups;

@end
