//
//  RatingRemindAdapter.m
//  M2Setting
//
//  Created by Chen Meisong on 14-9-11.
//  Copyright (c) 2014年 chenms.m2 All rights reserved.
//

#import "RatingRemindAdapter.h"

@interface RatingRemindAdapter ()<UIAlertViewDelegate>
@property (nonatomic, copy) void(^updateHandler)(NSString *iTunesURLString);
@property (nonatomic, copy) void(^skipCurVersionHandler)(void);
@property (nonatomic, copy) void(^laterRemindHandler)(void);
@end

@implementation RatingRemindAdapter
#pragma mark - M2RatingRemindProtocol
- (BOOL)isNeedRemindRating {
    return YES;
}
- (NSInteger)ratingRemindTimeInterval {
    return 60 * 60 * 24 * 3;
}
- (void)showAlertViewWithUpdateHandler:(void(^)(NSString *iTunesURLString))updateHandler
                 skipCurVersionHandler:(void(^)(void))skipCurVersionHandler
                    laterRemindHandler:(void(^)(void))laterRemindHandler {
    self.updateHandler = updateHandler;
    self.skipCurVersionHandler = skipCurVersionHandler;
    self.laterRemindHandler = laterRemindHandler;
    NSString *title = @"给开发者些鼓励和支持吧！";
    NSString *message = @"我们提供的服务，您还满意吗？";
    NSString *acceptButtonTitle = @"去评分";
    NSString *refuseButtonTitle = @"残忍的拒绝";
    if ([title length] <= 0
        || [message length] <= 0
        || [acceptButtonTitle length] <= 0
        || [refuseButtonTitle length] <= 0) {
        return;
    }
    UIAlertView *ratingAlertView = [[UIAlertView alloc] initWithTitle:title
                                                              message:message
                                                             delegate:self
                                                    cancelButtonTitle:@"以后再说"
                                                    otherButtonTitles:acceptButtonTitle, refuseButtonTitle, nil];
    [ratingAlertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (self.laterRemindHandler) {
            self.laterRemindHandler();
        }
    } else if (buttonIndex == 1) {
        if (self.updateHandler) {
            NSString *iTunesURLString = @"http://www.baidu.com";
            self.updateHandler(iTunesURLString);
        }
    } else if (buttonIndex == 2) {
        if (self.skipCurVersionHandler) {
            self.skipCurVersionHandler();
        }
    }
}

@end
