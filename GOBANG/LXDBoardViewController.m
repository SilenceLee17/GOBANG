//
//  LXDBoardViewController.m
//  GOBANG
//
//  Created by 李兴东 on 17/3/2.
//  Copyright © 2017年 xingshao. All rights reserved.
//

#import "LXDBoardViewController.h"
#import "LXDBoardView.h"

@interface LXDBoardViewController ()

@property (nonatomic, strong) LXDBoardView *boardView;


@end

@implementation LXDBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)setupSubviews{
    self.view.backgroundColor = [UIColor whiteColor];
    _boardView = [[LXDBoardView alloc] initWithFrame:CGRectMake(15, 50, [UIScreen mainScreen].bounds.size.width - 30 , [UIScreen mainScreen].bounds.size.width - 30)];
    _boardView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_boardView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
