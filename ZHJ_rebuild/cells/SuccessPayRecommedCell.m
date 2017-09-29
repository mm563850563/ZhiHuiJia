//
//  SuccessPayRecommedCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/15.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SuccessPayRecommedCell.h"


//controllers
#import "CircleDetailViewController.h"
#import "BasicNavigationController.h"

//cells
#import "SuccessPayRecommendMemberCell.h"
#import "SuccessPayRecommendMemberSingleCountCell.h"

//models
#import "GetInterestingCircleResultModel.h"

@interface SuccessPayRecommedCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)UICollectionView *collectionView;
//旋转指令
@property (nonatomic, strong)NSString *rotationOrder;

@end

@implementation SuccessPayRecommedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = kColorFromRGB(kLightGray);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)drawRect:(CGRect)rect
{
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    
//    UIButton *btnPlayPause = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnPlayPause setImage:[UIImage imageNamed:@"action_pause"] forState:UIControlStateNormal];
//    [btnPlayPause setImage:[UIImage imageNamed:@"action_play"] forState:UIControlStateSelected];
//    [btnPlayPause addTarget:self action:@selector(startOrPauseRatationWithSender:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:btnPlayPause];
//    [btnPlayPause mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.top.mas_equalTo(0);
//        make.size.mas_offset(CGSizeMake(35, 35));
//    }];
}

#pragma mark - <开始／暂停旋转>
-(void)startOrPauseRatationWithSender:(UIButton *)sender
{
    if (sender.selected) {
        self.rotationOrder = @"pause";
    }else{
        self.rotationOrder = @"resume";
    }
    sender.selected = !sender.selected;
    [self.collectionView reloadData];
}

-(UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        CGFloat itemWidth = (kSCREEN_WIDTH-20)/2.0;
        CGFloat itemHeight = itemWidth/3.0*2;
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    }
    return _flowLayout;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.contentView.bounds collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = kColorFromRGB(kLightGray);
        
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([SuccessPayRecommendMemberCell class]) bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([SuccessPayRecommendMemberCell class])];
        
        UINib *nibSingleCount = [UINib nibWithNibName:NSStringFromClass([SuccessPayRecommendMemberSingleCountCell class]) bundle:nil];
        [_collectionView registerNib:nibSingleCount forCellWithReuseIdentifier:NSStringFromClass([SuccessPayRecommendMemberSingleCountCell class])];
    }
    return _collectionView;
}

-(void)setInterestingCircleArray:(NSArray *)interestingCircleArray
{
    _interestingCircleArray = interestingCircleArray;
    
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    
    CGFloat itemWidth = (kSCREEN_WIDTH-20)/2.0;
    CGFloat itemHeight = itemWidth/3.0*2;
    NSUInteger count = interestingCircleArray.count/2;
    if (interestingCircleArray.count%2>0) {
        count++;
    }
    
    self.cellHeight = itemHeight*count;
}

#pragma mark - <跳转“圈子详情”页面>
-(void)jumpToCircleDetailVCWithCircleID:(NSString *)circle_id
{
    CircleDetailViewController *circleDetailVC = [[CircleDetailViewController alloc]initWithNibName:NSStringFromClass([CircleDetailViewController class]) bundle:nil];
    circleDetailVC.circle_id = circle_id;
    
    //在当前当前控件遍历所在的viewcontroller
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
//            UIViewController *vc = (UIViewController *)nextResponder;
            //            [vc presentViewController:circleDetailVC animated:YES completion:nil];
            UIViewController *vc = (UIViewController *)nextResponder;
            [vc.navigationController pushViewController:circleDetailVC animated:YES];
        }
    }
}











#pragma mark - **** UICollectionViewDelegate,UICollectionViewDataSource *****
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.interestingCircleArray.count>6) {
        return 6;
    }else{
        return self.interestingCircleArray.count;
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item%2 == 0) {
        SuccessPayRecommendMemberSingleCountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SuccessPayRecommendMemberSingleCountCell class]) forIndexPath:indexPath];
        GetInterestingCircleResultModel *modelInterestCircle = self.interestingCircleArray[indexPath.item];
        cell.modelInterestCircle = modelInterestCircle;
//        cell.rotationOrder = self.rotationOrder;
        return cell;
    }else{
        SuccessPayRecommendMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SuccessPayRecommendMemberCell class]) forIndexPath:indexPath];
        GetInterestingCircleResultModel *modelInterestCircle = self.interestingCircleArray[indexPath.item];
        cell.modelInterestCircle = modelInterestCircle;
//        cell.rotationOrder = self.rotationOrder;
        return cell;
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GetInterestingCircleResultModel *model = self.interestingCircleArray[indexPath.item];
    [self jumpToCircleDetailVCWithCircleID:model.circle_id];
}







@end
