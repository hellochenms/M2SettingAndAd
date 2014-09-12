//
//  VersionUpdateAdapter.m
//  WeatherAF
//
//  Created by Chen Meisong on 14-9-11.
//  Copyright (c) 2014年 appfactory. All rights reserved.
//

#import "VersionUpdateAdapter.h"

@interface VersionUpdateAdapter ()<UIAlertViewDelegate>
@property (nonatomic, copy) void(^updateHandler)(NSString *iTunesURLString);
@property (nonatomic, copy) void(^skipCurVersionHandler)(void);
@property (nonatomic, copy) void(^laterRemindHandler)(void);
@end

@implementation VersionUpdateAdapter
- (NSString *)lastedVersion {
    NSString *lastedVersion = @"1.3.0";
    return lastedVersion;
}

- (void)showAlertViewWithUpdateHandler:(void(^)(NSString *iTunesURLString))updateHandler
                 skipCurVersionHandler:(void(^)(void))skipCurVersionHandler
                    laterRemindHandler:(void(^)(void))laterRemindHandler {
    self.updateHandler = updateHandler;
    self.skipCurVersionHandler = skipCurVersionHandler;
    self.laterRemindHandler = laterRemindHandler;
    // 弹出提示框
    NSString *title = @"应用1.3.0版本上线喽！";
    NSString *message = @"没有最漂亮只有更漂亮@赶快升级吧，亲！";
    NSMutableString * mutablemessage = [NSMutableString string];
    [[message componentsSeparatedByString:@"@"] enumerateObjectsUsingBlock:^(NSString * submessage, NSUInteger idx, BOOL *stop) {
        if ([mutablemessage length] > 0) {
            [mutablemessage appendString:@"\n"];
        }
        [mutablemessage appendString:submessage];
    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:mutablemessage
                                                       delegate:self
                                              cancelButtonTitle:@"稍后提醒"
                                              otherButtonTitles:@"更新", @"跳过该版本", nil];
    [alertView show];
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
