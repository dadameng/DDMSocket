//
//  SocketChannelProxy.h
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketChannelDefault.h"
#import "SocketCodecProtocol.h"
#import "SocketCallReplyManager.h"
#import "SocketConnectCallReply.h"

typedef void(^SocketReceiveMessageBlock)(SocketChannel *channel,id<DownstreamPacket>packet);
@interface SocketChannelProxy : NSObject <SocketChannelDelegate>


@property (nonatomic, strong, readonly) SocketChannelDefault      *channel;

@property (nonatomic, strong, readonly) NSString                  *deviceID;

@property (nonatomic, copy            ) SocketReceiveMessageBlock recieveMessageBlock;

@property (nonatomic, strong          ) id<SocketEncoderProtocol> encoder;
@property (nonatomic, strong          ) id<SocketDecoderProtocol> decoder;

@property (nonatomic, strong, readonly) SocketCallReplyManager    *callReplyManager;

@property (nonatomic, strong, readonly) SocketConnectCallReply    *connectCallReply;
/**
 *  固定心跳包 (设置心跳包，在连接成功后，开启心态定时器)
 */
@property (nonatomic, strong          ) id<UpstreamPacket>        heartbeat;

/**
 *  断开连接后，是否自动重连，默认为no
 */
@property (nonatomic, assign          ) BOOL                      autoReconnect;

+ (instancetype)sharedInstance;

- (instancetype)initWithDeviceID:(NSString *)deviceID;

/**
 *  异步连接服务器
 *
 *  @param aCallReply 实现SocketCallReplyProtocol协议对象
 */
- (void)asyncConnect:(SocketConnectCallReply *)aCallReply;

/**
 *  断开连接
 */
- (void)disconnect;

/**
 *  发送数据给服务端，并等待服务端返回数据
 *
 *  @param aCallReply 实现SocketCallReplyProtocol协议对象
 */
- (void)asyncRequest:(id<SocketCallReplyProtocol>)aCallReply;

/**
 *  只设置对应命令的回调 不发送
 *
 *  @param aCallReply 实现SocketCallReplyProtocol协议对象
 */
- (void)asyncNotify:(id<SocketCallReplyProtocol>)aCallReply;


@end
