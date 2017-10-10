//
//  SocketPacketContext.m
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import "SocketPacketContext.h"

#pragma mark - SocketPacketContext

@implementation SocketPacketContext

@synthesize object = _object;

- (instancetype)initWithObject:(id)aObject
{
    if (self = [super init]) {
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

#pragma mark - SocketPacketRequest

@implementation SocketPacketRequest

@synthesize pid;
@synthesize timeout = _timeout;
@synthesize packetLength;

- (instancetype)init
{
    if (self = [super init]) {
        _timeout = -1;
    }
    return self;
}

- (instancetype)initWithObject:(id)aObject
{
    if (self = [super initWithObject:aObject]) {
        _timeout = -1;
    }
    return self;
}

@end

#pragma mark - SocketPacketResponse

@implementation SocketPacketResponse

@synthesize pid;
@synthesize packetLength;


@end
