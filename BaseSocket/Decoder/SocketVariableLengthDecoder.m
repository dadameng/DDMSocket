//
//  SocketVariableLengthDecoder.m
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import "SocketVariableLengthDecoder.h"
#import "SocketException.h"
#import "SocketUtils.h"
#import "SocketPacketContext.h"

@implementation SocketVariableLengthDecoder

- (instancetype)init
{
    if (self = [super init]) {
        _maxFrameSize = 65536;
        _countOfLengthByte = 4;
        _reverseOfLengthByte = NO;
    }
    return self;
}

- (NSInteger)decode:(id<DownstreamPacket>)downstreamPacket output:(id<SocketDecoderOutputProtocol>)output
{
    id object = [downstreamPacket object];
    if (![object isKindOfClass:[NSData class]]) {
        [SocketException raiseWithReason:@"[Decode] object should be NSData ..."];
        return -1;
    }
    
    NSData *downstreamData = object;
    NSUInteger headIndex = 0;
    
    //先读区4个字节的协议长度 (前4个字节为数据包的长度)
    while (downstreamData && downstreamData.length - headIndex > _countOfLengthByte) {
        NSData *lenData = [downstreamData subdataWithRange:NSMakeRange(headIndex, _countOfLengthByte)];
        //长度字节数据，可能存在高低位互换，通过数值转换工具处理
        NSUInteger frameLen = (NSUInteger)[SocketUtils valueFromBytes:lenData reverse:_reverseOfLengthByte];
        if (frameLen >= _maxFrameSize - _countOfLengthByte) {
            [SocketException raiseWithReason:@"[Decode] Too Long Frame ..."];
            return -1;
        }//
        
        //剩余数据，不是完整的数据包，则break继续读取等待
        if (downstreamData.length - headIndex < _countOfLengthByte + frameLen) {
            break;
        }
        //数据包(长度＋内容)
        NSData *frameData = [downstreamData subdataWithRange:NSMakeRange(headIndex, _countOfLengthByte + frameLen)];
        
        //去除数据长度后的数据内容
        SocketPacketResponse *ctx = [[SocketPacketResponse alloc] init];
        ctx.object = [frameData subdataWithRange:NSMakeRange(_countOfLengthByte, frameLen)];
        ctx.packetLength = frameLen;
        //责任链模式，丢给下一个处理器
        if (_nextDecoder) {
            [_nextDecoder decode:ctx output:output];
        } else {
            [output didDecode:ctx];
        }
        
        //调整已经解码数据
        headIndex += frameData.length;
    }//while
    return headIndex;
}
@end
