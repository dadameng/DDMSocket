//
//  SocketCodecProtocol.h
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketPacketContext.h"

#pragma mark - encoder output protocol

/**
 *  数据编码后，分发对象协议
 */
@protocol SocketEncoderOutputProtocol <NSObject>

@required

- (void)didEncode:(NSData *)encodedData timeout:(NSTimeInterval)timeout;

@end

#pragma mark - decoder output protocol

/**
 *  数据解码后，分发对象协议
 */
@protocol SocketDecoderOutputProtocol <NSObject>

@required

- (void)didDecode:(id<DownstreamPacket>)decodedPacket;

@end

#pragma mark - encoder protocol

/**
 *  编码器协议
 */
@protocol SocketEncoderProtocol <NSObject>

@required

/**
 *  编码器
 *
 *  @param upstreamPacket 待发送的数据包
 *  @param output 数据编码后，分发对象
 */
- (void)encode:(id<UpstreamPacket>)upstreamPacket output:(id<SocketEncoderOutputProtocol>)output;

@end

#pragma mark - decoder protocol

/**
 *  解码器协议
 */
@protocol SocketDecoderProtocol <NSObject>

/**
 *  解码器
 *
 *  @param downstreamPacket 接收到的原始数据
 *  @param output           数据解码后，分发对象
 *
 *  @return -1解码异常，断开连接; 0数据不完整，等待数据包; >0解码正常，为已解码数据长度
 */
- (NSInteger)decode:(id<DownstreamPacket>)downstreamPacket output:(id<SocketDecoderOutputProtocol>)output;

@end

#pragma mark -

