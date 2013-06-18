//
//  MaaSCore.h
//  MaaSCore
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MaaSLogLevel_Undefined = -1,
    MaaSLogLevel_None, // Default
    MaaSLogLevel_Error,
    MaaSLogLevel_Warning,
    MaaSLogLevel_Info,
    MaaSLogLevel_Debug
} MaaSLogLevel;

/**
 `MaaSCore` implements core functionality used in all MaaS modules. All MaaS modules have a `MaaSCore` dependency.
 */

@interface MaaSCore : NSObject

///-----------------------
/// @name Required Methods
///-----------------------

/**
 Initializes MaaSCore and all associated MaaS modules. This method should be called inside `application:didFinishLaunchingWithOptions:` before you do anything else.
 @param applicationID You can find your application ID in MaaS Portal.
 @param accessKey A unique key that identifies the client making the request. You can find your access key in MaaS Portal.
 @param signatureKey A unique key that is used to sign requests. The signature is used to both check request authorization, as well as data integrity. You can find your signature key in MaaS Portal.
 @param encryptionKey The key used to encrypt and decrypt data that is exchanged between the client and the server. You can find your encryption key in MaaS Portal.
 */
+ (void)setApplicationID:(NSString *)applicationID
               accessKey:(NSString *)accessKey
            signatureKey:(NSString *)signatureKey
           encryptionKey:(NSString *)encryptionKey;

///---------------
/// @name Optional
///---------------

/**
 Set the console logging level for the specified MaaS module. By default the logging level for all modules is `MaaSLogLevel_None`.

 @param loggingLevel The logging level desired.
 @param serviceName The service name. Every MaaS module has a static `serviceName` method.
 */

+ (void)setLoggingLevel:(MaaSLogLevel)loggingLevel forService:(NSString *)serviceName;

/**
 Disables MaaSCore location services. Location services are used for comprehensive analytics. If you include `CoreLocation.framework` in your project MaaSCore will automatically request access to the users current location.
 */
+ (void)disableLocationServices;

/**
 Returns the MaaS application ID.
 */
+ (NSString *)applicationID;

/**
 Returns the device ID.
 */
+ (NSString *)deviceID;

/**
 Returns 'MaaSCore'.
 */
+ (NSString *)serviceName;

@end
