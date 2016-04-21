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
@property (nonatomic) NSTimer *postTimer;
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
        _minimumLogLevel = LogglyWarning;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sendLogglyLogs)
                                                     name:@"UIApplicationWillResignActiveNotification"
                                                   object:nil];
        _postLogIntervalTime = 600;
        _postTimer = [self startPoll];
        
    }
    return self;
}

- (void)dealloc
{
    [_postTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSTimer *)startPoll {
    return [NSTimer scheduledTimerWithTimeInterval:_postLogIntervalTime target:self selector:@selector(sendLogglyLogs) userInfo:nil repeats:YES];
}

- (void)setPostLogIntervalTime:(NSUInteger)postLogIntervalTime {
    if (_postTimer.isValid)
        [_postTimer invalidate];
    _postTimer = nil;
    _postLogIntervalTime = postLogIntervalTime;
    _postTimer = [self startPoll];
}

- (void)sendLogglyLogs {
    dispatch_barrier_async([SILogger sharedInstance].queue, ^{
        [LogglyEndPointHandler sendStoredLogsWithKey:key tags:tags];
    });
}

#pragma mark init method

+ (SILogger *)initWithKey:(NSString *)logglyKey tags:(NSArray *)logglyTags{
    SILogger *logger = [SILogger sharedInstance];
    key = logglyKey;
    tags = logglyTags;
    return logger;
}

#pragma mark - post now

+ (void)postNow {
    [[SILogger sharedInstance] sendLogglyLogs];
}

#pragma mark - log methods

+ (void)log:(NSString *)logString {
    [SILogger log:logString formatter:nil];
}

+ (void)log:(NSString *)logString level:(SILogglyLogLevel)level {
    SILogglyFormatter *formatter = [[SILogglyFormatter alloc] init];
    formatter.logLevel = level;
    [SILogger log:logString formatter:formatter];
}

+ (void)logWithFormat:(SILogglyFormatter *)formatter {
    [SILogger log:@"" formatter:formatter];
}

+ (void)log:(NSString *)logString formatter:(SILogglyFormatter *)formatter {
    if (!formatter)
        formatter = [[SILogglyFormatter alloc] init];
    if ([SILogger sharedInstance].minimumLogLevel > formatter.logLevel) return;
    if (formatter.message.length == 0){
        formatter.message = logString;
    } else if (logString.length > 0) {
        NSAssert(false, @"formatter message property will override logString.");
    }
    
    dispatch_barrier_sync([SILogger sharedInstance].queue, ^{
        [LogglyEndPointHandler addLogToQueue:formatter.toString];
    });
}

@end
