//
//  SocketChannelProxy.m
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import "SocketChannelProxy.h"

@interface SocketChannelProxy ()
{

}


@end

@implementation SocketChannelProxy
+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)initWithDeviceID:(NSString *)deviceID{
    if (self = [super init]) {
        _deviceID = deviceID;
        _callReplyManager = [[SocketCallReplyManager alloc] init];

    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        _callReplyManager = [[SocketCallReplyManager alloc] init];
        _deviceID = @"";
    }
    return self;
}

- (void)asyncConnect:(SocketConnectCallReply *)aCallReply
{

    _connectCallReply = aCallReply;
    [self openConnection];
}

- (void)disconnect
{
    [self closeConnection];
}

- (void)asyncRequest:(id<SocketCallReplyProtocol>)aCallReply
{
    if (![_channel isConnected]) {
        NSDictionary *userInfo = @{@"msg":@"Socket channel is not connected."};
        NSError *error = [NSError errorWithDomain:@"SocketChannelProxy" code:-1 userInfo:userInfo];
        [aCallReply onFailure:aCallReply error:error];
        return;
    }//if
    [_callReplyManager addCallReply:aCallReply];
    [_channel asyncSendPacket:[aCallReply request]];
}

- (void)asyncNotify:(id<SocketCallReplyProtocol>)aCallReply
{
    if (![_channel isConnected]) {
        NSDictionary *userInfo = @{@"msg":@"Socket channel is not connected."};
        NSError *error = [NSError errorWithDomain:@"SocketChannelProxy" code:-1 userInfo:userInfo];
        [aCallReply onFailure:aCallReply error:error];
        return;
    }//if
    [_callReplyManager addCallReply:aCallReply];

}

#pragma mark - SocketChannel

- (void)openConnection
{
    [self closeConnection];

    _channel = [[SocketChannelDefault alloc] initWithHost:_connectCallReply.host port:_connectCallReply.port];
    _channel.delegate = self;
    _channel.encoder = _encoder;
    _channel.decoder = _decoder;
    _channel.autoReconnect = _autoReconnect;
    _channel.heartbeat = _heartbeat;
    [_channel openConnection];
}

- (void)closeConnection
{
    if (_channel) {
        [_channel closeConnection];
        _channel.delegate = nil;
        _channel = nil;
    }
}

#pragma mark - SocketChannelDelegate

- (void)channelOpened:(SocketChannel *)channel host:(NSString *)host port:(int)port
{
    [_connectCallReply onSuccess:_connectCallReply response:nil];
}

- (void)channelClosed:(SocketChannel *)channel error:(NSError *)error
{

    [_callReplyManager removeAllCallReply];
    [_connectCallReply onFailure:_connectCallReply error:error];
}

- (void)channel:(SocketChannel *)channel received:(id<DownstreamPacket>)packet
{
    //结合命令编码解码器，解析命令字段。对callreply协议，从packet中解析出callreplyid。然后从_callReplyManager中获得replay指针处理回调。
    NSInteger callReplyId = [packet pid];
    
    id<SocketCallReplyProtocol> tempCallReply = [_callReplyManager getCallReplyWithId:callReplyId];
    if (tempCallReply) {
        [_callReplyManager removeCallReplyWithId:callReplyId];
        [tempCallReply onSuccess:tempCallReply response:packet];
        return;
    }
    if (self.recieveMessageBlock) {
        self.recieveMessageBlock(channel,packet);
    }

}

@end
