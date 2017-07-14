//
//  SubCategate_BrandViewController.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/10.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "SubCategate_BrandViewController.h"
#import "LeftSideSegmentView.h"
#import "BrandApplyViewController.h"

//tools
#import "UIView+CurrentViewController.h"

@interface SubCategate_BrandViewController ()<LeftSideSegmentViewDelegate>

@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)LeftSideSegmentView *leftSegment;
@property (nonatomic, strong)UIView *brandBGView;

@end

@implementation SubCategate_BrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorFromRGB(kLightGray);
    
    [self addBrandView];
    [self initLeftSideSegmentView];
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


#pragma mark - <添加“品牌申请入住”和“入驻品牌细则”>
-(void)addBrandView
{
    UIView *brandBGView = [[UIView alloc]init];
    [self.view addSubview:brandBGView];
    brandBGView.backgroundColor = kColorFromRGB(kLightGray);
    brandBGView.layer.cornerRadius = 2;
    [brandBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(35);
    }];
    self.brandBGView = brandBGView;
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"品牌申请入驻" forState:UIControlStateNormal];
    [btn1 setTitleColor:kColorFromRGB(kBlack) forState:UIControlStateNormal];
    [btn1 setBackgroundColor:kColorFromRGB(kWhite)];
    btn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.brandBGView addSubview:btn1];
    __weak typeof(self) weakSelf = self;
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_offset(0);
        make.right.equalTo(weakSelf.brandBGView.mas_centerX).with.offset(-1);
    }];
    [btn1 addTarget:self action:@selector(btn1ApplyForAdmission:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"入驻品牌细则" forState:UIControlStateNormal];
    [btn2 setTitleColor:kColorFromRGB(kBlack) forState:UIControlStateNormal];
    [btn2 setBackgroundColor:kColorFromRGB(kWhite)];
    btn2.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.brandBGView addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_offset(0);
        make.left.equalTo(btn1.mas_right).with.offset(2);
    }];
    [btn2 addTarget:self action:@selector(btn2RulesOfApply:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - <品牌申请入驻按钮响应>
-(void)btn1ApplyForAdmission:(UIButton *)sender
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ApplyForAdmission" object:nil];
    
}


#pragma mark - <入驻品牌细则按钮响应>
-(void)btn2RulesOfApply:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RulesOfApply" object:nil];
}



#pragma mark - <初始化左侧segmentView>
-(void)initLeftSideSegmentView
{
    NSArray *array = @[@"123",@"345",@"46465",@"3436",@"8578",@"6345",@"tr",@"rfvs",@"sfdf",@"6565",@"dfdf",@"8578",@"6345",@"tr"];
    self.dataArray = array;
    LeftSideSegmentView *leftSegment = [[LeftSideSegmentView alloc]initWithFrame:self.view.bounds dataArray:array];
    leftSegment.delegate = self;
    [self.view addSubview:leftSegment];
    __weak typeof(self) weakSelf = self;
    [leftSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.brandBGView.mas_bottom).with.offset(10);
    }];
    
    self.leftSegment = leftSegment;
}










#pragma mark - ******** LeftSideSegmentViewDelegate ********
-(void)leftSideSegmentView:(LeftSideSegmentView *)leftSideSegmentView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",self.dataArray[indexPath.row]);
    if (indexPath.row == 0) {
        self.view.backgroundColor = kColorFromRGB(kLightGray);
    }
}

@end
