//
//  HttpDNS.m
//  httpdns_api_demo
//
//  Created by nanpo.yhl on 15/10/29.
//  Copyright © 2015年 com.aliyun.mobile. All rights reserved.
//

#import "HttpDNS.h"
#import "HttpDNSOrigin.h"
#import "HttpDNSLog.h"

static BOOL isExpiredIpAvailable = YES;
static NSString* defaultServerIP = @"203.107.1.1";
static NSString* defaultAccountID = @"117158";
static int defaultHostTTL = 30;

@implementation HttpDNS
{
    NSMutableDictionary* _hostManager;
    NSOperationQueue* _operationQueue;
    NSString* _serverIP;
    NSString* _accountID;
}

-(id)init {
    if (self = [super init]) {
        _hostManager = [[NSMutableDictionary alloc] init];
        _operationQueue = NSOperationQueue.new;
        _operationQueue.maxConcurrentOperationCount = 4;
        _serverIP = defaultServerIP;
        _accountID = defaultAccountID;
    }
    return self;
}

+(HttpDNS*)instance {
    static HttpDNS* _instance = nil;
    @synchronized(self) {
        if (!_instance) {
            _instance = [[HttpDNS alloc] init];
        }
    }
    
    return _instance;
}

-(void)setExpiredIpAvailable:(BOOL)flags
{
    isExpiredIpAvailable = flags;
}

-(BOOL)isExpiredIpAvailable
{
    return isExpiredIpAvailable;
}


-(HttpDNSOrigin*)fetch:(NSString*)host {
    HttpDNSOrigin* origin = nil;
    NSURL* resolveUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@/d?host=%@",_serverIP,_accountID,host]];
    NSHTTPURLResponse* response;
    NSError* error;
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:resolveUrl
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                            timeoutInterval:25];
    
    [HttpDNSLog log:@"fetch - Url: %@", resolveUrl];
    /*
     * 兼容ios6.+
     */
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(error) {
        [HttpDNSLog log:@"fetch - error %@", error];
        return nil;
    }
    
    [HttpDNSLog log:@"fetch - response statusCode %ld",(long)response.statusCode];
    if (response.statusCode == 200) {
        NSDictionary* args = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if (args.count > 0) {
            host = [args objectForKey:@"host"];
            long ttl = [[args objectForKey:@"ttl"] longValue];
            NSArray* ips = [args objectForKey:@"ips"];
            
            if (host && ips.count > 0) {
                if (ttl == 0) {
                    ttl = defaultHostTTL;
                }
                
                origin = [[HttpDNSOrigin alloc] initWithHost:host];
                origin.ips = ips;
                origin.ttl = ttl;
                origin.query = [[NSDate date] timeIntervalSince1970];
                
                [HttpDNSLog log:@"fetch - resolve host %@, ips %@, ttl %ld",origin.host,origin.ips, origin.ttl];
            }
        }
    }
    
    if (origin) {
        @synchronized(self) {
            [_hostManager setObject:origin forKey:host];
        }
    }
    return origin;
}

-(HttpDNSOrigin*)query:(NSString*)host {
    HttpDNSOrigin* origin = nil;
    
    @synchronized(self) {
        origin = _hostManager[host];
    }
    
    if (!origin || ([origin isExpired] && !isExpiredIpAvailable)) {
        [HttpDNSLog log:@"query - fetch from network, host: %@",host];
        origin = [self fetch:host];
        return origin;
    }
    
    [HttpDNSLog log:@"query - fetch from cache, host: %@",host];
    if ([origin isExpired]) {
        NSOperation* operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(fetch:) object:host];
        [_operationQueue addOperation:operation];
        [HttpDNSLog log:@"query - host %@ expired, Asynchronous update",host];
    }
    
    return origin;
}

-(NSString*)getIpByHost:(NSString *)host {
    if ([self.delegate shouldDegradeHTTPDNS:host]) {
        return nil;
    }
    
    if (host.length <= 0) {
        return nil;
    }
    
    HttpDNSOrigin* origin = [self query:host];
    
    return origin.getIp;
}

-(NSArray*)getIpsByHost:(NSString *)host {
    if ([self.delegate shouldDegradeHTTPDNS:host]) {
        return nil;
    }

    if (host.length <= 0) {
        return nil;
    }
    
    HttpDNSOrigin* origin = [self query:host];
    
    return origin.getIps;
}

-(void)setDelegateForDegradationFilter:(id<HttpDNSDegradationDelegate>)delegate {
    _delegate = delegate;
}

@end
