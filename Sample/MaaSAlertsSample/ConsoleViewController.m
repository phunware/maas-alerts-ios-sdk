//
//  ConsoleViewController.m
//  MaaSAlertsSample
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import "ConsoleViewController.h"

#import "PWLogger.h"

@interface ConsoleViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation ConsoleViewController

@synthesize textView = _textView;

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConsoleWithNotification:) name:@"com.phunware.console.log" object:nil];
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, 320, 60)];
    buttonView.center = CGPointMake(self.view.center.x, 30);
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setFrame:CGRectMake(8, 8, 148, 45)];
    [refreshButton addTarget:self action:@selector(clearConsole) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [refreshButton setTitle:@"Clear" forState:UIControlStateNormal];
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
    
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 45 + 8, self.view.frame.size.width, self.view.frame.size.height - 53 - 49)];
    textView.editable = NO;
    textView.font = [UIFont systemFontOfSize:14.0f];
    
    [self.view addSubview:textView];
    self.textView = textView;
    
    self.textView.text = [PWLogger log];
}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - User Actions

- (void)clearConsole
{
    [PWLogger clear];
    _textView.text = @"";
}

- (void)emailInformation
{
    if ([MFMailComposeViewController canSendMail] == YES)
    {
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        
        [mailComposer setSubject:@"MaaSAlerts Console"];
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

#pragma mark - Notification Handling

- (void)updateConsoleWithNotification:(NSNotification *)notification
{
    self.textView.text = [PWLogger log];
    
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 0)];
}

@end
