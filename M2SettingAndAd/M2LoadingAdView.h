//
//  M2LoadingAdView.h
//  M2Setting
//
//  Created by Chen Meisong on 14-9-12.
//  Copyright (c) 2014年 chenms.m2 All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol M2LoadingAdViewAdapterProtocol;

static const NSInteger kM2LAV_defaultShowLoadingAdViewSeconds = 3;

@interface M2LoadingAdView : UIView
@property (nonatomic) NSObject<M2LoadingAdViewAdapterProtocol> *adapter;
- (void)showInView:(UIView *)view completionHandler:(void(^)(void))completionHandler;
@end

@protocol M2LoadingAdViewAdapterProtocol <NSObject>
@property (nonatomic) NSDate *imageUpdateDate;
- (NSInteger)showLoadingAdViewSeconds;
- (UIImage *)loadingImage;
- (BOOL)actionEnabled;
- (NSString *)linkURLString;
- (NSNumber *)actionType;// 0:应用内webView打开网页；1:跳转到应用外打开网页；
@end
