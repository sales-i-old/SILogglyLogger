//
//  SILogglyFormatter.m
//  SILogglyLogger
//
//  Created by Dillon Hoa on 23/03/2016.
//  Copyright © 2016 sales-i. All rights reserved.
//

#import "SILogglyFormatter.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>

@implementation SILogglyFormatter

- (id)init {
    if ((self = [super init])) {
        _customFields = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSString *)timestamp {
    return [SILogglyFormatter iso8601StringFromDate:[NSDate date]];
}

- (NSString *)appVersion {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}

- (NSString *)appBuildNumber {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}

- (NSString *)deviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

- (NSString *)osVersion {
    return [[UIDevice currentDevice] systemVersion];
}

#pragma mark output methods

- (NSDictionary *)toDictionary {
    NSMutableDictionary *baseDict = [NSMutableDictionary dictionaryWithDictionary:@{
                                    @"timestamp"        :   [self timestamp],
                                    @"appVersion"       :   [self appVersion],
                                    @"appBuildNumber"   :   [self appBuildNumber],
                                    @"deviceModel"      :   [self deviceModel],
                                    @"osVersion"        :   [self osVersion]
                                    }];
    if (_message)
        [baseDict addEntriesFromDictionary:@{@"message" : _message}];
    if (_customFields)
        [baseDict addEntriesFromDictionary:_customFields];
    
    return baseDict;
}

- (NSString *)toString {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self toDictionary]
                                                       options:0
                                                         error:&error];
    if (error){
        NSAssert(false, @"Unable to convert dictionary to JSON, returning empty string");
        return @"";
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark class methods

+ (NSString *)iso8601StringFromDate:(NSDate *)date {
    struct tm *timeinfo;
    char buffer[80];
    
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    time_t rawtime = (time_t)timeInterval;
    timeinfo = gmtime(&rawtime);
    NSMutableString *format = [NSMutableString stringWithString:@"%Y-%m-%dT%H:%M:%S"];
    [format appendString:[[NSString stringWithFormat:@"%.3lfZ", timeInterval - rawtime] substringFromIndex:1]];
    strftime(buffer, 80, [format cStringUsingEncoding:NSUTF8StringEncoding], timeinfo);
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}
@end
