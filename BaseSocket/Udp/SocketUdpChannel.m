//
//  SocketUdpChannel.m
//  NeuAdasPhone
//
//  Created by NEUSOFT on 17/4/28.
//  Copyright © 2017年 dadameng. All rights reserved.
//

#import "SocketUdpChannel.h"

#import "SocketException.h"
#import "SocketPacketContext.h"
#import "SocketUtils.h"
#import "SocketChannel+Heartbeat.h"

@interface SocketUdpChannel () <SocketEncoderOutputProtocol, SocketDecoderOutputProtocol>{
    BOOL receiveHeartbeat;
    NSTimeInterval receiveHeartbeatTimeOut;
}

@property (nonatomic, strong, readwrite) NSMutableData *receiveDataBuffer;
@property (nonatomic, strong, readwrite) SocketPacketResponse *downstreamContext;
@property (nonatomic, strong, readwrite) MSWeakTimer   *receiveHeartbeatTimer;
@end
@implementation SocketUdpChannel
- (instancetype)init
{
    return [self initWithHost:nil port:0];
}

- (instancetype)initWithHost:(NSString *)host port:(int)port
{
    if (self = [super initWithHost:host port:port]) {
        receiveHeartbeatTimeOut = 5;
        _receiveDataBuffer = [[NSMutableData alloc] init];
        _downstreamContext = [[SocketPacketResponse alloc] init];
        //        _receiveHeartbeatTimer = [MSWeakTimer scheduledTimerWithTimeInterval:receiveHeartbeatTimeOut target:self selector:@selector(checkReceiveHeartbeat) userInfo:nil repeats:YES dispatchQueue:self.delegateQueue];
        
        
    }
    return self;
}

- (void)openConnection
{
    @synchronized(self) {
        [self closeConnection];
        [self connectWithHost:self.host port:self.port];
        
    }//@synchronized
}

- (void)closeConnection
{
    @synchronized(self) {
        [self disconnect];
    }//synchronized
}

- (void)checkReceiveHeartbeat{
    
    if (!receiveHeartbeat) {
        [self.delegate channelClosed:self error:[NSError errorWithDomain:@"custom" code:5555 userInfo:@{NSLocalizedDescriptionKey:@"request time out"}]];
        [self closeConnection];
    }
    
}

- (void)asyncSendPacket:(id<UpstreamPacket>)packet
{
    if (nil == packet) {
        NSLog(@"Warning: Socket asyncSendPacket packet is nil ...");
        return;
    };
    
    if (nil == _encoder) {
        NSLog(@"Socket Encoder should not be nil ...");
        return;
    }
    [_encoder encode:packet output:self];
}

- (void)writeInt8:(int8_t)param
{
    NSData *data = [SocketUtils byteFromInt8:param];
    [self writeData:data timeout:-1 tag:0];
}

- (void)writeInt16:(int16_t)param
{
    NSData *data = [SocketUtils bytesFromInt16:param];
    [self writeData:data timeout:-1 tag:0];
}

- (void)writeInt32:(int32_t)param
{
    NSData *data = [SocketUtils bytesFromInt32:param];
    [self writeData:data timeout:-1 tag:0];
}

- (void)writeInt64:(int64_t)param
{
    NSData *data = [SocketUtils bytesFromInt64:param];
    [self writeData:data timeout:-1 tag:0];
}

#pragma mark - SocketConnectionDelegate

- (void)didDisconnect:(id<SocketConnectionDelegate>)con withError:(NSError *)err
{
    [self.delegate channelClosed:self error:err];
}

- (void)didConnect:(id<SocketConnectionDelegate>)con toHost:(NSString *)host port:(uint16_t)port
{
    
    [self.delegate channelOpened:self host:host port:port];
}

- (void)didRead:(id<SocketConnectionDelegate>)con withData:(NSData *)data tag:(long)tag
{
    if (data.length == 0) {
        return;
    }
    
    if (nil == _decoder) {
        NSLog(@"Socket Decoder should not be nil ...");
        return;
    }
    
    @synchronized(self) {
        [_receiveDataBuffer appendData:data];
        _downstreamContext.object = _receiveDataBuffer;
        NSInteger decodedLength = [_decoder decode:_downstreamContext output:self];
        //        NeuLog(@"Socket decodedLength is %@ receiveBufferLength is %@",@(decodedLength),@(_receiveDataBuffer.length));
        if (decodedLength ==0 && _receiveDataBuffer.length >0) {
            NSData *lenData = [_receiveDataBuffer subdataWithRange:NSMakeRange(0, 4)];
            //长度字节数据，可能存在高低位互换，通过数值转换工具处理
            NSUInteger frameLen = (NSUInteger)[SocketUtils valueFromBytes:lenData reverse:NO];
            NSLog(@"packet length is %@",@(frameLen));
        }
        
        if (decodedLength < 0) {
            [SocketException raiseWithReason:@"Decode Failed ..."];
            [self closeConnection];
            return;
        }//if
        
        if (decodedLength > 0) {
            NSUInteger remainLength = _receiveDataBuffer.length - decodedLength;
            NSData *remainData = [_receiveDataBuffer subdataWithRange:NSMakeRange(decodedLength, remainLength)];
            
            [_receiveDataBuffer setData:remainData];
        }//if
    }//@synchronized
}

- (void)didReceived:(id<SocketConnectionDelegate>)con withPacket:(id<DownstreamPacket>)packet
{
    receiveHeartbeat = YES;
    
    if ([self.delegate respondsToSelector:@selector(channel:received:)]) {
        [self.delegate channel:self received:packet];
    }
}

#pragma mark - SocketEncoderOutputProtocol

- (void)didEncode:(NSData *)data timeout:(NSTimeInterval)timeout
{
    if (data.length == 0) {
        return;
    }
    [self writeData:data timeout:timeout tag:0];
  
}

#pragma mark - SocketDecoderOutputProtocol

- (void)didDecode:(id<DownstreamPacket>)packet
{
    
    [self didReceived:self withPacket:packet];

}

@end
