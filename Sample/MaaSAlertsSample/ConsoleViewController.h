//
//  ConsoleViewController.h
//  MaaSAlertsSample
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsoleViewController : UIViewController
{
    __weak UITextView *_textView;
}

@property (nonatomic, weak) UITextView *textView;

@end
