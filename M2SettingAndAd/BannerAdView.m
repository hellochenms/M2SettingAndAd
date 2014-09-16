//
//  BannerView.m
//  M2Setting
//
//  Created by Chen Meisong on 14-9-12.
//  Copyright (c) 2014年 chenms.m2 All rights reserved.
//

#import "BannerAdView.h"

@implementation BannerAdView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *bannerLabel = [[UILabel alloc] initWithFrame:self.bounds];
        bannerLabel.textAlignment = NSTextAlignmentCenter;
        bannerLabel.backgroundColor = [UIColor whiteColor];
        bannerLabel.text = @"广告条";
        [self addSubview:bannerLabel];
    }
    
    return self;
}

@end
