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
        _logLevel = LogglyInfo;
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSString *iso8601String = [dateFormatter stringFromDate:date];
    return iso8601String;
}
@end
