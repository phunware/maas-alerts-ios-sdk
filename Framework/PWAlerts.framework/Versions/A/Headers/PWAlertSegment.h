//
//  PWAlertSegment.h
//  PWAlerts
//
//  Created by Sam Odom on 4/7/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `PWAlertSegment` encapsulates all of the information related to an alert segment.  This includes the name, identifier, child segments and subscription flag.
 */

@interface PWAlertSegment : NSObject <NSCoding>

/**
 An `NSString` value that represents the readable name of an alert segment.
 */

@property (readonly) NSString *name;

/**
 An `NSString` value that represents the unique identifier of an alert segment.
 */

@property (readonly) NSString *identifier;

/**
 A `BOOL` value that represents the current or desired subscription state of the alert segment.
 */

@property (nonatomic, getter = isSubscribed) BOOL subscribed;

/**
 An `NSArray` value that represents the child alert segment objects nested under the given alert segment.
 */

@property (readonly) NSArray *segments;


@end
