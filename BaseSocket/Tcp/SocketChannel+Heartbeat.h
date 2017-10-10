//
//  SocketChannel+Heartbeat.h
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import "SocketChannel.h"
@interface SocketChannel (Heartbeat)
/**
 *  固定心跳包 (设置心跳包，在连接成功后，开启心态定时器)
 */
@property (nonatomic, strong) id<UpstreamPacket> heartbeat;

/**
 *  心跳定时器，这里使用的是NSTimer，在断开连接后，需要手动停止心跳定时器(使用MSWeakTimer更好)
 */
@property (nonatomic, strong) MSWeakTimer *heartbeatTimer;

- (void)stopHeartbeatTimer;
- (void)startHeartbeatTimer:(NSTimeInterval)interval;
- (void)heartbeatTimerFunction;
- (void)sendHeartbeat;
@end
