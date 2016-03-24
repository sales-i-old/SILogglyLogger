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
@property (nonatomic, assign) SILogglyLogLevel minimumLogLevel;
@property (nonatomic, assign) NSUInteger postLogIntervalTime;
+ (SILogger *)initWithKey:(NSString *)logglyKey tags:(NSArray *)tags;
+ (void)log:(NSString *)logString;
+ (void)log:(NSString *)logString level:(SILogglyLogLevel)level;
+ (void)logWithFormat:(SILogglyFormatter *)formatter;
+ (void)log:(NSString *)logString formatter:(SILogglyFormatter *)formatter;
@end
