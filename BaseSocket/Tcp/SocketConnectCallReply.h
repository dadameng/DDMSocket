//
//  SocketConnectCallReply.h
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import "SocketCallReply.h"
/**
 *  连接服务器结构对象
 */
@interface SocketConnectCallReply : SocketCallReply
@property (nonatomic, strong) NSString *host;
@property (nonatomic, assign) int port;
@end
