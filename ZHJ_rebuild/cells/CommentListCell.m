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
#import "MyCircleDynamicImageCell.h"

//models
#import "ProductCommentResultModel.h"

//tools
#import "GetHeightOfText.h"

@interface CommentListCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)UIView *mainBGView;
@property (nonatomic, strong)UIImageView *imgPortrait;
@property (nonatomic, strong)UILabel *labelNickName;
@property (nonatomic, strong)RatingBar *ratingBar;
@property (nonatomic, strong)UILabel *labelDescription;
@property (nonatomic, strong)UILabel *labelAddTime;
@property (nonatomic, strong)UIView *serviceBGView;
@property (nonatomic, strong)UILabel *labelServiceReply;

@property (nonatomic, strong)NSArray *imagesArray;



@end

@implementation CommentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kColorFromRGB(kLightGray);
        [self setUI];
    }
    return self;
}


#pragma mark - <点击头像响应>
-(void)clickPortraitAction:(UITapGestureRecognizer *)tap
{
//    NSString *notifiName = [NSString string];
//    if ([self.whereReuseFrom isEqualToString:@"productCommentListVC"]) {
//        notifiName = @"jumpToFocusPersonalVCByPortraitFromProductCommentListVC";
//    }
//    
//    //跳转查看好友详情
//    [[NSNotificationCenter defaultCenter]postNotificationName:notifiName object:self.modelProductCommentResult.];
}




#pragma mark - <懒加载>
-(UIView *)mainBGView
{
    if (!_mainBGView) {
        _mainBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _mainBGView.backgroundColor = kColorFromRGB(kWhite);
    }
    return _mainBGView;
}

-(UIImageView *)imgPortrait
{
    if (!_imgPortrait) {
        _imgPortrait = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _imgPortrait.contentMode = UIViewContentModeScaleAspectFill;
        _imgPortrait.layer.cornerRadius = 20;
        _imgPortrait.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPortraitAction:)];
        _imgPortrait.userInteractionEnabled = YES;
        [_imgPortrait addGestureRecognizer:tap];
    }
    return _imgPortrait;
}

-(UILabel *)labelNickName
{
    if (!_labelNickName) {
        _labelNickName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _labelNickName.font = [UIFont systemFontOfSize:15];
    }
    return _labelNickName;
}

-(RatingBar *)ratingBar
{
    if (!_ratingBar) {
        _ratingBar = [[RatingBar alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        _ratingBar.enable = NO;
    }
    return _ratingBar;
}

-(UILabel *)labelDescription
{
    if (!_labelDescription) {
        _labelDescription = [[UILabel alloc]init];
        _labelDescription.numberOfLines = 0;
        _labelDescription.font = [UIFont systemFontOfSize:13];
//        _labelDescription.
    }
    return _labelDescription;
}

-(UILabel *)labelAddTime
{
    if (!_labelAddTime) {
        _labelAddTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _labelAddTime.font = [UIFont systemFontOfSize:11];
        _labelAddTime.textColor = kColorFromRGB(kDeepGray);
        _labelAddTime.textAlignment = NSTextAlignmentLeft;
    }
    return _labelAddTime;
}

-(UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat itemWidth = (kSCREEN_WIDTH-20)/3.02;
        CGFloat itemHeight = itemWidth;
        self.flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.flowLayout.minimumLineSpacing = 1;
        self.flowLayout.minimumInteritemSpacing = 0;
    }
    return _flowLayout;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 50, 50) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = kColorFromRGB(kWhite);
        
        UINib *nibImage = [UINib nibWithNibName:NSStringFromClass([MyCircleDynamicImageCell class]) bundle:nil];
        [self.collectionView registerNib:nibImage forCellWithReuseIdentifier:NSStringFromClass([MyCircleDynamicImageCell class])];
    }
    return _collectionView;
}

-(UIView *)serviceBGView
{
    if (!_serviceBGView) {
        _serviceBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _serviceBGView.backgroundColor = kColorFromRGB(kLightGray);
        _serviceBGView.layer.cornerRadius = 3;
        _serviceBGView.layer.masksToBounds = YES;
    }
    return _serviceBGView;
}

