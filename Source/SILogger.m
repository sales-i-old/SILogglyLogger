//
//  SILogger.m
//  SILogglyLogger
//
//  Created by Dillon Hoa on 23/03/2016.
//  Copyright © 2016 sales-i. All rights reserved.
//

#import "SILogger.h"

@interface SILogger()
@property (nonatomic, strong) NSMutableArray *logMessages;
@end

@implementation SILogger
static SILogger *sharedInstance = nil;
static NSString *key = nil;


+ (SILogger *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}
+ (id)allocWithZone:(NSZone*)zone {
    return [self sharedInstance];
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)init
{
    if ((self = [super init])) {
        _logMessages = [NSMutableArray array];
    }
    return self;
}

#pragma mark init method

+ (SILogger *)initWithKey:(NSString *)logglyKey {
    SILogger *logger = [SILogger sharedInstance];
    key = logglyKey;
    return logger;
}

+ (void)log:(NSString *)logString {
    
}

+ (void)log:(NSString *)logString withFormatter:(SILogglyFormatter *)formatter {
    
}

@end
