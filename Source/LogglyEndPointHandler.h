//
//  LogglyEndPointHandler.h
//  SILogglyLogger
//
//  Created by Dillon Hoa on 23/03/2016.
//  Copyright © 2016 sales-i. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SILogglyFormatter.h"

@interface LogglyEndPointHandler : NSObject
+ (void)addLogToQueue : (NSString *)logString;
+ (void)sendStoredLogsWithKey:(NSString *)key tags:(NSArray *)tags;
@end
