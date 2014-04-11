//
//  PWDiagnosticsController.h
//  PWAlertsSample
//
//  Created by Sam Odom on 4/10/14.
//  Copyright (c) 2014 Phunware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface PWDiagnosticsController : UIViewController <MFMailComposeViewControllerDelegate>

@property (weak) IBOutlet UITextView *textView;

- (IBAction)refresh:(id)sender;
- (IBAction)email:(id)sender;

@end
