//
//  ASFingerprintIdentification.m
//  02-指纹识别
//
//  Created by Mac on 2020/4/16.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ASFingerprintIdentification.h"

@implementation ASFingerprintIdentification

/// 方式一
+ (void)fingerprintIdentificationWithContext1:(LAContext *)context {
    
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"验证指纹以确认您的身份" reply:^(BOOL success, NSError *error) {
        
        // 切换到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (success) {
                
                NSLog(@"指纹验证成功");
            } else {
                
                NSLog(@"指纹认证失败，%@",error.description);
                NSLog(@"%ld", (long)error.code);
                // 错误码 error.code
                switch (error.code) {
                        
                    case LAErrorUserCancel: { NSLog(@"用户取消验证Touch ID");// 在TouchID对话框中点击了取消按钮或者按了home键
                    }
                        break;
                    case LAErrorUserFallback: {
                        
                        NSLog(@"用户选择输入密码"); // 在TouchID对话框中点击了输入密码按钮
                    }
                        break;
                    case LAErrorSystemCancel: { NSLog(@"取消授权，如其他应用切入，用户自主"); // TouchID对话框被系统取消，例如按下电源键
                    }
                        break;
                    case LAErrorPasscodeNotSet: {
                        NSLog(@"设备系统未设置密码");
                    }
                        break;
                    case LAErrorBiometryNotAvailable: {
                        
                        NSLog(@"设备未设置Touch ID");
                    }
                        break;
                    case LAErrorBiometryNotEnrolled:  {
                        
                        NSLog(@"用户未录入指纹");
                    }
                        break;
                    case LAErrorAppCancel: {
                        NSLog(@"用户不能控制情况下APP被挂起");
                    }
                        break;
                    case LAErrorInvalidContext: {
                        
                        NSLog(@"LAContext传递给这个调用之前已经失效");
                    }
                        break;
                    default: {
                        NSLog(@"其他情况");
                    }
                        break;
                }
            }
        });
    }];
}

/// 方式二
+ (void)fingerprintIdentificationWithContext2:(LAContext *)context {
    
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"验证指纹以确认您的身份" reply:^(BOOL success, NSError *error) {
        
        // 切换到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (success) {
                NSLog(@"指纹验证成功");
            } else {
                NSLog(@"指纹认证失败，%@",error.description);
                NSLog(@"%ld", (long)error.code);
                // 错误码 error.code
                switch (error.code) {
                    case LAErrorAuthenticationFailed:{
                        NSLog(@"授权失败"); // 连续三次指纹识别错误
                    }
                        break;
                    case LAErrorUserCancel: { NSLog(@"--用户取消验证Touch ID");// 在TouchID对话框中点击了取消按钮或者按了home键
                    }
                        break;
                    case LAErrorUserFallback: {
                        
                        NSLog(@"用户选择输入密码"); // 在TouchID对话框中点击了输入密码按钮,在这里可以做一些自定义的操作。
                    }
                        break;
                    case LAErrorSystemCancel: { NSLog(@"取消授权，如其他应用切入，用户自主"); // TouchID对话框被系统取消，例如按下电源键
                    }
                        break;
                    case LAErrorPasscodeNotSet: {
                        NSLog(@"设备系统未设置密码");
                    }
                        break;
                    case LAErrorBiometryNotAvailable: {
                        
                        NSLog(@"设备未设置Touch ID");
                    }
                        break;
                    case LAErrorBiometryNotEnrolled:  {
                        
                        NSLog(@"用户未录入指纹");
                    }
                        break;
                    case LAErrorBiometryLockout: {
                        // 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                        NSLog(@"Touch ID被锁，需要用户输入系统密码解锁");
                        // 往本地用户偏好设置里把touchIdIsLocked标识设置为yes，表示指纹识别被锁
                        [[NSUserDefaults standardUserDefaults] setObject:@(YES)forKey:@"touchIdIsLocked"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [ASFingerprintIdentification touchIdIsLockedWithContext:context];
                    }
                        break;
                    case LAErrorAppCancel: {
                        NSLog(@"用户不能控制情况下APP被挂起");
                    }
                        break;
                    case LAErrorInvalidContext: {
                        
                        NSLog(@"LAContext传递给这个调用之前已经失效");
                    }
                        break;
                    default: {
                        NSLog(@"其他情况");
                    }
                        break;
                }
            }
        });
    }];
}

/// 指纹验证被锁后调用输入密码解锁
+ (void)touchIdIsLockedWithContext:(LAContext *)context {
    
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"验证密码" reply:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
            
            NSLog(@"验证成功");
            // 把本地标识改为NO，表示指纹解锁解除锁定
            [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"touchIdIsLocked"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else{
            
            NSLog(@"验证失败");
        }
    }];
}

@end
