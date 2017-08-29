//
//  DiscoverDynamicCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/18.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "DiscoverDynamicCell.h"

//cells
#import "Discover_Dynamic_imageViewCell.h"

@interface DiscoverDynamicCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

//heights
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForLabelDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForCollectionView;

//outlets
@property (weak, nonatomic) IBOutlet UIView *BGViewComment;
@property (weak, nonatomic) IBOutlet UILabel *labelComment1;
@property (weak, nonatomic) IBOutlet UILabel *labelComment2;
@property (weak, nonatomic) IBOutlet UILabel *labelComment3;
@property (weak, nonatomic) IBOutlet UILabel *labelAllComment;

@property (weak, nonatomic) IBOutlet UIImageView *imgPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;
@property (weak, nonatomic) IBOutlet UIButton *btnFocus;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;

@property (weak, nonatomic) IBOutlet UILabel *labelReplyNum;
@property (weak, nonatomic) IBOutlet UILabel *labelPraiseNum;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation DiscoverDynamicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self settingOutlets];
    [self settingCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    
    [self.collectionView reloadData];
    //强制刷新图片页面
    [self.collectionView layoutIfNeeded];
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labelDescription.mas_bottom).with.offset(5);
        make.leading.trailing.mas_equalTo(15);
        make.height.mas_equalTo(weakSelf.collectionView.contentSize.height);
    }];
    
    self.cellHeight = 120 + self.collectionView.frame.origin.y + self.collectionView.contentSize.height + 100;
    
}

-(void)settingOutlets
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewProtraitAction:)];
    self.imgPortrait.userInteractionEnabled = YES;
    [self.imgPortrait addGestureRecognizer:tap];
    
}

-(void)imgViewProtraitAction:(UITapGestureRecognizer *)tap
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"jumpToFocusPersonalFileVC" object:nil];
}

-(void)settingCollectionView
{
    CGFloat itemWidth = self.collectionView.frame.size.width/3.1;
    CGFloat itemHeight = itemWidth;
    self.flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([Discover_Dynamic_imageViewCell class]) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([Discover_Dynamic_imageViewCell class])];
}


#pragma mark - *** UICollectionViewDelegate,UICollectionViewDataSource ****
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Discover_Dynamic_imageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Discover_Dynamic_imageViewCell class]) forIndexPath:indexPath];
    cell.imgView.image = [UIImage imageNamed:self.dataArray[indexPath.row]];
    return cell;
}


@end
