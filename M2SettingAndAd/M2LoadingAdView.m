//
//  M2LoadingAdView.m
//  M2Setting
//
//  Created by Chen Meisong on 14-9-12.
//  Copyright (c) 2014年 chenms.m2 All rights reserved.
//

#import "M2LoadingAdView.h"

@interface M2LoadingAdView()
@property (nonatomic) UIImageView       *loadingImageView;
@property (nonatomic) UIImageView       *nameCopyrightImageView;
@property (nonatomic) UIWebView         *webView;
@property (nonatomic) NSTimer           *timer;
@property (nonatomic, copy)             void(^completionHandler)(void) ;
@property (nonatomic) NSTimeInterval    remainTimeInterval;
@property (nonatomic) NSInteger         showLoadingAdViewSeconds;
@end

@implementation M2LoadingAdView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        UIView *contentContainerView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:contentContainerView];
        
        _loadingImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _loadingImageView.contentMode = UIViewContentModeScaleAspectFill;
        _loadingImageView.clipsToBounds = YES;
        [contentContainerView addSubview:_loadingImageView];
        
        double originY = (isIOS7 ? 380 : 320);
        UIView *loadingImageViewCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, CGRectGetWidth(contentContainerView.bounds), CGRectGetHeight(contentContainerView.bounds) - originY)];
        loadingImageViewCoverView.backgroundColor = [UIColor whiteColor];
        [contentContainerView addSubview:loadingImageViewCoverView];
        
        _nameCopyrightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _nameCopyrightImageView.image = [UIImage imageNamed:@"loading_tips"];
        [contentContainerView addSubview:_nameCopyrightImageView];
        
        
        CGRect loadingImageViewFrame = _loadingImageView.frame;
        loadingImageViewFrame.size = [self loadingViewSizeFromSrcImage:_loadingImageView.image];
        _loadingImageView.frame = loadingImageViewFrame;
        double offsetY = (isIOS7 ? 20 : 0);
        BOOL is4Inch = ([UIScreen mainScreen].bounds.size.height > 480);
        if (is4Inch) {
            _nameCopyrightImageView.frame = CGRectMake(15, 424 + offsetY, 290, 50);
        }
        else {
            _nameCopyrightImageView.frame = CGRectMake(15, 348 + offsetY, 290, 50);
        }
        
        // tap
        UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapContent)];
        [contentContainerView addGestureRecognizer:tapRec];
        
        // webView
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame), CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self addSubview:_webView];
        
        UIView * tinView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_webView.bounds), 30)];
        tinView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.45];
        [_webView addSubview:tinView];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"loading_close_btn"] forState:UIControlStateNormal];
        button.frame = CGRectMake(CGRectGetWidth(tinView.bounds) - 30, 0, 30, 30);
        [button addTarget:self action:@selector(closeWebview) forControlEvents:UIControlEventTouchUpInside];
        [tinView addSubview:button];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onApplicationWillEnterForeground)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    
    return self;
}

#pragma mark - setter/getter
- (void)setAdapter:(NSObject<M2LoadingAdViewAdapterProtocol> *)adapter {
    [_adapter removeObserver:self forKeyPath:@"imageUpdateDate"];
    _adapter = nil;
    if (![adapter respondsToSelector:@selector(showLoadingAdViewSeconds)]
        || ![adapter respondsToSelector:@selector(loadingImage)]
        || ![adapter respondsToSelector:@selector(actionEnabled)]
        || ![adapter respondsToSelector:@selector(linkURLString)]
        || ![adapter respondsToSelector:@selector(actionType)]) {
        return;
    }
    _adapter = adapter;
    [_adapter addObserver:self
               forKeyPath:@"imageUpdateDate"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    self.loadingImageView.image = [_adapter loadingImage];
}

#pragma mark - 显示loadingAd view
- (void)showInView:(UIView *)view completionHandler:(void(^)(void))completionHandler {
    [view addSubview:self];
    self.completionHandler = completionHandler;
    [self.timer invalidate];
    self.showLoadingAdViewSeconds = kM2LAV_defaultShowLoadingAdViewSeconds;
    if (self.adapter) {
        NSInteger seconds = [self.adapter showLoadingAdViewSeconds];
        if (seconds > 0) {
            self.showLoadingAdViewSeconds = seconds;
        }
    }
    self.remainTimeInterval = self.showLoadingAdViewSeconds;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.remainTimeInterval
                                                  target:self
                                                selector:@selector(onTimerFire:)
                                                userInfo:nil
                                                 repeats:NO];
}
- (void)onTimerFire:(NSTimer *)timer{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.382
                     animations:^{
                         weakSelf.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [weakSelf removeFromSuperview];
                         if (weakSelf.completionHandler) {
                             weakSelf.completionHandler();
                         }
                     }];
}

