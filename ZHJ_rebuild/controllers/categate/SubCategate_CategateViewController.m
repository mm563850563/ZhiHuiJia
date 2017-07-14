//
//  SubCategate_CategateViewController.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/10.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "SubCategate_CategateViewController.h"
#import "LeftSideSegmentView.h"

@interface SubCategate_CategateViewController ()<LeftSideSegmentViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)LeftSideSegmentView *leftSegment;
@property (nonatomic, strong)UICollectionView *rightCollectionView;

@end

@implementation SubCategate_CategateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLeftSideSegmentView];
    [self initRightCollectionView];
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





#pragma mark - <初始化左侧segmentView>
-(void)initLeftSideSegmentView
{
    NSArray *array = @[@"123",@"345",@"46465",@"3436",@"8578",@"6345",@"345",@"46465",@"3436",@"8578",@"6345",@"345",@"46465",@"3436",@"8578",@"6345"];
    self.dataArray = array;
    LeftSideSegmentView *leftSegment = [[LeftSideSegmentView alloc]initWithFrame:self.view.bounds dataArray:array];
    leftSegment.delegate = self;
    [self.view addSubview:leftSegment];
    __weak typeof(self) weakSelf = self;
    [leftSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf.view);
    }];
    
    self.leftSegment = leftSegment;
}

#pragma mark - <初始化右侧collectionView>
-(void)initRightCollectionView
{
    CGFloat width = self.leftSegment.rightContentView.frame.size.width;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.headerReferenceSize = CGSizeMake(width, 30);
    flowLayout.itemSize = CGSizeMake(width/3.5, 60);
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    
    self.rightCollectionView = [[UICollectionView alloc]initWithFrame:self.leftSegment.rightContentView.bounds collectionViewLayout:flowLayout];
    self.rightCollectionView.backgroundColor = kClearColor;
    self.rightCollectionView.delegate = self;
    self.rightCollectionView.dataSource = self;
    
    [self.leftSegment.rightContentView addSubview:self.rightCollectionView];
    [self.rightCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //注册分区头cell
    [self.rightCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    //注册cell
    [self.rightCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}





#pragma mark - ******** LeftSideSegmentViewDelegate ********
-(void)leftSideSegmentView:(LeftSideSegmentView *)leftSideSegmentView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",self.dataArray[indexPath.row]);
}


#pragma mark - ****** UICollectionViewDataSource,UICollectionViewDelegate ******
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 10;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = kColorFromRGB(0x000567);
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
//    view.backgroundColor = kColorFromRGB(kBlack);
    UILabel *label=[[UILabel alloc]init];
    
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    label.font = [UIFont systemFontOfSize:12];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        label.text = @"小电器";
    }
    return view;
}




-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
}

@end
