//
//  LoadingAdViewAdapter.h
//  M2Setting
//
//  Created by Chen Meisong on 14-9-12.
//  Copyright (c) 2014年 chenms.m2 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M2LoadingAdView.h"

@interface LoadingAdViewAdapter : NSObject<M2LoadingAdViewAdapterProtocol>
#pragma mark - M2LoadingAdViewAdapterProtocol
@property (nonatomic) NSDate *imageUpdateDate;
@end
