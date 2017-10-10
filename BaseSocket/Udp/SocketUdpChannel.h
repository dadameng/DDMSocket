//
//  SocketUdpChannel.h
//  NeuAdasPhone
//
//  Created by NEUSOFT on 17/4/28.
//  Copyright © 2017年 dadameng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketUdpBaseApi.h"
#import "MSWeakTimer.h"
#import "SocketCodecProtocol.h"

@class SocketUdpChannel;

@protocol SocketUdpChannelDelegate <NSObject>

- (void)channelOpened:(SocketUdpChannel *)channel host:(NSString *)host port:(int)port;
- (void)channelClosed:(SocketUdpChannel *)channel error:(NSError *)error;
- (void)channel:(SocketUdpChannel *)channel received:(id<DownstreamPacket>)packet;

@end
@interface SocketUdpChannel : SocketUdpBaseApi
@property (nonatomic, strong) id<SocketEncoderProtocol> encoder;
@property (nonatomic, strong) id<SocketDecoderProtocol> decoder;

/**
 *  socket connection的回调代理，查看SocketConnectionDelegate
 */
@property (nonatomic, weak) id<SocketUdpChannelDelegate> delegate;

- (void)openConnection;
- (void)closeConnection;

@end
