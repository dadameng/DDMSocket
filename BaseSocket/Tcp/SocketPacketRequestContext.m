//
//  SocketPacketRequestContext.m
//  NeuAdasPhone
//
//  Created by NEUSOFT on 17/6/29.
//  Copyright © 2017年 dadameng. All rights reserved.
//

#import "SocketPacketRequestContext.h"

@implementation SocketPacketRequestContext
@synthesize pid;
@synthesize packetLength;
@synthesize timeout = _timeout;
@synthesize object = _object;
- (instancetype)initWithObject:(id)aObject
{
    if (self = [super init]) {
        _timeout = -1;
        _object = aObject;
    }
    return self;
}

- (NSData *)dataWithPacket
{
    if ([_object isKindOfClass:[NSData class]]) {
        return _object;
    } else if ([_object isKindOfClass:[NSString class]]) {
        NSString *stringObject = _object;
        return [stringObject dataUsingEncoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

- (NSString *)stringWithPacket
{
    if ([_object isKindOfClass:[NSString class]]) {
        return _object;
    } else if ([_object isKindOfClass:[NSData class]]) {
        return [[NSString alloc] initWithData:_object encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

@end
