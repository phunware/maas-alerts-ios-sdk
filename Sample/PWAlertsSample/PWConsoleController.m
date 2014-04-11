//
//  PWConsoleController.m
//  PWAlertsSample
//
//  Created by Sam Odom on 4/10/14.
//  Copyright (c) 2014 Phunware, Inc. All rights reserved.
//

#import "PWConsoleController.h"

#import "PWLogger.h"

@implementation PWConsoleController

#pragma mark - Actions

- (void)clear:(id)sender {
    [PWLogger clear];
    self.textView.text = nil;
}

- (void)email:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        
        [mailComposer setSubject:@"PWAlerts Console"];
        [mailComposer setMessageBody:self.textView.text isHTML:NO];
        
        [self presentViewController:mailComposer animated:YES completion:nil];
    }
    else {
        UIAlertView *noMailAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to send mail." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noMailAlert show];
    }
}

#pragma mark - Notification

- (void)updateConsoleWithNotification:(NSNotification*)notification {
    self.textView.text = [PWLogger log];
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 0)];
}

#pragma mark - Messaging

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (error) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorAlert show];
    }
}

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConsoleWithNotification:) name:@"com.phunware.console.log" object:nil];
    self.textView.text = [PWLogger log];
}

#pragma mark - Other

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
