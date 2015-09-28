//
//  PWAlertSegment.h
//  PWAlerts
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `PWAlertSegment` encapsulates all of the information related to an alert segment. This includes the name, identifier, child segments and subscription flag.
 */

@interface PWAlertSegment : NSObject <NSCoding>

/**
 An `NSString` value that represents the readable name of an alert segment.
 */

@property (strong, readonly) NSString *name;

/**
 An `NSString` value that represents the unique identifier of an alert segment.
 */

@property (strong, readonly) NSString *identifier;

/**
 A `BOOL` value that represents the current or desired subscription state of the alert segment.
 */

@property (getter = isSubscribed) BOOL subscribed;

/**
 An `NSArray` value that represents the child alert segment objects nested under the given alert segment.
 */

@property (strong, readonly) NSArray *segments;


@end
