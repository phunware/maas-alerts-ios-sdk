//
//  PWDiagnosticsController.m
//  PWAlertsSample
//
//  Created by Sam Odom on 4/10/14.
//  Copyright (c) 2014 Phunware, Inc. All rights reserved.
//

#import <MaaSCore/MaaSCore.h>
#import <PWAlerts/PWAlerts.h>

#import "PWDiagnosticsController.h"


@implementation PWDiagnosticsController

#pragma mark - Actions

- (void)refresh:(id)sender {
    self.textView.text = [NSString stringWithFormat:@"MaaS Application ID:\n%@\n\nDevice Token:\n%@\n\nDevice ID:\n%@\n\n", [MaaSCore applicationID], [PWAlerts APNSToken], [MaaSCore deviceID]];
}

- (void)email:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
        mailComposer.mailComposeDelegate = self;
        
        [mailComposer setSubject:@"PWAlerts Information"];
        [mailComposer setMessageBody:self.textView.text isHTML:NO];
        
        [self presentViewController:mailComposer animated:YES completion:nil];
    }
    else {
        UIAlertView *noMailAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to send mail." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noMailAlert show];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (error) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorAlert show];
    }
}

#pragma mark - View

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refresh:nil];
}

@end
