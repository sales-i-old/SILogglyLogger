//
//  SILogger.m
//  SILogglyLogger
//
//  Created by Dillon Hoa on 23/03/2016.
//  Copyright © 2016 sales-i. All rights reserved.
//

#import "SILogger.h"
#import "LogglyEndPointHandler.h"

@interface SILogger()
@property (nonatomic, strong) NSMutableArray *logMessages;
@property (nonatomic) dispatch_queue_t queue;
@end

@implementation SILogger
static SILogger *sharedInstance = nil;
static NSString *key = nil;
static NSArray *tags = nil;

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
        _queue = dispatch_queue_create("com.sales-i.SILogglyLogger.queue", NULL);
        _logMessages = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidGoBackground)
                                                     name:@"UIApplicationWillResignActiveNotification"
                                                   object:nil];
    }
    return self;
}

- (void)appDidGoBackground {
    [LogglyEndPointHandler sendStoredLogsWithKey:key tags:tags];
}
#pragma mark init method

+ (SILogger *)initWithKey:(NSString *)logglyKey tags:(NSArray *)logglyTags{
    SILogger *logger = [SILogger sharedInstance];
    key = logglyKey;
    tags = logglyTags;
    return logger;
}

+ (void)log:(NSString *)logString {
    [SILogger log:logString formatter:nil];
}

+ (void)log:(NSString *)logString formatter:(SILogglyFormatter *)formatter {
    if (!formatter)
        formatter = [[SILogglyFormatter alloc] init];
    if (formatter.message.length == 0){
        formatter.message = logString;
    }
    dispatch_barrier_async([SILogger sharedInstance].queue, ^{
        [LogglyEndPointHandler addLogToQueue:formatter.toString];
    });
}

@end
