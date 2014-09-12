//
//  RootViewController.m
//  M2SettingAndAd
//
//  Created by Chen Meisong on 14-9-12.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSArray       *datas;
@property (nonatomic) UITableView   *tableView;
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.frame = self.view.bounds;
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

@end
