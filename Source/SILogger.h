//
//  SILogger.h
//  SILogglyLogger
//
//  Created by Dillon Hoa on 23/03/2016.
//  Copyright © 2016 sales-i. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SILogglyFormatter.h"

@interface SILogger : NSObject
/*
 SILogger is a singleton and used to log to Loggly. It uses LogglyEndPointHandler to store and fires the post method.
 
 @params
    minimumLogLevel - set this to determine what level it should store logs. Default LogglyWarning
    postLogIntervalTime - determines the interval between posting logs. Default 600.
 */
@property (nonatomic, assign) SILogglyLogLevel minimumLogLevel;
@property (nonatomic, assign) NSUInteger postLogIntervalTime;

// Instantiate method used to set the key and tags. Use this in didFinishLaunchingWithOptions method
+ (SILogger *)initWithKey:(NSString *)logglyKey tags:(NSArray *)tags;

+ (void)postNow;

// Various log methods, simple logging to more advanced with custom formatters.
+ (void)log:(NSString *)logString;
+ (void)log:(NSString *)logString level:(SILogglyLogLevel)level;
+ (void)logWithFormat:(SILogglyFormatter *)formatter;
+ (void)log:(NSString *)logString formatter:(SILogglyFormatter *)formatter;
@end
