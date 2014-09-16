//
//  M2SAAWindow.m
//  M2SettingAndAd
//
//  Created by Chen Meisong on 14-9-15.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "M2SAAWindow.h"
#import "M2BannerLifeManager.h"

@implementation M2SAAWindow
- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    [[M2BannerLifeManager sharedInstance] sendEvent:event fromWindow:self];
}

@end
