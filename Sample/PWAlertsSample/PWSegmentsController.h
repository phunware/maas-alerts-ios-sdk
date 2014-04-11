//
//  PWSegmentsController.h
//  PWAlertsSample
//
//  Created by Sam Odom on 4/10/14.
//  Copyright (c) 2014 Phunware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWSegmentsController : UITableViewController

@property (strong) NSArray *alertSegments;

- (IBAction)refresh:(id)sender;
- (IBAction)update:(id)sender;
- (IBAction)segmentStatusChanged:(id)sender;

@end