-(UILabel *)labelServiceReply
{
    if (!_labelServiceReply) {
        _labelServiceReply = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _labelServiceReply.font = [UIFont systemFontOfSize:12];
        _labelServiceReply.textColor = kColorFromRGB(kDeepGray);
    }
    return _labelServiceReply;
}

-(void)setUI
{
    [self.contentView addSubview:self.mainBGView];
    [self.mainBGView addSubview:self.imgPortrait];
    [self.mainBGView addSubview:self.labelNickName];
    [self.mainBGView addSubview:self.ratingBar];
    [self.mainBGView addSubview:self.labelAddTime];
    [self.mainBGView addSubview:self.labelDescription];
    [self.mainBGView addSubview:self.collectionView];
    [self.mainBGView addSubview:self.serviceBGView];
    [self.serviceBGView addSubview:self.labelServiceReply];
    
    __weak typeof(self) weakSelf = self;
    
    [self.mainBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(1);
        make.bottom.mas_equalTo(-0.5);
        make.left.right.mas_equalTo(0);
    }];
    [self.imgPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10);
        make.size.mas_offset(CGSizeMake(40, 40));
    }];
    [self.labelNickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imgPortrait.mas_right).with.offset(5);
        make.right.mas_equalTo(-120);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(weakSelf.imgPortrait);
    }];
    [self.ratingBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.size.mas_offset(CGSizeMake(100, 30));
        make.centerY.mas_equalTo(weakSelf.imgPortrait);
    }];
    [self.labelAddTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imgPortrait.mas_left);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(weakSelf.imgPortrait.mas_bottom).with.offset(5);
        make.height.mas_equalTo(20);
    }];
    [self.labelDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imgPortrait.mas_left);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(weakSelf.labelAddTime.mas_bottom).with.offset(5);
        make.height.mas_equalTo(5);
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(weakSelf.labelDescription.mas_bottom).with.offset(5);
        make.height.mas_equalTo(5);
    }];
    [self.serviceBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(weakSelf.collectionView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(0);
    }];
    [self.labelServiceReply mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

-(void)setModelProductCommentResult:(ProductCommentResultModel *)modelProductCommentResult
{
    _modelProductCommentResult = modelProductCommentResult;
    
    //collectionView
    self.imagesArray = modelProductCommentResult.img;
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    
    NSInteger line = self.imagesArray.count/3;
    if (self.imagesArray.count%3 > 0) {
        line++;
    }
    CGFloat itemWidth = (kSCREEN_WIDTH-20)/3.0;
    CGFloat itemHeight = itemWidth;
    CGFloat collectionHeight = itemHeight*line;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(collectionHeight);
    }];
    
    //imgViewPortrait
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelProductCommentResult.headimg];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgPortrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    //labelNickName
    self.labelNickName.text = modelProductCommentResult.nickname;
    
    //labelAddTime
        NSInteger t = [modelProductCommentResult.add_time integerValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSString *dateStr = [formatter stringFromDate:date];
        self.labelAddTime.text = dateStr;
    
    //starBar
    self.ratingBar.starNumber = [modelProductCommentResult.goods_grade integerValue];
    
    //labelDescription
    self.labelDescription.text = modelProductCommentResult.content;
    CGFloat contentHeight = [GetHeightOfText getHeightWithContent:self.labelDescription.text font:14 contentSize:CGSizeMake(kSCREEN_WIDTH-20, MAXFLOAT)];
    [self.labelDescription mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentHeight);
    }];
    
    //labelServiceReply
    CGFloat serviceReplyHeight = 0;
    if (![modelProductCommentResult.service.content isEqualToString:@""]) {
        self.labelServiceReply.text = [NSString stringWithFormat:@"客服回复：%@",modelProductCommentResult.service.content];
        serviceReplyHeight = [GetHeightOfText getHeightWithContent:self.labelServiceReply.text font:13 contentSize:CGSizeMake(kSCREEN_WIDTH-20, MAXFLOAT)];
        serviceReplyHeight += 10;
    }else{
        serviceReplyHeight = 0;
    }
    
    [self.serviceBGView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(serviceReplyHeight);
    }];
    
    self.cellHeight = serviceReplyHeight+contentHeight+collectionHeight+110;
}














#pragma mark - *** UICollectionViewDelegate, UICollectionViewDataSource ****
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
