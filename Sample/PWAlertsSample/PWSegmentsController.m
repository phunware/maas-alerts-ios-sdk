//
//  PWSegmentsController.m
//  PWAlertsSample
//
//  Created by Sam Odom on 4/10/14.
//  Copyright (c) 2014 Phunware, Inc. All rights reserved.
//

#import <PWAlerts/PWAlerts.h>

#import "PWSegmentsController.h"

#import "PWSegmentCell.h"
#import "PWLogger.h"

@implementation PWSegmentsController

#pragma mark - Segments

- (void)fetchAlertSegments {
    [PWAlerts getAlertSegmentsWithSuccess:^(NSArray *segments) {
        [PWLogger log:[NSString stringWithFormat:@"%s: %@", __PRETTY_FUNCTION__, segments]];
        self.alertSegments = segments;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert Segments" message:@"Failed To Receive" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [PWLogger log:[NSString stringWithFormat:@"%s: %@", __PRETTY_FUNCTION__, error]];
    }];
}

- (void)updateAlertSegments {
    [PWAlerts updateAlertSegments:self.alertSegments success:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert Segments" message:@"Update Successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [PWLogger log:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    } failure:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert Segments" message:@"Failed To Update" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [PWLogger log:[NSString stringWithFormat:@"%s: %@", __PRETTY_FUNCTION__, error]];

    }];
}

- (void)segmentStatusChanged:(id)sender {
    UISwitch *toggle = (UISwitch*) sender;
    CGPoint toggleCenter = [self.tableView convertPoint:toggle.center fromView:toggle.superview];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:toggleCenter];
    PWAlertSegment *segment = self.alertSegments[path.row];
    segment.subscribed = toggle.isOn;
}

#pragma mark - Actions

- (void)refresh:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self fetchAlertSegments];
}

- (void)update:(id)sender {
    [self updateAlertSegments];
}

#pragma mark - Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger) self.alertSegments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PWAlertSegment *segment = self.alertSegments[indexPath.row];
    PWSegmentCell *cell = (PWSegmentCell*) [tableView dequeueReusableCellWithIdentifier:@"AlertSegmentCell"];
    cell.label.text = segment.name;
    cell.toggle.on = segment.isSubscribed;
    cell.accessoryType = segment.segments.count ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    PWAlertSegment *segment = self.alertSegments[indexPath.row];
    return segment.segments.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PWAlertSegment *segment = self.alertSegments[indexPath.row];
    if (segment.segments.count) {
        PWSegmentsController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AlertSegmentsController"];
        controller.alertSegments = segment.segments;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - View

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.navigationController.childViewControllers firstObject] != self) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
    else if (!self.alertSegments) {
        [self fetchAlertSegments];
    }
}

@end
