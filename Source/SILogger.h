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
+ (SILogger *)initWithKey:(NSString *)logglyKey;
+ (void)log:(NSString *)logString;
+ (void)log:(NSString *)logString withFormatter:(SILogglyFormatter *)formatter;
@end