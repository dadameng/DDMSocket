//
//  SocketCallReplyManager.h
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketCallReplyProtocol.h"

@interface SocketCallReplyManager : NSObject

/**
 *  记录正在处理的请求对象，用于管理请求的超时时间等等
 *
 *  @param aCallReply 实现SocketCallReplyProtocol协议对象
 */
- (void)addCallReply:(id<SocketCallReplyProtocol>)aCallReply;

/**
 *  根据id获取记录的请求对象
 *
 *  @param aCallReplyId SocketCallReplyProtocol协议对象唯一id
 *
 *  @return 实现SocketCallReplyProtocol协议对象
 */
- (id<SocketCallReplyProtocol>)getCallReplyWithId:(NSInteger)aCallReplyId;

/**
 *  根据id移除记录的请求对象，多用于请求已返回和请求超时。
 *
 *  @param aCallReplyId SocketCallReplyProtocol协议对象唯一id
 */
- (void)removeCallReplyWithId:(NSInteger)aCallReplyId;

/**
 *  异常时移除所有记录的请求对象
 */
- (void)removeAllCallReply;
@end
