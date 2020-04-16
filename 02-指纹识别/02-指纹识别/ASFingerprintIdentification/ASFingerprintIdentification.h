//
//  ASFingerprintIdentification.h
//  02-指纹识别
//
//  Created by Mac on 2020/4/16.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASFingerprintIdentification : NSObject

/// 方式一
+ (void)fingerprintIdentificationWithContext1:(LAContext *)context;

/// 方式二
+ (void)fingerprintIdentificationWithContext2:(LAContext *)context;

/// 指纹验证被锁后调用输入密码解锁
+ (void)touchIdIsLockedWithContext:(LAContext *)context;

@end

NS_ASSUME_NONNULL_END
