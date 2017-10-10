//
//  SocketRpcCmdEncoder.h
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SocketCodecProtocol.h"

@interface SocketRpcCmdEncoder : NSObject <SocketEncoderProtocol>

@property (nonatomic, strong) id<SocketEncoderProtocol> nextEncoder;

@end
