//
//  VersionUpdateManager.m
//  M2Setting
//
//  Created by Chen Meisong on 14-9-11.
//  Copyright (c) 2014年 chenms.m2 All rights reserved.
//
//  使用UIApplicationDidFinishLaunchingNotification + UIApplicationWillEnterForegroundNotification的组合（目前两者是互斥的，如果有一天不互斥也不能使用了），而不使用UIApplicationDidBecomeActiveNotification的原因是：
//  首次启动应用时如果有定位提示等系统AlertView弹出时，UIApplicationDidBecomeActiveNotification通知会有多次，像版本更新提示这种应用进前台只能触发一次的操作，就不适合监听UIApplicationDidBecomeActiveNotification。

#import "M2VersionUpdateManager.h"
#import "VersionUpdateAdapter.h"

static NSString * const kM2VUM_UserDefaultsKey_LastSkipVersion = @"kM2VUM_UserDefaultsKey_LastSkipVersion";
static NSString * const kM2VUM_UserDefaultsKey_LastVersionTipsDate = @"kM2VUM_UserDefaultsKey_LastVersionTipsDate";

@interface M2VersionUpdateManager ()
@end

@implementation M2VersionUpdateManager
+ (instancetype)sharedInstance{
    static M2VersionUpdateManager *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [M2VersionUpdateManager new];
    });
    
    return s_instance;
}

- (id)init{
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
    }
    
    return self;
}

#pragma mark - 检查更新
- (void)checkVersionUpdate{
    NSString *lastedVersion = [self.adapter lastedVersion];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lastSkipVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kM2VUM_UserDefaultsKey_LastSkipVersion];
    NSDate *lastVesionTipsDate = [userDefaults objectForKey:kM2VUM_UserDefaultsKey_LastVersionTipsDate];
    if ([self isLastedVersion:lastedVersion freshThanOldVersion:lastSkipVersion]
        && [self isLastedVersion:lastedVersion freshThanOldVersion:[self curBundleVersion]]
        && (!lastVesionTipsDate || [[NSDate date] timeIntervalSinceDate:lastVesionTipsDate] > kM2VUM_VersionTipMinTimeInterval)) {
        [self.adapter showAlertViewWithUpdateHandler:^(NSString *iTunesURLString) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesURLString]];
        } skipCurVersionHandler:^{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:lastedVersion forKey:kM2VUM_UserDefaultsKey_LastSkipVersion];
            [userDefaults synchronize];
        } laterRemindHandler:^{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[NSDate date] forKey:kM2VUM_UserDefaultsKey_LastVersionTipsDate];
            [userDefaults synchronize];
        }];
    }
}

#pragma mark - 通知
- (void)onNotifyApplicationDidFinishLaunching{
//    NSLog(@"launch 完事  %s", __func__);
    [self checkVersionUpdate];
}
- (void)onNotifyApplicationWillEnterForeground{
//    NSLog(@"will 进前台  %s", __func__);
    [self checkVersionUpdate];
}

#pragma mark - tools
- (BOOL)isLastedVersion:(NSString *)lastedVersion freshThanOldVersion:(NSString *)oldVersion{
    return [self isLastedVersionComponents:[lastedVersion componentsSeparatedByString:kM2VUM_VersionSeperator]
             freshThanOldVersionComponents:[oldVersion componentsSeparatedByString:kM2VUM_VersionSeperator]];
}
- (BOOL)isLastedVersionComponents:(NSArray *)lastedComponents freshThanOldVersionComponents:(NSArray *)oldVersionComponents {
    if ([lastedComponents count] <= 0) {
        return NO;
    }
    if ([oldVersionComponents count] <= 0) {
        return YES;
    }
    
    for (NSUInteger i = 0; i < oldVersionComponents.count; i++) {
        NSString * lastedComponent = [lastedComponents objectAtIndex:i];
        if ([lastedComponent length] <= 0) {
            return NO;
        }
        NSString * oldVersionComponent = [oldVersionComponents objectAtIndex:i];
        if ([oldVersionComponent length] > 0) {
            NSInteger lastedIndex = [lastedComponent integerValue];
            NSInteger oldIndex = [oldVersionComponent integerValue];
            if (lastedIndex > oldIndex) {
                return YES;
            }
        }
    }
    
    return NO;
}
- (NSString *)curBundleVersion{
    NSString *curBundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    return curBundleVersion;
}


#pragma mark - dealloc
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
