//
//  ProductDetailViewController.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/11.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ProductDetailViewController.h"
#import <RatingBar.h>

@interface ProductDetailViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForScrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *starBarBGView;
@property (nonatomic, strong)RatingBar *starBar;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addRatingBar];
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


#pragma mark - <添加ratingBar>
-(void)addRatingBar
{
    self.starBar = [[RatingBar alloc]init];
    [self.starBarBGView addSubview:self.starBar];
    self.starBar.starNumber = 3;
    self.starBar.viewColor = [UIColor yellowColor];
    __weak typeof(self) weakSelf = self;
    [self.starBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(weakSelf.starBarBGView);
    }];
}

@end
