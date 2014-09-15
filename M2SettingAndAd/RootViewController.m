//
//  RootViewController.m
//  M2SettingAndAd
//
//  Created by Chen Meisong on 14-9-12.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "RootViewController.h"
#import "BannerAdView.h"

@interface RootViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSArray       *datas;
@property (nonatomic) UITableView   *tableView;
@property (nonatomic) BannerAdView  *bannerAdView;
@end

@implementation RootViewController

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        _datas  = @[
                    @[@"临时测试", @"_tempViewController"],
                    ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= (isIOS7 ? 0 : 20);
    
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datas count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [[self.datas objectAtIndex:indexPath.row] objectAtIndex:0];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = [[self.datas objectAtIndex:indexPath.row] objectAtIndex:1];
    UIViewController *subViewController = [NSClassFromString(className) new];
    [self.navigationController pushViewController:subViewController animated:YES];
}

#pragma mark - 广告banner
#pragma mark M2BannerLifeDelegate
- (UIView *)bannerView {
    return self.bannerAdView;
}
- (BOOL)showAdEnabled {
    return YES;
}
- (NSInteger)delayTimeSinceNoUserAction {
    return 5;
}
- (void)showAd {
    if (self.bannerAdView) {
        return;
    }
    self.bannerAdView = [[BannerAdView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.tableView.bounds) - 50, CGRectGetWidth(self.tableView.bounds), 50)];
    self.bannerAdView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.bannerAdView.alpha = 0;
    [self.view addSubview:self.bannerAdView];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25
                     animations:^{
                         weakSelf.bannerAdView.alpha = 1;
                     }];
}
- (void)hideAd {
    if (!self.bannerAdView) {
        return;
    }
    [self.bannerAdView removeFromSuperview];
    self.bannerAdView = nil;
}
@end
