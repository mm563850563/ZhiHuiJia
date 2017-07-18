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
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self settingCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    return 9;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Discover_Dynamic_imageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Discover_Dynamic_imageViewCell class]) forIndexPath:indexPath];
    
    return cell;
}


@end
