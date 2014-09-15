//
//  M2BannerLifeManager.h
//  M2Setting
//
//  Created by Chen Meisong on 14-9-12.
//  Copyright (c) 2014年 chenms.m2 All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString * const kM2BLM_NotificationName_ShowAd;
FOUNDATION_EXTERN NSString * const kM2BLM_NotificationName_HideAd;

@protocol M2BannerLifeDelegate;

@interface M2BannerLifeManager : NSObject
@property (nonatomic, weak) id<M2BannerLifeDelegate> delegate;
+ (instancetype)sharedInstance;
- (void)sendEvent:(UIEvent *)event fromWindow:(UIWindow *)window;
@end

@protocol M2BannerLifeDelegate <NSObject>
- (UIView *)bannerView;
- (BOOL)showAdEnabled;
- (NSInteger)delayTimeSinceNoUserAction;
- (void)showAd;
- (void)hideAd;
@end

/*
 UIWindow的子类需要重写sendEvent:方法，调用本类的sendEvent:fromWindow:方法
 - (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
 
    [[M2BannerLifeManager sharedInstance] sendEvent:event fromWindow:self];
 }
*/