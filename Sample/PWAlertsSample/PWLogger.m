//
//  PWLogger.m
//  PWAlertsSample
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import "PWLogger.h"

@implementation PWLogger

@synthesize log = log_;

#pragma mark - Singleton

- (id)init
{
    if (self = [super init])
    {
        self.log = @"";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analyticsNotification:) name:@"com.phunware.maas.alerts.analytics" object:nil];
    }
    
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)sharedInstance
{
    static PWLogger *sharedInstance = nil;
	static dispatch_once_t onceToken;
    
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
    
	return sharedInstance;
}


#pragma mark - Logging

+ (void)log:(NSString *)string
{
    NSString *currentLogString = [PWLogger sharedInstance].log;
    
    static NSDateFormatter *sRFC3339DateFormatter;
    
    if (sRFC3339DateFormatter == nil)
    {
        NSLocale *                  enUSPOSIXLocale;
        
        sRFC3339DateFormatter = [[NSDateFormatter alloc] init];
        assert(sRFC3339DateFormatter != nil);
        
        enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        assert(enUSPOSIXLocale != nil);
        
        [sRFC3339DateFormatter setLocale:enUSPOSIXLocale];
        [sRFC3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        [sRFC3339DateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }
    
    [PWLogger sharedInstance].log = [currentLogString stringByAppendingFormat:@"%@: %@\n--------------------\n", [sRFC3339DateFormatter stringFromDate:[NSDate date]], string];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.phunware.console.log" object:nil];
}

+ (NSString *)log
{
    return [PWLogger sharedInstance].log;
}

+ (void)clear;
{
    [PWLogger sharedInstance].log = @"";
}

#pragma mark - Internal

- (void)analyticsNotification:(NSNotification *)notification
{
    NSDictionary *analyticsPayload = [notification object];
    
    [PWLogger log:analyticsPayload.description];
}

@end
