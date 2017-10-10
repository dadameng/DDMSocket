//
//  SocketChannelDefault.h
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import "SocketChannel.h"
#import "SocketChannel+Heartbeat.h"

@interface SocketChannelDefault : SocketChannel
/**
 *  心跳定时间隔，默认为20秒
 */
@property (nonatomic, assign) NSTimeInterval heartbeatInterval;

/**
 *  断开连接后，是否自动重连，默认为no
 */
@property (nonatomic, assign) BOOL autoReconnect;

- (void)stopConnectTimer;
- (void)startConnectTimer:(NSTimeInterval)interval;
- (void)connectTimerFunction;
@end
