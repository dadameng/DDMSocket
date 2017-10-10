//
//  SocketChannelDefault.m
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import "SocketChannelDefault.h"
#define kConnectMaxCount            1000    //tcp断开重连次数
#define kConnectTimerInterval       5       //单位秒s

@interface SocketChannelDefault ()

/**
 *  自动重连使用的计时器
 */
@property (nonatomic, strong, readonly) MSWeakTimer *connectTimer;

/**
 *  开始自动重连后，尝试重连次数，默认为500次
 */
@property (nonatomic, assign, readonly) NSInteger connectCount;

/**
 *  开始自动重连后，首次重连时间间隔，默认为5秒，后面每常识重连10次增加5秒
 */
@property (nonatomic, assign, readonly) NSTimeInterval connectTimerInterval;

@end
@implementation SocketChannelDefault
- (instancetype)initWithHost:(NSString *)host port:(int)port
{
    if (self = [super initWithHost:host port:port]) {
        _heartbeatInterval = 5;
        _autoReconnect = NO;
        //初始化自动重连参数
        _connectCount = 0;
        _connectTimerInterval = kConnectTimerInterval;
    }
    return self;
}

- (void)closeConnection
{
    [super closeConnection];
    
    [self stopConnectTimer];
    [self stopHeartbeatTimer];
}

- (void)stopConnectTimer
{
    if (_connectTimer) {
        [_connectTimer invalidate];
        _connectTimer = nil;
    }
}

- (void)startConnectTimer:(NSTimeInterval)interval
{
    NSTimeInterval minInterval = MAX(5, interval);
    NSLog(@"minInterval: %f", minInterval);
    
    [self stopConnectTimer];
    _connectTimer = [MSWeakTimer scheduledTimerWithTimeInterval:minInterval target:self selector:@selector(connectTimerFunction) userInfo:nil repeats:NO dispatchQueue:self.delegateQueue];
}

- (void)connectTimerFunction
{
    if (!_autoReconnect) {
        [self stopConnectTimer];
        return;
    }
    
    //重连次数超过最大尝试次数，停止
    if (_connectCount > kConnectMaxCount) {
        [self stopConnectTimer];
        return;
    }
    
    _connectCount++;
    
    //重连时间策略
    if (_connectCount % 10 == 0) {
        _connectTimerInterval += kConnectTimerInterval;
        [self startConnectTimer:_connectTimerInterval];
    }
    
    if ([self isConnected]) {
        return;
    }
    [self openConnection];
}

- (void)didDisconnect:(id<SocketConnectionDelegate>)con withError:(NSError *)err
{
    [super didDisconnect:con withError:err];
    
    [self stopConnectTimer];
    
    if (_autoReconnect) {
        __weak __typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, _connectTimerInterval), dispatch_get_main_queue(), ^{
            [weakSelf startConnectTimer:weakSelf.connectTimerInterval];
        });
    }
}

- (void)didConnect:(id<SocketConnectionDelegate>)con toHost:(NSString *)host port:(uint16_t)port
{
    //连接成功后，重置自动重连参数
    _connectCount = 0;
    _connectTimerInterval = kConnectTimerInterval;
    
    [self stopConnectTimer];
    
    [super didConnect:con toHost:host port:port];
    
    //连接成功后，开启心跳定时器 [设置了心跳包 channel.heartbeat = req]
    [self startHeartbeatTimer:_heartbeatInterval];
}

@end
