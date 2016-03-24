//
//  SILogglyFormatter.h
//  SILogglyLogger
//
//  Created by Dillon Hoa on 23/03/2016.
//  Copyright © 2016 sales-i. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LogglyInfo = 1,
    LogglyError = 2,
    LogglyWarning = 3,
    LogglyFatal = 4
} SILogglyLogLevel;

@interface SILogglyFormatter : NSObject
@property (nonatomic, readonly) NSString *timestamp;
@property (nonatomic, readonly) NSString *appVersion;
@property (nonatomic, readonly) NSString *appBuildNumber;
@property (nonatomic, readonly) NSString *deviceModel;
@property (nonatomic, readonly) NSString *osVersion;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) SILogglyLogLevel logLevel;
@property (nonatomic, strong) NSMutableDictionary *customFields;

@property (nonatomic, readonly) NSDictionary *toDictionary;
@property (nonatomic, readonly) NSString *toString;
@end
