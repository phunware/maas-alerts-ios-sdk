//
//  SubscriptionViewController.m
//  MaaSAlertsSample
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import "SubscriptionViewController.h"

#import "PWLogger.h"

#define kSUBSCRIBE_SWITCH_TAG   10000
#define kSUBSCRIPTIONS          @"com.phunware.maassample.subscriptions"

@interface SubscriptionViewController ()

@end

@implementation SubscriptionViewController

@synthesize tableView = _tableView,
            subscriptions = _subscriptions,
            subscriberGroups = _subscriberGroups;

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *savedSubscriptions = [[NSUserDefaults standardUserDefaults] objectForKey:kSUBSCRIPTIONS];
    
    if (savedSubscriptions !=  nil)
    {
        self.subscriptions = savedSubscriptions.mutableCopy;
    }
    else
    {
        self.subscriptions = @[].mutableCopy;
    }
    
    self.subscriberGroups = @[].mutableCopy;
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, 320, 60)];
    buttonView.center = CGPointMake(self.view.center.x, 30);
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setFrame:CGRectMake(8, 8, 148, 45)];
    [refreshButton addTarget:self action:@selector(fetchSubscriberGroups) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
    [refreshButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateHighlighted];
    [refreshButton setBackgroundColor:[UIColor colorWithRed:0 green:182/255.0f blue:235/255.0f alpha:1]];
    
    [buttonView addSubview:refreshButton];
    
    
    UIButton *subscribeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [subscribeButton setFrame:CGRectMake(8 + 8 + 148, 8, 148, 45)];
    [subscribeButton addTarget:self action:@selector(updateSubscriptions) forControlEvents:UIControlEventTouchUpInside];
    [subscribeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [subscribeButton setTitle:@"Update" forState:UIControlStateNormal];
    [subscribeButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateHighlighted];
    [subscribeButton setBackgroundColor:[UIColor colorWithRed:0 green:182/255.0f blue:235/255.0f alpha:1]];
    
    [buttonView addSubview:subscribeButton];
    
    [self.view addSubview:buttonView];
    
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 45 + 8, self.view.frame.size.width, self.view.frame.size.height - 53 - 49) style:UITableViewStylePlain];
    [table setDelegate:self];
    [table setDataSource:self];
    
    [self.view addSubview:table];
    self.tableView = table;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self fetchSubscriberGroups];
}


#pragma mark - Memory Management

- (void)dealloc
{
    
}


#pragma mark - Network

- (void)fetchSubscriberGroups
{
    __weak __typeof(&*self)weakSelf = self;
    
    [MaaSAlerts getSubscriptionGroupsWithSuccess:^(NSArray *groups) {
        [PWLogger log:[NSString stringWithFormat:@"%s: %@", __PRETTY_FUNCTION__, groups]];
        weakSelf.subscriberGroups = groups;
        [weakSelf.tableView reloadData];
        
        NSLog(@"%@", self.subscriberGroups);
        
    } failure:^(NSError *error) {
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Subscription Groups" message:@"Failed To Receive" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [a show];
        
        [PWLogger log:[NSString stringWithFormat:@"%s: %@", __PRETTY_FUNCTION__, error]];
    }];
}


#pragma mark - User Actions

- (void)updateSubscriptions
{
    // Post subscribed groups
    [MaaSAlerts subscribeToGroupsWithIDs:self.subscriptions success:^{
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Subscription Groups" message:@"Subscribe Successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [a show];
        
        [PWLogger log:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    } failure:^(NSError *error) {
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Subscription Groups" message:@"Failed To Receive" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [a show];
        
        [PWLogger log:[NSString stringWithFormat:@"%s: %@", __PRETTY_FUNCTION__, error]];
    }];
}

- (void)subscriptionStatusChanged:(UISwitch *)subscribeSwitch
{
    NSInteger subscriptionIndex = subscribeSwitch.tag - kSUBSCRIBE_SWITCH_TAG;
    NSDictionary *subscriptionInfo = [self.subscriberGroups objectAtIndex:subscriptionIndex];
    NSString *subscriptionID = [subscriptionInfo objectForKey:@"id"];
    BOOL subscribed = subscribeSwitch.on;
    
    if (subscribed == YES)
    {
        [self.subscriptions addObject:subscriptionID];
    }
    else
    {
        [self.subscriptions removeObject:subscriptionID];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.subscriptions forKey:kSUBSCRIPTIONS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - UITableView Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UISwitch *groupSwitch = nil;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        groupSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [groupSwitch addTarget:self action:@selector(subscriptionStatusChanged:) forControlEvents:UIControlEventValueChanged];
        [cell setAccessoryView:groupSwitch];
    }
    else
    {
        groupSwitch = (UISwitch *)cell.accessoryView;
    }
    
    NSDictionary *group = [self.subscriberGroups objectAtIndex:indexPath.row];
    NSString *subscriptionID = [group objectForKey:@"id"];
    NSString *subscriptionGroupName = [group objectForKey:@"name"];
    
    cell.textLabel.text = subscriptionGroupName;
    cell.detailTextLabel.text = subscriptionID;
    
    [groupSwitch setTag:kSUBSCRIBE_SWITCH_TAG + indexPath.row];
    
    if ([self.subscriptions containsObject:subscriptionID])
    {
        [groupSwitch setOn:YES];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_subscriberGroups count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


@end
