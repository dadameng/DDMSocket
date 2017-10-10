//
//  SocketCallReplyManager.m
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import "SocketCallReplyManager.h"
#import "MSWeakTimer.h"

@interface SocketCallReplyManager ()
{
    NSMutableDictionary *_callReplyMap;
    
    dispatch_queue_t _checkQueue;
    MSWeakTimer *_checkTimer;
}

@end

@implementation SocketCallReplyManager

- (instancetype)init
{
    if (self = [super init]) {
        _callReplyMap = [[NSMutableDictionary alloc] init];
        _checkQueue = dispatch_queue_create("com.Neusocket.SocketCallReplyCheck", NULL);
        [self startRefreshTimer];
    }
    return self;
}

- (void)stopRefreshTimer
{
    if (_checkTimer) {
        [_checkTimer invalidate];
        _checkTimer = nil;
    }
}

- (void)startRefreshTimer
{
    [self stopRefreshTimer];
    _checkTimer = [MSWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkTimeout) userInfo:nil repeats:YES dispatchQueue:_checkQueue];
}

- (void)checkTimeout
{
    @synchronized(self) {
        NSMutableArray *timeoutCalls = [[NSMutableArray alloc] init];
        [_callReplyMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            id<SocketCallReplyProtocol> tempCallReply = obj;
            if ([tempCallReply isTimeout]) {
                [timeoutCalls addObject:@([tempCallReply callReplyId])];
                //
                NSDictionary *userInfo = @{@"msg":@"Socket call is timeout."};
                NSError *error = [NSError errorWithDomain:@"SocketChannelProxy" code:-1 userInfo:userInfo];
                [tempCallReply onFailure:tempCallReply error:error];
            }//if
        }];
        for (NSNumber *callId in timeoutCalls) {
            [_callReplyMap removeObjectForKey:callId];
        }//for
    }//
}

- (void)addCallReply:(id<SocketCallReplyProtocol>)aCallReply
{
    @synchronized(self) {
        [_callReplyMap setObject:aCallReply forKey:@([aCallReply callReplyId])];
    }
}

- (id<SocketCallReplyProtocol>)getCallReplyWithId:(NSInteger)aCallReplyId
{
    @synchronized(self) {
        return [_callReplyMap objectForKey:@(aCallReplyId)];
    }
}

- (void)removeCallReplyWithId:(NSInteger)aCallReplyId
{
    @synchronized(self) {
        [_callReplyMap removeObjectForKey:@(aCallReplyId)];
    }
}

- (void)removeAllCallReply
{
    @synchronized(self) {
        [_callReplyMap removeAllObjects];
    }
}

@end
