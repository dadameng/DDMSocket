//
//  SocketException.h
//  NeusoftIAPhoneRecord
//
//  Created by camera on 16/10/24.
//  Copyright © 2016年 dadameng. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kSocketException;
@interface SocketException : NSObject
+ (void)raiseWithReason:(NSString *)reason;

@end
