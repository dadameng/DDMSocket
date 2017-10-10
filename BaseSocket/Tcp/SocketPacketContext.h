//
//  SocketPacketContext.h
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketPacket.h"

#pragma mark - SocketPacketContext

@interface SocketPacketContext : NSObject <UpstreamPacket, DownstreamPacket>

@end

#pragma mark - SocketPacketRequest

@interface SocketPacketRequest : SocketPacketContext

@end

#pragma mark - SocketPacketResponse

@interface SocketPacketResponse : SocketPacketContext

@end


