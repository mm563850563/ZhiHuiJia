//
//  CategateViewController.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/5.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "CategateViewController.h"
#import "SegmentTapView.h"
#import "FlipTableView.h"

//controllers
#import "SubCategate_CategateViewController.h"
#import "SubCategate_BrandViewController.h"
#import "BrandApplyViewController.h"
#import "BrandRulesViewController.h"

@interface CategateViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate>

@property (nonatomic, strong)SegmentTapView *segment;
@property (nonatomic, strong)FlipTableView *flipView;
@property (strong, nonatomic) NSMutableArray *controllsArray;

@end

@implementation CategateViewController

#pragma mark - <懒加载>
-(NSMutableArray *)controllsArray
{
    if (!_controllsArray) {
        _controllsArray = [[NSMutableArray alloc]init];
    }
    return _controllsArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initSegment];
    [self initFlipTableView];
    [self respondWithRAC];
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


#pragma mark - <添加segmentView>
-(void)initSegment{
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40) withDataArray:[NSArray arrayWithObjects:@"分类",@"品牌馆", nil] withFont:15];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
}

#pragma mark - <添加flipTableView>
-(void)initFlipTableView{
    SubCategate_CategateViewController *subCategate_categateVC = [[SubCategate_CategateViewController alloc]init];
    SubCategate_BrandViewController *subCategate_brandVC = [[SubCategate_BrandViewController alloc]init];
    
    [self.controllsArray addObject:subCategate_categateVC];
    [self.controllsArray addObject:subCategate_brandVC];
    
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, self.segment.frame.size.height, kSCREEN_WIDTH, self.view.frame.size.height - 156) withArray:_controllsArray];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
//    __weak typeof(self) weakSelf = self;
    [self.flipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(40);
    }];
    
    
   
}

#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"ApplyForAdmission" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        BrandApplyViewController *brandApplyVC = [[BrandApplyViewController alloc]init];
        brandApplyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:brandApplyVC animated:YES];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"RulesOfApply" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        BrandRulesViewController *brandRulesVC = [[BrandRulesViewController alloc]init];
        brandRulesVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:brandRulesVC animated:YES];
    }];
}








#pragma mark - ******** SegmentTapViewDelegate *********
-(void)selectedIndex:(NSInteger)index
{
    [self.flipView selectIndex:index];
    
}

#pragma mark - ******* FlipTableViewDelegate *******
-(void)scrollChangeToIndex:(NSInteger)index
{
    [self.segment selectIndex:index];
}






@end