#pragma mark - user event
- (void)onTapContent{
    if (!self.adapter) {
        return;
    }
    // check
    if (![self.adapter actionEnabled]) {
        return;
    }
    if (!self.loadingImageView.image) {
        return;
    }
    NSString *linkString = [self.adapter linkURLString];
    if ([linkString length] <= 0) {
        return;
    }
    NSNumber *type = [self.adapter actionType];
    if (!type || [type integerValue] < 0) {
        return;
    }
    
    // 跳转
    // webView加载itunesURL时会跳出应用，故监测到itunesURL直接判定为跳出App显示
    NSString *JumpOutOfApplinkPrefix = @"https://itunes.apple.com";
    NSInteger typeValue = [type integerValue];
    if (typeValue == 0 && ![linkString hasPrefix:JumpOutOfApplinkPrefix]) {
        self.remainTimeInterval = [self.timer.fireDate timeIntervalSinceNow];
        [self.timer invalidate];
        self.timer = nil;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:linkString]]];
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25
                         animations:^{
                             CGRect webViewFrame = weakSelf.webView.frame;
                             webViewFrame.origin.y = 0;
                             weakSelf.webView.frame = webViewFrame;
                         }];
    } else if (typeValue == 1 || [linkString hasPrefix:JumpOutOfApplinkPrefix]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkString]];
    }
}

- (void)closeWebview{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25
                     animations:^{
                         CGRect webViewFrame = weakSelf.webView.frame;
                         webViewFrame.origin.y = CGRectGetHeight(weakSelf.bounds);
                         weakSelf.webView.frame = webViewFrame;
                     } completion:^(BOOL finished) {
                         weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:self.remainTimeInterval
                                                                       target:self
                                                                     selector:@selector(onTimerFire:)
                                                                     userInfo:nil
                                                                      repeats:NO];
                     }];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"imageUpdateDate"]) {
        self.loadingImageView.image = [self.adapter loadingImage];
        CGRect frame = self.loadingImageView.frame;
        frame.size = [self loadingViewSizeFromSrcImage:self.loadingImageView.image];
        self.loadingImageView.frame = frame;
    }
}

#pragma mark - 通知
- (void)onApplicationWillEnterForeground {
//    NSLog(@"will 进前台  %s", __func__);
    // 处理服务端指定使用webView显示，但实际上webView加载URL时会跳出应用的情况（如iTunes链结）
    if (self.webView.frame.origin.y == 0) {
//        NSLog(@"需要收起loadingAd webView  %s", __func__);
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25
                         animations:^{
                             CGRect webViewFrame = weakSelf.webView.frame;
                             webViewFrame.origin.y = CGRectGetHeight(weakSelf.bounds);
                             weakSelf.webView.frame = webViewFrame;
                         }];
        
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.remainTimeInterval
                                                              target:self
                                                            selector:@selector(onTimerFire:)
                                                            userInfo:nil
                                                             repeats:NO];
        }
    }
}

#pragma mark - tools
- (CGSize)loadingViewSizeFromSrcImage:(UIImage *)srcImage {
    double width = 320;
    if (srcImage.size.width == 0 || srcImage.size.height == 0) {
        return (isIOS7 ? CGSizeMake(width, 380) : CGSizeMake(width, 320));
    }
    double factor = srcImage.size.width / srcImage.size.height;
    double height = floor(width / factor);
    
    return CGSizeMake(width, height);
}

#pragma mark - dealloc
- (void)dealloc{
    [self.adapter removeObserver:self forKeyPath:@"imageUpdateDate"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
