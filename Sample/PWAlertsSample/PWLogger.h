//
//  PWLogger.h
//  PWAlertsSample
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWLogger : NSObject
{
    NSString *log_;
}

@property (nonatomic, strong) NSString *log;

+ (void)log:(NSString *)string;
+ (NSString *)log;
+ (void)clear;

@end
