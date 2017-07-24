//
//  CommentListCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/24.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CommentListCell.h"

//views
#import "RatingBar.h"

//cells
#import "Discover_Dynamic_imageViewCell.h"

@interface CommentListCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)UIImageView *imgPortrait;
@property (nonatomic, strong)UILabel *labelNickName;
@property (nonatomic, strong)UIView *ratingBarBGView;
@property (nonatomic, strong)RatingBar *ratingBar;
@property (nonatomic, strong)UILabel *labelDescription;
@property (nonatomic, strong)UILabel *labelTime;
@property (nonatomic, strong)UIView *seperatorLine;



@end

@implementation CommentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [self.collectionView reloadData];
//    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@(self.collectionView.collectionViewLayout.collectionViewContentSize.height));
//    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark - <setDataArray>
-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self.collectionView reloadData];
    [self.contentView layoutIfNeeded];
    
#warning ****************************
    self.labelNickName.text = @"123";
    self.labelDescription.text = @"3456";
    self.labelTime.text = @"23452";
#warning ****************************
    
    [self.labelDescription mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
    }];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(self.collectionView.collectionViewLayout.collectionViewContentSize.height));
    }];
    
//    self.cellHeight = self.collectionView.contentSize.height + 130;
//    NSLog(@"当前cell的高度为%f",self.cellHeight);
}


#pragma mark - <懒加载>
-(UIView *)seperatorLine
{
    if (!_seperatorLine) {
        _seperatorLine = [[UIView alloc]init];
        _seperatorLine.backgroundColor = kColorFromRGB(kLightGray);
    }
    return _seperatorLine;
}

-(UIImageView *)imgPortrait
{
    if (!_imgPortrait) {
        _imgPortrait = [[UIImageView alloc]init];
        _imgPortrait.contentMode = UIViewContentModeScaleAspectFill;
        _imgPortrait.layer.cornerRadius = 25;
        _imgPortrait.layer.masksToBounds = YES;
        _imgPortrait.image = [UIImage imageNamed:@"tx"];
    }
    return _imgPortrait;
}

-(UILabel *)labelNickName
{
    if (!_labelNickName) {
        _labelNickName = [[UILabel alloc]init];
        _labelNickName.textColor = kColorFromRGB(kDeepGray);
        _labelNickName.font = [UIFont systemFontOfSize:13];
    }
    return _labelNickName;
}

-(UIView *)ratingBarBGView
{
    if (!_ratingBarBGView) {
        _ratingBarBGView = [[UIView alloc]init];
        _ratingBarBGView.backgroundColor = kColorFromRGB(kLightGray);
    }
    return _ratingBarBGView;
}

-(RatingBar *)ratingBar
{
    if (!_ratingBar) {
        _ratingBar = [[RatingBar alloc]init];
        _ratingBar.enable = NO;
    }
    return _ratingBar;
}

-(UILabel *)labelDescription
{
    if (!_labelDescription) {
        _labelDescription = [[UILabel alloc]init];
        _labelDescription.numberOfLines = 0;
        _labelDescription.font = [UIFont systemFontOfSize:12];
//        _labelDescription.
    }
    return _labelDescription;
}

-(UILabel *)labelTime
{
    if (!_labelTime) {
        _labelTime = [[UILabel alloc]init];
        _labelTime.font = [UIFont systemFontOfSize:10];
        _labelTime.textColor = kColorFromRGB(kDeepGray);
    }
    return _labelTime;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat itemWidth = (kSCREEN_WIDTH-20)/3.2;
        CGFloat itemHeight = itemWidth;
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 50, 50) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = kColorFromRGB(kWhite);
        
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([Discover_Dynamic_imageViewCell class]) bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([Discover_Dynamic_imageViewCell class])];
        
    }
    return _collectionView;
}

-(void)setUI
{
    [self.contentView addSubview:self.seperatorLine];
    [self.contentView addSubview:self.imgPortrait];
    [self.contentView addSubview:self.labelNickName];
    [self.contentView addSubview:self.ratingBarBGView];
    [self.contentView addSubview:self.labelDescription];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.labelTime];
    [self.ratingBarBGView addSubview:self.ratingBar];
    
    __weak typeof(self) weakSelf = self;
    [self.seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left);
        make.right.mas_equalTo(weakSelf.mas_right);
        make.top.mas_equalTo(weakSelf.contentView.mas_top);
        make.height.mas_equalTo(1);
    }];
    [self.imgPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.seperatorLine.mas_bottom).with.offset(10);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.ratingBarBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
        make.centerY.mas_equalTo(weakSelf.imgPortrait);
    }];
    [self.ratingBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.labelNickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imgPortrait.mas_right).with.offset(10);
        make.right.mas_equalTo(weakSelf.ratingBarBGView.mas_left).with.offset(-10);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(weakSelf.imgPortrait);
    }];
    [self.labelDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imgPortrait.mas_left);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(weakSelf.imgPortrait.mas_bottom);
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imgPortrait.mas_left);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-10);
        make.top.mas_equalTo(weakSelf.labelDescription.mas_bottom).with.offset(10);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.offset(-30);
    }];
    [self.labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imgPortrait.mas_left);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(weakSelf.collectionView.mas_bottom);
        make.height.mas_equalTo(20);
    }];
}








#pragma mark - *** UICollectionViewDelegate, UICollectionViewDataSource ****
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
