//
//  FocusPersonCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/19.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "FocusPersonCell.h"

//cells
#import "MyCircleDynamicImageCell.h"

//tools
#import "GetHeightOfText.h"

@interface FocusPersonCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UIImageView *imgViewPortrait;
@property (strong, nonatomic) UILabel *labelNickName;
@property (strong, nonatomic) UILabel *labelAddTime;
@property (strong, nonatomic) UILabel *labelContent;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)UIImageView *imgViewPraise;
@property (nonatomic, strong)UIImageView *imgViewComment;
@property (nonatomic, strong)UILabel *labelPraiseCount;
@property (nonatomic, strong)UILabel *labelCommentCount;

@property (nonatomic, strong)UIView *BGView;
@property (nonatomic, strong)UIView *commentBGView;

@property (nonatomic, strong)NSArray *imagesArray;

@end

@implementation FocusPersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = kColorFromRGB(kLightGray);
        [self setUI];
    }
    return self;
}

-(UIView *)BGView
{
    if (!_BGView) {
        _BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _BGView.backgroundColor = kColorFromRGB(kWhite);
    }
    return _BGView;
}

-(UIImageView *)imgViewPortrait
{
    if (!_imgViewPortrait) {
        _imgViewPortrait = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _imgViewPortrait.contentMode = UIViewContentModeScaleAspectFill;
        _imgViewPortrait.layer.cornerRadius = 25;
        _imgViewPortrait.layer.masksToBounds = YES;
    }
    return _imgViewPortrait;
}

-(UILabel *)labelContent
{
    if (!_labelContent) {
        _labelContent = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _labelContent.numberOfLines = 7;
        _labelContent.font = [UIFont systemFontOfSize:12];
    }
    return _labelContent;
}

-(UIView *)commentBGView
{
    if (!_commentBGView) {
        _commentBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    }
    return _commentBGView;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        CGFloat itemWidth = (kSCREEN_WIDTH-30)/3.0;
        CGFloat itemHeight = itemWidth;
        self.flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        self.flowLayout.minimumLineSpacing = 0;
        self.flowLayout.minimumInteritemSpacing = 0;
        
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        UINib *nibImage = [UINib nibWithNibName:NSStringFromClass([MyCircleDynamicImageCell class]) bundle:nil];
        
        [self.collectionView registerNib:nibImage forCellWithReuseIdentifier:NSStringFromClass([MyCircleDynamicImageCell class])];
    }
    return _collectionView;
}

-(UIImageView *)imgViewPraise
{
    if (!_imgViewPraise) {
        _imgViewPraise = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _imgViewPraise.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgViewPraise;
}

-(UIImageView *)imgViewComment
{
    if (!_imgViewComment) {
        _imgViewComment = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _imgViewComment.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgViewComment;
}

-(UILabel *)labelPraiseCount
{
    if (!_labelPraiseCount) {
        _labelPraiseCount = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _labelPraiseCount.font = [UIFont systemFontOfSize:10];
    }
    return _labelPraiseCount;
}

-(UILabel *)labelCommentCount
{
    if (!_labelCommentCount) {
        _labelCommentCount = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _labelCommentCount.font = [UIFont systemFontOfSize:10];
    }
    return _labelCommentCount;
}

-(UILabel *)labelAddTime
{
    if (!_labelAddTime) {
        _labelAddTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _labelAddTime.font = [UIFont systemFontOfSize:10];
    }
    return _labelAddTime;
}

-(void)setUI
{
    [self.contentView addSubview:self.BGView];
    [self.BGView addSubview:self.imgViewPortrait];
    [self.BGView addSubview:self.labelNickName];
    [self.BGView addSubview:self.labelContent];
    [self.BGView addSubview:self.collectionView];
    [self.BGView addSubview:self.commentBGView];
    [self.commentBGView addSubview:self.imgViewPraise];
    [self.commentBGView addSubview:self.imgViewComment];
    [self.commentBGView addSubview:self.labelPraiseCount];
    [self.commentBGView addSubview:self.labelCommentCount];
    [self.commentBGView addSubview:self.labelAddTime];
    
    __weak typeof(self) weakSelf = self;
    
    [self.BGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(1);
        make.bottom.mas_equalTo(-1);
        make.left.right.mas_equalTo(0);
    }];
    [self.imgViewPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10);
        make.size.mas_offset(CGSizeMake(50, 50));
    }];
    [self.labelNickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imgViewPortrait.mas_left).with.offset(5);
        make.right.mas_equalTo(10);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
    }];
    [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.imgViewPortrait.mas_bottom).with.offset(5);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(5);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.labelContent.mas_bottom).with.offset(5);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(5);
    }];
    [self.commentBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.collectionView.mas_bottom).with.offset(5);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(40);
    }];
    [self.imgViewPraise mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.size.mas_offset(CGSizeMake(15, 15));
        make.centerY.mas_equalTo(0);
    }];
    [self.labelPraiseCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imgViewPraise.mas_left).with.offset(5);
        make.size.mas_offset(CGSizeMake(30, 20));
        make.centerY.mas_equalTo(0);
    }];
    [self.imgViewComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.labelPraiseCount.mas_left).with.offset(10);
        make.size.mas_offset(CGSizeMake(15, 15));
        make.centerY.mas_equalTo(0);
    }];
    [self.labelCommentCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imgViewComment.mas_left).with.offset(5);
        make.size.mas_offset(CGSizeMake(30, 20));
        make.centerY.mas_equalTo(0);
    }];
    [self.labelAddTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.size.mas_offset(CGSizeMake(80, 20));
        make.centerY.mas_equalTo(0);
    }];
}



-(void)setModelCircleDynamicResult:(MyCircleDynamicResultModel *)modelCircleDynamicResult
{
    _modelCircleDynamicResult = modelCircleDynamicResult;
    
    self.imagesArray = modelCircleDynamicResult.images;
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    
    NSInteger line = self.imagesArray.count/3;
    if (self.imagesArray.count%3 > 0) {
        line += self.imagesArray.count%3;
    }
    CGFloat itemWidth = (kSCREEN_WIDTH-20)/3.0;
    CGFloat itemHeight = itemWidth;
    CGFloat collectionHeight = itemHeight*line;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(collectionHeight);
    }];
    self.cellHeight = 100+collectionHeight;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelCircleDynamicResult.headimg];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewPortrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
}




















#pragma mark - ***** UICollectionViewDelegate,UICollectionViewDataSource *****
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagesArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCircleDynamicImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MyCircleDynamicImageCell class]) forIndexPath:indexPath];
    NSString *imgStr = self.imagesArray[indexPath.item];
    imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,imgStr];
    cell.imgStr = imgStr;
    return cell;
}






@end
