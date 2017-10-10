//
//  SocketUdpBaseApi.m
//  NeuAdasPhone
//
//  Created by NEUSOFT on 17/4/27.
//  Copyright © 2017年 dadameng. All rights reserved.
//

#import "SocketUdpBaseApi.h"

#import "GCDAsyncUdpSocket.h"

@interface SocketUdpBaseApi () <GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong, readonly) GCDAsyncUdpSocket *asyncSocket;

@end

@implementation SocketUdpBaseApi

- (instancetype)initWithHost:(NSString *)host port:(int)port
{
    if (self = [super init]) {
        _host = host;
        _port = port;
    }
    return self;
}

- (BOOL)beginReceiving:(NSError **)errPtr{

    return [self.asyncSocket beginReceiving:errPtr];

}
- (BOOL)receiveOnce:(NSError *__autoreleasing *)errPtr{
    return [self.asyncSocket receiveOnce:errPtr];
}
- (void)pauseReceiving{
    [self.asyncSocket pauseReceiving];
}

#pragma mark - SocketConnectionDelegate

- (void)connectWithHost:(NSString *)hostName port:(int)port
{
    @synchronized (self) {
        [self disconnect];
        
        if (_useSecureConnection && (nil == _tlsSettings)) {
            // Configure SSL/TLS settings
            NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:3];
            settings[(NSString *)kCFStreamSSLPeerName] = hostName;
            _tlsSettings= settings;
        }
        
        _asyncSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("NeuDeviceConncetSocketQueue", DISPATCH_QUEUE_CONCURRENT)];
        [_asyncSocket setIPVersionNeutral];
        
        NSError *err = nil;
//        [_asyncSocket connectToHost:hostName onPort:port error:&err];
        [_asyncSocket bindToPort:port error:&err];
        if (err) {
            [self didDisconnect:self withError:err];
        }
        [_asyncSocket beginReceiving:&err];
        if (err) {
            [self didDisconnect:self withError:err];
        }

    }//@synchronized
}

- (void)disconnect
{
    @synchronized (self) {
        if (nil == _asyncSocket) {
            return;
        }
        _asyncSocket.delegate = nil;
        _asyncSocket = nil;
    }//@synchronized
}

- (BOOL)isConnected
{
    return [_asyncSocket isConnected];
}

- (dispatch_queue_t)delegateQueue{
    
    return self.asyncSocket.delegateQueue;
}

- (void)didDisconnect:(id<SocketConnectionDelegate>)con withError:(NSError *)err
{
    //override
}

- (void)didConnect:(id<SocketConnectionDelegate>)con toHost:(NSString *)host port:(uint16_t)port
{
    //override
}

- (void)didRead:(id<SocketConnectionDelegate>)con withData:(NSData *)data tag:(long)tag
{
    //override
}

#pragma mark - read & write

- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag
{
//    [self.asyncSocket di];
}

- (void)writeData:(NSData *)data timeout:(NSTimeInterval)timeout tag:(long)tag
{
    [self.asyncSocket sendData:data toHost:self.asyncSocket.connectedHost port:self.asyncSocket.connectedPort withTimeout:timeout tag:tag];
}

#pragma mark - GCDAsyncUdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address{
    
    NSError * error;
    [self.asyncSocket beginReceiving:&error];
    if (!error) {
        [self didConnect:self toHost:self.asyncSocket.connectedHost port:self.asyncSocket.connectedPort];
    }else{
        [self didDisconnect:self withError:error];
    }
    
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error{
    
    [self didDisconnect:self withError:error];
}

/**
 * Called when the datagram with the given tag has been sent.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    
    [self writeData:nil timeout:-1 tag:tag];
}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    
    
    
}

/**
 * Called when the socket has received the requested datagram.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(nullable id)filterContext{
    
    [self didRead:self withData:data tag:-1];
    
}

/**
 * Called when the socket is closed.
 **/
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error{
    [self didDisconnect:self withError:error];
}


@end
