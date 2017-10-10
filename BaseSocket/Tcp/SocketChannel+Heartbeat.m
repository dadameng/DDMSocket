//
//  SocketChannel+Heartbeat.m
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import "SocketChannel+Heartbeat.h"
#import <objc/runtime.h>

static char neu_heartbeatKey;
static char neu_heartbeatTimerKey;
@implementation SocketChannel (Heartbeat)
- (id<UpstreamPacket>)heartbeat
{
    return objc_getAssociatedObject(self, &neu_heartbeatKey);
}

- (void)setHeartbeat:(id<UpstreamPacket>)heartbeat
{
    objc_setAssociatedObject(self, &neu_heartbeatKey, heartbeat, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimer *)heartbeatTimer
{
    return objc_getAssociatedObject(self, &neu_heartbeatTimerKey);
}

- (void)setHeartbeatTimer:(NSTimer *)heartbeatTimer
{
    objc_setAssociatedObject(self, &neu_heartbeatTimerKey, heartbeatTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)stopHeartbeatTimer
{
    if (self.heartbeatTimer) {
        [self.heartbeatTimer invalidate];
        self.heartbeatTimer = nil;
    }
}

- (void)startHeartbeatTimer:(NSTimeInterval)interval
{
    /**
     *  这段没用  这主要是为了单向保持心跳  如果想改成单心跳 打开下面注释 并且把channel中的解码完和编码完的代码删掉 去掉手动控制改用定时器
     *
     */
    NSTimeInterval minInterval = MAX(5, interval);
    [self stopHeartbeatTimer];
    self.heartbeatTimer = [MSWeakTimer scheduledTimerWithTimeInterval:minInterval target:self selector:@selector(heartbeatTimerFunction) userInfo:nil repeats:YES dispatchQueue:self.delegateQueue];
}

- (void)heartbeatTimerFunction
{
    [self sendHeartbeat];
}

- (void)sendHeartbeat
{
    if ([self isConnected]) {
        [self asyncSendPacket:self.heartbeat];

    }
}

@end
