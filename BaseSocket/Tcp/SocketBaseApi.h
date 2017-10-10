//
//  SocketBaseApi.h
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketConnectionDelegate.h"
@interface SocketBaseApi : NSObject<SocketConnectionDelegate>
/**
 *  socket网络连接对象，只负责socket网络的连接通信，内部使用GCDAsyncSocket。
 *  1-只公开GCDAsyncSocket的主要方法，增加使用的便捷性。
 *  2-封装的另一个目的是，易于后续更新调整。如果不想使用GCDAsyncSocket，只想修改内部实现即可，对外不产生影响。
 */

#if OS_OBJECT_USE_OBJC
@property (atomic, strong, readonly, nullable) dispatch_queue_t delegateQueue;
#else
@property (atomic, assign, readonly, nullable) dispatch_queue_t delegateQueue;
#endif
@property (nonatomic, assign) BOOL useSecureConnection;
@property (nonatomic, strong , nullable) NSDictionary *tlsSettings;

@property (nonatomic, copy , nullable) NSString *host;
@property (nonatomic, assign) int port;

- (instancetype __nullable)initWithHost:(NSString * __nullable)host port:(int)port;
@end
