//
//  SocketRpcCmdDecoder.h
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketCodecProtocol.h"

@interface SocketRpcCmdDecoder : NSObject <SocketDecoderProtocol>

@property (nonatomic, strong) id<SocketDecoderProtocol> nextDecoder;

@end
