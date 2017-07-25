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

//cells
#import "Categate_BrandCollectionCell.h"

//views
#import "Categate_Brand_HeaderView.h"

@interface SubCategate_BrandViewController ()<LeftSideSegmentViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)LeftSideSegmentView *leftSegment;
@property (nonatomic, strong)UIView *brandBGView;
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)UICollectionView *rightCollectionView;

@end

@implementation SubCategate_BrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorFromRGB(kLightGray);
    
    [self addBrandView];
    [self initLeftSideSegmentView];
    [self initRightContentView];
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
    brandBGView.layer.cornerRadius = 3;
    brandBGView.layer.masksToBounds = YES;
    [brandBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(38);
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

#pragma mark - <初始化rightContentView>
-(void)initRightContentView
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout.minimumLineSpacing = 5;
    self.flowLayout.minimumInteritemSpacing = 5;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
//    CGFloat itemWidth = self.leftSegment.rightContentView.frame.size.width/3.2;
//    CGFloat itemHeight = itemWidth/2.0*3.0;
//    self.flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
//    CGFloat headerWidth = self.leftSegment.rightContentView.frame.size.width;
//    CGFloat headerHeight = (headerWidth-10)/3.0*2.0 + 100;
//    self.flowLayout.headerReferenceSize = CGSizeMake(headerWidth, headerHeight);
    
    self.rightCollectionView = [[UICollectionView alloc]initWithFrame:self.leftSegment.rightContentView.bounds collectionViewLayout:self.flowLayout];
    self.rightCollectionView.showsVerticalScrollIndicator = NO;
    self.rightCollectionView.backgroundColor = kColorFromRGB(kWhite);
    self.rightCollectionView.delegate = self;
    self.rightCollectionView.dataSource = self;
    [self.leftSegment.rightContentView addSubview:self.rightCollectionView];
    [self.rightCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UINib *nibNormalCell = [UINib nibWithNibName:NSStringFromClass([Categate_BrandCollectionCell class]) bundle:nil];
    [self.rightCollectionView registerNib:nibNormalCell forCellWithReuseIdentifier:NSStringFromClass([Categate_BrandCollectionCell class])];
    
    UINib *nibHeaderView = [UINib nibWithNibName:NSStringFromClass([Categate_Brand_HeaderView class]) bundle:nil];
    [self.rightCollectionView registerNib:nibHeaderView forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([Categate_Brand_HeaderView class])];
}


















#pragma mark - ******** LeftSideSegmentViewDelegate ********
-(void)leftSideSegmentView:(LeftSideSegmentView *)leftSideSegmentView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",self.dataArray[indexPath.row]);
    if (indexPath.row == 0) {
        self.view.backgroundColor = kColorFromRGB(kLightGray);
    }
}


#pragma mark - **** UICollectionViewDelegate,UICollectionViewDataSource ***
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Categate_BrandCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Categate_BrandCollectionCell class]) forIndexPath:indexPath];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    Categate_Brand_HeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([Categate_Brand_HeaderView class]) forIndexPath:indexPath];
    return view;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"selectHotSalesProductItem" object:indexPath];
}


#pragma mark - *** UICollectionViewDelegateFlowLayout ***
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat headerWidth = self.leftSegment.rightContentView.frame.size.width;
    CGFloat headerHeight = (headerWidth-10)/3.0*2.0 + 100;
    return CGSizeMake(headerWidth, headerHeight);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = (self.leftSegment.rightContentView.frame.size.width-20)/3.2;
    CGFloat itemHeight = itemWidth/2.0*3.0;
    return CGSizeMake(itemWidth, itemHeight);
}


@end
