//
//  SocketCallReply.m
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import "SocketCallReply.h"
typedef void(^SocketReplySuccessBlock)(id<SocketCallReplyProtocol> callReply, id<DownstreamPacket>response);
typedef void(^SocketReplyFailureBlock)(id<SocketCallReplyProtocol> callReply, NSError *error);

@interface SocketCallReply ()
{
    id<UpstreamPacket> _request;
    id<DownstreamPacket> _response;
    time_t _startTime;
    
    SocketReplySuccessBlock _successBlock;
    SocketReplyFailureBlock _failureBlock;
}

@end

@implementation SocketCallReply

#pragma mark -

- (void)setSuccessBlock:(void (^)(id<SocketCallReplyProtocol>, id<DownstreamPacket>))successBlock
{
    _successBlock = successBlock;
}

- (void)setFailureBlock:(void (^)(id<SocketCallReplyProtocol>, NSError *))failureBlock
{
    _failureBlock = failureBlock;
}

- (void)setRequest:(id<UpstreamPacket>)request
{
    _request = request;
}

- (id<UpstreamPacket>)request
{
    _startTime = time(0);
    return _request;
}
- (void)setResponse:(id<DownstreamPacket>)response
{
    _response = response;
}

- (id<DownstreamPacket>)response
{
    return _response;
}

#pragma mark - SocketCallProtocol

- (NSInteger)callReplyId
{
    if ([_request pid]) {
        return [_request pid];
    }else if ([_response pid]){
        return [_response pid];
    }
    return [_request pid];
}

- (NSTimeInterval)callReplyTimeout
{
    if ([_request timeout] <= 0) {
        return LONG_MAX;
    }
    
    return [_request timeout];
}

- (BOOL)isTimeout
{
    time_t currentTime = time(0);
    if (currentTime - _startTime >= [self callReplyTimeout]) {
        return YES;
    }
    return NO;
}

#pragma mark - SocketReplyProtocol

- (void)onFailure:(id<SocketCallReplyProtocol>)aCallReply error:(NSError *)error
{
    NSLog(@"%@ onFailure: %@", [self class], error.description);
    //请求失败
    if (_failureBlock) {
        _failureBlock(aCallReply, error);
    }
}

- (void)onSuccess:(id<SocketCallReplyProtocol>)aCallReply response:(id<DownstreamPacket>)response
{
    NSLog(@"%@ onSuccess: %@", [self class], [response object]);
    //请求成功
    if (_successBlock) {
        _successBlock(aCallReply, response);
    }
}

@end
