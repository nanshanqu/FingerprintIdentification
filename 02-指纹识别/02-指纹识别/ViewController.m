//
//  ViewController.m
//  02-指纹识别
//
//  Created by Mac on 2020/4/16.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "ASFingerprintIdentification.h"

@interface ViewController ()

// 本地认证上下文联系对象
@property(nonatomic,strong) LAContext * context;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/// 方式一
- (IBAction)loginClick1 {
    
    //获得当前系统版本号
       float version = [UIDevice currentDevice].systemVersion.floatValue;
       
       if (version < 8.0) {
           
           NSLog(@"系统版本过低，请升级系统");
           return;
       }
    
    // 本地认证上下文联系对象，每次使用指纹识别验证功能都要重新初始化，否则会一直显示验证成功。
    self.context = [[LAContext alloc] init];
    NSError * error = nil;
    //验证是否具有指纹认证功能
    BOOL canEvaluatePolicy = [self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    if (canEvaluatePolicy) {
        NSLog(@"有指纹认证功能");
        
        // 指纹认证错误后的第二个按钮文字（不写默认为“输入密码”）
        self.context.localizedFallbackTitle = @"add some data";
        
        // 调用指纹验证
        [ASFingerprintIdentification fingerprintIdentificationWithContext1:self.context];
        
    } else {
        NSLog(@"设备不支持指纹识别功能");
    }
}


/// 方式二
- (IBAction)loginClick2 {
    
    //获得当前系统版本号
    float version = [UIDevice currentDevice].systemVersion.floatValue;
    
    if (version < 8.0) {
        
        NSLog(@"系统版本过低，请升级系统");
        return;
    }
    
    // 本地认证上下文联系对象，每次使用指纹识别验证功能都要重新初始化，否则会一直显示验证成功。
    self.context = [[LAContext alloc] init];
    NSError * error = nil;
    //验证是否具有指纹认证功能
    BOOL canEvaluatePolicy = [self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    if (canEvaluatePolicy) {
        NSLog(@"有指纹认证功能");
        
        // 指纹认证错误后的第二个按钮文字（不写默认为“输入密码”）
        self.context.localizedFallbackTitle = @"add some data";
        
        // 调用指纹验证
        [ASFingerprintIdentification fingerprintIdentificationWithContext2:self.context];
        
    } else {
        
        NSLog(@"设备不支持指纹识别功能");
        // 没有指纹认证功能有可能是输入错误次数达到5次，认证功能被锁导致。
        BOOL isLock = (BOOL)[[NSUserDefaults standardUserDefaults] objectForKey:@"touchIdIsLocked"];
        
        if (isLock) {
            
            // 认证被锁处理
            [ASFingerprintIdentification touchIdIsLockedWithContext:self.context];
        }
    }
}





@end
