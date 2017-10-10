//
//  SocketRpcCmdDecoder.m
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import "SocketRpcCmdDecoder.h"
#import "SocketException.h"
#import "SocketUtils.h"

@implementation SocketRpcCmdDecoder

- (NSInteger)decode:(id<DownstreamPacket>)downstreamPacket output:(id<SocketDecoderOutputProtocol>)output
{
    id object = [downstreamPacket object];
    if (![object isKindOfClass:[NSData class]]) {
        [SocketException raiseWithReason:[NSString stringWithFormat:@"%@ Error !", [self class]]];
        return -1;
    }
    
    NSData *dataObject = object;
    if ([downstreamPacket respondsToSelector:@selector(pid)]) {
        NSData *cmdData = [dataObject subdataWithRange:NSMakeRange(2, 4)];
        NSInteger pid = (NSInteger)[SocketUtils valueFromBytes:cmdData];
        [downstreamPacket setPid:pid];
        [downstreamPacket setObject:[dataObject subdataWithRange:NSMakeRange(6, dataObject.length - 6)]];
    }
    
    //责任链模式，丢给下一个处理器
    if (_nextDecoder) {
        return [_nextDecoder decode:downstreamPacket output:output];
    }
    
    [output didDecode:downstreamPacket];
    return 0;
}
@end
