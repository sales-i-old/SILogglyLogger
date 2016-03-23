//
//  LogglyEndPointHandler.m
//  SILogglyLogger
//
//  Created by Dillon Hoa on 23/03/2016.
//  Copyright © 2016 sales-i. All rights reserved.
//

#import "LogglyEndPointHandler.h"
@implementation LogglyEndPointHandler
- (NSURL *)urlWithKey:(NSString *)key tags:(NSString *)tags {
    NSString *urlString = [NSString stringWithFormat:@"https://logs-01.loggly.com/bulk/%@",key];
    if (tags)
        [urlString stringByAppendingString:[NSString stringWithFormat:@"/tag/%@/",tags]];
    return [NSURL URLWithString:urlString];
}
@end
