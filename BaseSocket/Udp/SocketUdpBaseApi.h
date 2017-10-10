//
//  SocketUdpBaseApi.h
//  NeuAdasPhone
//
//  Created by NEUSOFT on 17/4/27.
//  Copyright © 2017年 dadameng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketConnectionDelegate.h"

@interface SocketUdpBaseApi : NSObject<SocketConnectionDelegate>


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

- (BOOL)beginReceiving:(NSError **)errPtr;

- (void)pauseReceiving;

- (BOOL)receiveOnce:(NSError **)errPtr;
@end
