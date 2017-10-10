//
//  SocketVariableLengthDecoder.h
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketCodecProtocol.h"

/**
 *  可变长度编码器
 *  数据包的前两个字节为数据帧内容的长度（总长度＝包头［4个字节］＋内容［length］，total=4+frameLength）
 *  解码时，读取前两个字节，得到单帧的数据长度，然后读区对应长度的数据帧
 *
 *  对应netty的LengthFieldBasedFrameDecoder(65536, 0, 4)解码器
 */
@interface SocketVariableLengthDecoder : NSObject<SocketDecoderProtocol>

/**
 *  应用协议中允许发送的最大数据块大小，默认为65536
 */
@property (nonatomic, assign) NSUInteger maxFrameSize;

/**
 *  包长度数据的字节个数，默认为4
 */
@property (nonatomic, assign) int countOfLengthByte;

/**
 *  包长度数据的字节顺序是否需要反向倒序处理，默认为YES
 */
@property (nonatomic, assign) BOOL reverseOfLengthByte;

@property (nonatomic, strong) id<SocketDecoderProtocol> nextDecoder;
@end
