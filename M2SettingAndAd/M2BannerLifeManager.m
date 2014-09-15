//
//  M2BannerLifeManager.m
//  M2Setting
//
//  Created by Chen Meisong on 14-9-12.
//  Copyright (c) 2014年 chenms.m2 All rights reserved.
//

#import "M2BannerLifeManager.h"

NSString * const kM2BLM_NotificationName_ShowAd = @"kM2BLM_NotificationName_ShowAd";
NSString * const kM2BLM_NotificationName_HideAd = @"kM2BLM_NotificationName_HideAd";

@interface M2BannerLifeManager ()
@property (nonatomic) NSTimer   *showAdTimer;
@property (nonatomic) NSDate    *lastEventDate;
@end

@implementation M2BannerLifeManager
+ (instancetype)sharedInstance {
    static M2BannerLifeManager *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [M2BannerLifeManager new];
    });
    
    return s_instance;
}

- (id)init{
    self = [super init];
    if (self) {
        _lastEventDate = [NSDate date];
        _showAdTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                        target:self
                                                      selector:@selector(onShowAdTimerFire)
                                                      userInfo:nil
                                                       repeats:YES];
    }
    
    return self;
}

#pragma mark - 监听keyWindow的用户事件
- (void)sendEvent:(UIEvent *)event fromWindow:(UIWindow *)window{
    self.lastEventDate = [NSDate date];
    
    if (!event
        || !self.delegate
        || ![self.delegate respondsToSelector:@selector(delayTimeSinceNoUserAction)]
        || ![self.delegate respondsToSelector:@selector(bannerView)]
        || ![self.delegate respondsToSelector:@selector(hideAd)]) {
        return;
    }
    
    // delayTimeSinceNoUserAction <= 0认为bannerView是始终显示的。
    NSInteger delayTimeSinceNoUserAction = [self.delegate delayTimeSinceNoUserAction];
    if (delayTimeSinceNoUserAction <= 0) {
        return;
    }
    
    UIView *bannerView = [self.delegate bannerView];
    if (!bannerView) {
        return;
    }
    
    __block BOOL touchInAdsView = NO;
    [[event touchesForWindow:window] enumerateObjectsUsingBlock:^(UITouch *touch, BOOL *stop) {
        touchInAdsView = CGRectContainsPoint(bannerView.bounds, [touch locationInView:bannerView]);
        *stop = touchInAdsView;
    }];
    
    if (!touchInAdsView) {
        [self.delegate hideAd];
    }
}

#pragma mark - 定时任务，尝试展示banner
- (void)onShowAdTimerFire {
    if (!self.delegate
        || ![self.delegate respondsToSelector:@selector(showAdEnabled)]
        || ![self.delegate showAdEnabled]
        || ![self.delegate respondsToSelector:@selector(delayTimeSinceNoUserAction)]
        || ![self.delegate respondsToSelector:@selector(showAd)]) {
        return;
    }
    NSInteger delayTimeSinceNoUserAction = [self.delegate delayTimeSinceNoUserAction];
    if ([[NSDate date] timeIntervalSinceDate:self.lastEventDate] > delayTimeSinceNoUserAction) {
#warning TODO:chenms
        self.lastEventDate = [NSDate date];
        [self.delegate showAd];
    }
}


@end
