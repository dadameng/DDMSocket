//
//  SocketVariableLengthEncoder.m
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import "SocketVariableLengthEncoder.h"
#import "SocketException.h"
#import "SocketUtils.h"

@implementation SocketVariableLengthEncoder

- (instancetype)init
{
    if (self = [super init]) {
        _maxFrameSize = 65536;
        _countOfLengthByte = 4;
        _reverseOfLengthByte = NO;
    }
    return self;
}

- (void)encode:(id<UpstreamPacket>)upstreamPacket output:(id<SocketEncoderOutputProtocol>)output
{
    NSData *data = [upstreamPacket dataWithPacket];
    if (data.length == 0) {
        NSLog(@"[Encode] object data is nil ...");
        return;
    }//
    
    if (data.length >= _maxFrameSize - _countOfLengthByte) {
        [SocketException raiseWithReason:@"[Encode] Too Long Frame ..."];
        return;
    }//
    
    //可变长度编码，数据块的前四个字节为后续完整数据块的长度
    NSUInteger dataLen = data.length;
    NSMutableData *sendData = [[NSMutableData alloc] init];
    
    //将数据长度转换为长度字节，写入到数据块中。这里根据head占的字节个数转换data长度，默认为4个字节
    [sendData appendData:[SocketUtils bytesFromInt32:dataLen]];
    [sendData appendData:data];
    NSTimeInterval timeout = [upstreamPacket timeout];
    
//    NSLog(@"timeout: %f, sendData: %@", timeout, sendData);
    [output didEncode:sendData timeout:timeout];
}

@end
