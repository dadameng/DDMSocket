//
//  SocketException.m
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import "SocketException.h"
NSString *const kSocketException = @"kSocketException";

@implementation SocketException
+ (void)raiseWithReason:(NSString *)reason
{
    NSString *name = kSocketException;
    NSException *exception = [NSException exceptionWithName:name reason:reason userInfo:nil];
    [exception raise];
}
@end
