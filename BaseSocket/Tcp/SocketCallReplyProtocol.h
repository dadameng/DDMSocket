//
//  SocketCallReplyProtocol.h
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketPacket.h"

@protocol SocketCallReplyProtocol;

/**
 *  RPC呼叫协议
 */
@protocol SocketCallProtocol <NSObject>

@optional

@property (nonatomic, strong) id<UpstreamPacket>   request;
@property (nonatomic, strong) id<DownstreamPacket> response;

@end

/**
 *  RPC应答协议
 */
@protocol SocketReplyProtocol <NSObject>

@required

- (void)onSuccess:(id<SocketCallReplyProtocol>)aCallReply response:(id<DownstreamPacket>)response;
- (void)onFailure:(id<SocketCallReplyProtocol>)aCallReply error:(NSError *)error;

@end

/**
 *  RPC相关协议
 */
@protocol SocketCallReplyProtocol <SocketCallProtocol, SocketReplyProtocol>

@required

- (NSInteger)callReplyId;
- (NSTimeInterval)callReplyTimeout;
- (BOOL)isTimeout;

@end
