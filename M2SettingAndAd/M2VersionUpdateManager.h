//
//  VersionUpdateManager.h
//  M2Setting
//
//  Created by Chen Meisong on 14-9-11.
//  Copyright (c) 2014年 chenms.m2 All rights reserved.
//
//  本类和VersionUpdateAdapter类（实现M2VersionUpdateAdapterProtocol的类）配合使用；
//  本类封装了通用的检查更新逻辑；
//  VersionUpdateAdapter提供必要的参数（如最新版本）及UI层的展示（弹出alertView）
//  由于每个应用都可能有自定义的config类及alertView，故VersionUpdateAdapter的实现随应用而变，但对本类开放的接口是一致的。

#import <Foundation/Foundation.h>

static NSString * const    kM2VUM_VersionSeperator = @".";//支持x.y.z这种形式的字符串版本号
static NSInteger const     kM2VUM_VersionTipMinTimeInterval = 60 * 60 * 24 * 3;

@protocol M2VersionUpdateAdapterProtocol;

@interface M2VersionUpdateManager : NSObject
@property (nonatomic) id<M2VersionUpdateAdapterProtocol> adapter;
+ (instancetype)sharedInstance;
@end

@protocol M2VersionUpdateAdapterProtocol <NSObject>
- (NSString *)lastedVersion;
- (void)showAlertViewWithUpdateHandler:(void(^)(NSString *iTunesURLString))updateHandler
                 skipCurVersionHandler:(void(^)(void))skipCurVersionHandler
                    laterRemindHandler:(void(^)(void))laterRemindHandler;
@end
