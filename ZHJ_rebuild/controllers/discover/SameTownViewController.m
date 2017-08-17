//
//  SameTownViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SameTownViewController.h"

//views
#import "SegmentTapView.h"
#import "FlipTableView.h"

//cells
#import "LookAroundCell.h"

//controllers
#import "SameTownTopicViewController.h"
#import "HandpickActivitiesViewController.h"
#import "LookAroundViewController.h"

@interface SameTownViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *collectionBGView;
@property (weak, nonatomic) IBOutlet UIView *segmentBGView;
@property (weak, nonatomic) IBOutlet UIView *flipBGView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong)SegmentTapView *segmentView;
@property (nonatomic, strong)FlipTableView *flipView;

@end

@implementation SameTownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initSegmentView];
    [self initFlipView];
    [self settingCollectionView];
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

#pragma mark - <初始化segmentView>
-(void)initSegmentView
{
    NSArray *array = @[@"同城话题",@"精选活动"];
    self.segmentView = [[SegmentTapView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, self.segmentBGView.frame.size.height) withDataArray:array withFont:14];
    self.segmentView.delegate = self;
    [self.segmentBGView addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

#pragma mark - <初始化flipView>
-(void)initFlipView
{
    SameTownTopicViewController *sameTownTopicVC = [[SameTownTopicViewController alloc]initWithNibName:NSStringFromClass([SameTownTopicViewController class]) bundle:nil];
    HandpickActivitiesViewController *handpickVC = [[HandpickActivitiesViewController alloc]initWithNibName:NSStringFromClass([HandpickActivitiesViewController class]) bundle:nil];
    
    NSMutableArray *vcArray = [NSMutableArray array];
    [vcArray addObject:sameTownTopicVC];
    [vcArray addObject:handpickVC];
    
    self.flipView = [[FlipTableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, self.flipBGView.frame.size.height) withArray:vcArray];
    self.flipView.delegate = self;
    [self.flipBGView addSubview:self.flipView];
    [self.flipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - <配置collectionView>
-(void)settingCollectionView
{
    self.flowLayout.minimumInteritemSpacing = 0;
    CGFloat itemWidth = self.collectionView.frame.size.width/5.0;
    CGFloat itemHeight = itemWidth/5.0*6.0;
    self.flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UINib *nibLookAround = [UINib nibWithNibName:NSStringFromClass([LookAroundCell class]) bundle:nil];
    [self.collectionView registerNib:nibLookAround forCellWithReuseIdentifier:NSStringFromClass([LookAroundCell class])];
}


#pragma mark - <点击“附近的人”响应>
- (IBAction)btnLookAroundAction:(UIButton *)sender
{
    LookAroundViewController *lookAroundVC = [[LookAroundViewController alloc]initWithNibName:NSStringFromClass([LookAroundViewController class]) bundle:nil];
    lookAroundVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lookAroundVC animated:YES];
}











#pragma mark - **** SegmentTapViewDelegate,FlipTableViewDelegate ****
-(void)selectedIndex:(NSInteger)index
{
    [self.flipView selectIndex:index];
}

-(void)scrollChangeToIndex:(NSInteger)index
{
    [self.segmentView selectIndex:index];
}

#pragma mark - *** UICollectionViewDelegate,UICollectionViewDataSource *****
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LookAroundCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LookAroundCell class]) forIndexPath:indexPath];
    return cell;
}







@end
