//
//  SocketCallReply.h
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketCallReplyProtocol.h"

/**
 *  请求
 */
@interface SocketCallReply : NSObject <SocketCallReplyProtocol>

- (void)setSuccessBlock:(void(^)(id<SocketCallReplyProtocol> callReply, id<DownstreamPacket>response))successBlock;
- (void)setFailureBlock:(void(^)(id<SocketCallReplyProtocol> callReply, NSError *error))failureBlock;
@end
