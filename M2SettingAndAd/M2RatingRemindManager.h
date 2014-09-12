//
//  M2RatingRemindManager.h
//  M2Setting
//
//  Created by Chen Meisong on 14-9-11.
//  Copyright (c) 2014年 chenms.m2 All rights reserved.
//
//  注1：应用首次进入前台时，不提示评分，而是自动跳过一个周期（相当于点击了“以后再说”），
//  原因：刚安装应用就提示用户去评分，可能会造成用户反感。
//  注2：应用进前台后，会延迟一段时间（kM2RRM_DelaySecondsAfterEnterForeground的值）才会弹出提示框，
//  原因：用户打开应用是有目的的，刚进入前台就弹出提示，可能会打断其思路，造成其反感。

#import <Foundation/Foundation.h>

static NSInteger const kM2RRM_DelaySecondsAfterEnterForeground = 5;
static NSInteger const kM2RRM_RatingRemindMinTimeInterval = 60 * 60 * 24 * 3;

@protocol M2RatingRemindProtocol;

@interface M2RatingRemindManager : NSObject
@property (nonatomic) id<M2RatingRemindProtocol> adapter;
+ (instancetype)sharedInstance;
@end

@protocol M2RatingRemindProtocol <NSObject>
- (BOOL)isNeedRemindRating;
- (NSInteger)ratingRemindTimeInterval;
- (void)showAlertViewWithUpdateHandler:(void(^)(NSString *iTunesURLString))updateHandler
                 skipCurVersionHandler:(void(^)(void))skipCurVersionHandler
                    laterRemindHandler:(void(^)(void))laterRemindHandler;
@end