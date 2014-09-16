//
//  _tempViewController.m
//  M2SettingAndAd
//
//  Created by Chen Meisong on 14-9-12.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "_tempViewController.h"

@interface _tempViewController ()
@end

@implementation _tempViewController

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    if (isIOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    double yModifier = (isIOS7 ? 20 : 0);
    backButton.frame = CGRectMake(10, yModifier + 7, 60, 30);
    backButton.backgroundColor = [UIColor blueColor];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onTapBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, yModifier + 44 + 7, 300, 30);
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTapButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)onTapBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onTapButton{
}

@end
