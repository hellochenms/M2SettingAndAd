//
//  M2RatingRemindManager.m
//  M2Setting
//
//  Created by Chen Meisong on 14-9-11.
//  Copyright (c) 2014年 chenms.m2 All rights reserved.
//

#import "M2RatingRemindManager.h"

static NSString * const kM2RRM_UserDefaultsKey_RatingFinishVersion = @"kM2RRM_UserDefaultsKey_RatingFinishVersion";
static NSString * const kM2RRM_UserDefaultsKey_LastRatingRemindDate = @"kM2RRM_UserDefaultsKey_LastRatingRemindDate";

@implementation M2RatingRemindManager

+ (instancetype)sharedInstance {
    static M2RatingRemindManager *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [M2RatingRemindManager new];
    });
    
    return s_instance;
}

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onNotifyApplicationDidFinishLaunching)
                                                     name:UIApplicationDidFinishLaunchingNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onNotifyApplicationWillEnterForeground)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onNotifyApplicationDidEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
    }
    
    return self;
}

#pragma mark - 通知
- (void)onNotifyApplicationDidFinishLaunching {
//    NSLog(@"launch 完事  %s", __func__);
    [self tryRatingRemind];
}
- (void)onNotifyApplicationWillEnterForeground {
//    NSLog(@"will 进前台  %s", __func__);
    [self tryRatingRemind];
}
- (void)onNotifyApplicationDidEnterBackground {
//    NSLog(@"did 进后台 %s", __func__);
    [self cancelRatingRemind];
}

#pragma mark - 评分提醒
- (void)tryRatingRemind {
    [self performSelector:@selector(delayTryRatingRemind)
               withObject:nil
               afterDelay:kM2RRM_DelaySecondsAfterEnterForeground];
}
- (void)delayTryRatingRemind {
    BOOL isNeedRemindRating = [self.adapter isNeedRemindRating];
    if (!isNeedRemindRating) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lastRatingVersion = [userDefaults objectForKey:kM2RRM_UserDefaultsKey_RatingFinishVersion];
    if ([lastRatingVersion isEqualToString:[self curBundleVersion]]) {
        return;
    }
    NSDate *lastRatingDate = [userDefaults objectForKey:kM2RRM_UserDefaultsKey_LastRatingRemindDate];
    if (!lastRatingDate) {
        // 首次启动不要提示，用户会烦，一个周期后再说
        [userDefaults setObject:[NSDate date] forKey:kM2RRM_UserDefaultsKey_LastRatingRemindDate];
        [userDefaults synchronize];
        return;
    }
    double maxSeconds = MAX([self.adapter ratingRemindTimeInterval], kM2RRM_RatingRemindMinTimeInterval);
    if ([[NSDate date] timeIntervalSinceDate:lastRatingDate] > maxSeconds) {
        __weak typeof(self) weakSelf = self;
        [self.adapter showAlertViewWithUpdateHandler:^(NSString *iTunesURLString) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[weakSelf curBundleVersion] forKey:kM2RRM_UserDefaultsKey_RatingFinishVersion];
            [userDefaults removeObjectForKey:kM2RRM_UserDefaultsKey_LastRatingRemindDate];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesURLString]];
            [userDefaults synchronize];
        } skipCurVersionHandler:^{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[weakSelf curBundleVersion] forKey:kM2RRM_UserDefaultsKey_RatingFinishVersion];
            [userDefaults removeObjectForKey:kM2RRM_UserDefaultsKey_LastRatingRemindDate];
            [userDefaults synchronize];
        } laterRemindHandler:^{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[NSDate date] forKey:kM2RRM_UserDefaultsKey_LastRatingRemindDate];
            [userDefaults synchronize];
        }];
    }
}
- (void)cancelRatingRemind {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - tools
- (NSString *)curBundleVersion{
    NSString *curBundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    return curBundleVersion;
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
