//
//  SocketRpcCmdEncoder.m
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import "SocketRpcCmdEncoder.h"
#import "SocketException.h"
#import "SocketUtils.h"
@implementation SocketRpcCmdEncoder

- (void)encode:(id<UpstreamPacket>)upstreamPacket output:(id<SocketEncoderOutputProtocol>)output
{
    id object = [upstreamPacket object];
    if (![object isKindOfClass:[NSData class]]) {
        [SocketException raiseWithReason:[NSString stringWithFormat:@"%@ Error !", [self class]]];
        return;
    }
    
    NSMutableData *dataObject = nil;
    
    if ([upstreamPacket respondsToSelector:@selector(pid)]) {
        NSData *OSTypeData = [SocketUtils bytesFromInt16:1];
        dataObject = [NSMutableData dataWithData:OSTypeData];

        NSInteger pid = [upstreamPacket pid];
        NSData *cmdData = [SocketUtils bytesFromValue:pid byteCount:4];
        [dataObject appendData:cmdData];
    }
    [dataObject appendData:object];
    
    //责任链模式，丢给下一个处理器
    if (_nextEncoder) {
        [upstreamPacket setObject:dataObject];
        [_nextEncoder encode:upstreamPacket output:output];
        return;
    }
    
    [output didEncode:dataObject timeout:[upstreamPacket timeout]];
}
@end
