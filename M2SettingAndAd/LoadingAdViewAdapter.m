//
//  LoadingAdViewAdapter.m
//  M2Setting
//
//  Created by Chen Meisong on 14-9-12.
//  Copyright (c) 2014年 chenms.m2 All rights reserved.
//

#import "LoadingAdViewAdapter.h"

@implementation LoadingAdViewAdapter

#pragma mark - M2LoadingAdViewAdapterProtocol
- (NSInteger)showLoadingAdViewSeconds {
    return 2;
}
- (UIImage *)loadingImage {
    return nil;
}

- (BOOL)actionEnabled {
    return YES;
}
- (NSString *)linkURLString {
    return @"http://www.baidu.com";
}
- (NSNumber *)actionType {
    return [NSNumber numberWithInteger:0];
}


@end
