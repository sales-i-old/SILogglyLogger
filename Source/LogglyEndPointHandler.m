//
//  LogglyEndPointHandler.m
//  SILogglyLogger
//
//  Created by Dillon Hoa on 23/03/2016.
//  Copyright © 2016 sales-i. All rights reserved.
//

#import "LogglyEndPointHandler.h"
#define kSILogglyStoreKey @"SILOGGLYSTOREKEY"

@implementation LogglyEndPointHandler

static NSURLSessionConfiguration *sessionConfiguration = nil;

+ (void)logWithKey:(NSString *)key tags:(NSArray *)tags formatter:(SILogglyFormatter *)formatter {
    
}

+ (void)addLogToQueue : (NSString *)logString {
    NSMutableArray *logs = [NSMutableArray array];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kSILogglyStoreKey])
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:kSILogglyStoreKey] isKindOfClass:[NSArray class]]){
            [logs addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:kSILogglyStoreKey]];
        }
    }
    [logs addObject:logString];
    [[NSUserDefaults standardUserDefaults]
     setObject:logs forKey:kSILogglyStoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)sendStoredLogsWithKey:(NSString *)key tags:(NSArray *)tags {
    if (!key) {
        NSAssert(false, @"There must an API key for loggly");
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kSILogglyStoreKey])
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:kSILogglyStoreKey] isKindOfClass:[NSArray class]]){
            NSArray *logs = [[NSUserDefaults standardUserDefaults] objectForKey:kSILogglyStoreKey];
            NSString *bulkLogString = [logs componentsJoinedByString:@"\n"];
            [LogglyEndPointHandler postWithURL: [LogglyEndPointHandler urlWithKey:key
                                                                             tags:[tags componentsJoinedByString:@","]
                                                                             bulk:YES]
                                      withBody:bulkLogString
                                    completion:^(BOOL success) {
                                        if (success){
                                            [[NSUserDefaults standardUserDefaults]
                                             setObject:@[] forKey:kSILogglyStoreKey];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                        }
                                    }];
        }
    }
}

+ (NSURL *)urlWithKey:(NSString *)key tags:(NSString *)tags bulk:(BOOL)bulk{
    NSString *urlString = [NSString stringWithFormat:@"https://logs-01.loggly.com/%@/%@",bulk?@"bulk":@"inputs",key];
    if (tags)
        [urlString stringByAppendingString:[NSString stringWithFormat:@"/tag/%@/",tags]];
    return [NSURL URLWithString:urlString];
}


+ (void)postWithURL:(NSURL *)url withBody:(NSString *)body completion:(void(^)(BOOL success))completion{
    if (body.length == 0) return;
    if (!url) return;
    
    if (!sessionConfiguration) {
        sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.HTTPAdditionalHeaders = @{
                                                        @"Content-Type"  : @"application/json"
                                                        };
        sessionConfiguration.allowsCellularAccess = YES;
    }
    
    NSLog(@"Posting to Loggly: %@", body);
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (error) {
            NSLog(@"LOGGLY ERROR: %@",error);
        } else if (data) {
            NSString *responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"LOGGLY: Response = %@.",responseString);
        }
        
    }];
    [postDataTask resume];
}
@end
