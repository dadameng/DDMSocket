//
//  SocketChannel.h
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import "SocketBaseApi.h"
#import "MSWeakTimer.h"
#import "SocketCodecProtocol.h"

@class SocketChannel;

@protocol SocketChannelDelegate <NSObject>

- (void)channelOpened:(SocketChannel *)channel host:(NSString *)host port:(int)port;
- (void)channelClosed:(SocketChannel *)channel error:(NSError *)error;
- (void)channel:(SocketChannel *)channel received:(id<DownstreamPacket>)packet;

@end
@interface SocketChannel : SocketBaseApi
@property (nonatomic, strong) id<SocketEncoderProtocol> encoder;
@property (nonatomic, strong) id<SocketDecoderProtocol> decoder;
@property (nonatomic, strong) SocketPacketResponse *downstreamContext;


/**
 *  socket connection的回调代理，查看SocketConnectionDelegate
 */
@property (nonatomic, weak) id<SocketChannelDelegate> delegate;

- (void)openConnection;
- (void)closeConnection;

- (void)asyncSendPacket:(id<UpstreamPacket>)packet;

- (void)writeInt8:(int8_t)param;
- (void)writeInt16:(int16_t)param;
- (void)writeInt32:(int32_t)param;
- (void)writeInt64:(int64_t)param;

@end
