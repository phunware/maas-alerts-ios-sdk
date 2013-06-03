//
//  InfoViewController.m
//  MaaSAlertsSample
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import "InfoViewController.h"
#import <MaaSCore/MaaSCore.h>
#import <MaaSAlerts/MaaSAlerts.h>

@interface InfoViewController () <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>
{
    __weak UITextView *_textView;
}

@end


@implementation InfoViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, 320, 60)];
    buttonView.center = CGPointMake(self.view.center.x, 30);
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setFrame:CGRectMake(8, 8, 148, 45)];
    [refreshButton addTarget:self action:@selector(refreshText) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
    [refreshButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateHighlighted];
    [refreshButton setBackgroundColor:[UIColor colorWithRed:0 green:182/255.0f blue:235/255.0f alpha:1]];

    [buttonView addSubview:refreshButton];
    
    
    UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [emailButton setFrame:CGRectMake(8 + 8 + 148, 8, 148, 45)];
    [emailButton addTarget:self action:@selector(emailInformation) forControlEvents:UIControlEventTouchUpInside];
    [emailButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [emailButton setTitle:@"Email" forState:UIControlStateNormal];
    [emailButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateHighlighted];
    [emailButton setBackgroundColor:[UIColor colorWithRed:0 green:182/255.0f blue:235/255.0f alpha:1]];
    
    [buttonView addSubview:emailButton];
    
    [self.view addSubview:buttonView];

    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 45 + 8, self.view.frame.size.width, self.view.frame.size.height - 53)];
    textView.editable = NO;
    textView.font = [UIFont systemFontOfSize:16.0f];
    
    [self.view addSubview:textView];
    _textView = textView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshText];
}


#pragma mark - User Actions

- (void)refreshText
{
    _textView.text = [NSString stringWithFormat:@"MaaS Application ID:\n%@\n\nDevice Token:\n%@\n\nDevice ID:\n%@\n\n", [MaaSCore applicationID], [MaaSAlerts APNSToken], [MaaSCore deviceID]];
}

- (void)emailInformation
{
    if ([MFMailComposeViewController canSendMail] == YES)
    {
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        
        [mailComposer setSubject:@"MaaSAlerts Information"];
        [mailComposer setMessageBody:_textView.text isHTML:NO];
        
        [self presentViewController:mailComposer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *noMailAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to send mail." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noMailAlert show];
    }
}


#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (error)
    {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorAlert show];
    }
}

@end
