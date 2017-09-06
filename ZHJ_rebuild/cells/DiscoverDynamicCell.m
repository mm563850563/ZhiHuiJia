//
//  DiscoverDynamicCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/18.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "DiscoverDynamicCell.h"

//cells
#import "MyCircleDynamicImageCell.h"
#import "commentLabelCell.h"

//tools
#import "GetHeightOfText.h"
#import <TTTAttributedLabel.h>

//models
#import "MyCircleDynamicReply_infoModel.h"

//tools
#import <CXPhotoBrowser.h>

#define kSimpleCommentCellID @"SimpleCommentCellID"

@interface DiscoverDynamicCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,TTTAttributedLabelDelegate,CXPhotoBrowserDelegate,CXPhotoBrowserDataSource>

@property (strong, nonatomic) UIImageView *imgViewPortrait;
@property (strong, nonatomic) UILabel *labelNickName;
@property (nonatomic, strong)UIButton *btnOnFocus;
@property (nonatomic, strong)UIButton *btnLike;
@property (nonatomic, strong)UIButton *btnComment;
@property (strong, nonatomic) UILabel *labelAddTime;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)UITableView *tableView;
//@property (nonatomic, strong)UIImageView *imgViewPraise;
//@property (nonatomic, strong)UIImageView *imgViewComment;
@property (nonatomic, strong)UILabel *labelPraiseCount;
@property (nonatomic, strong)UILabel *labelCommentCount;
@property (nonatomic, strong)TTTAttributedLabel *labelContent;
@property (nonatomic, assign)NSRange rangeEnable;//可点击富文本的范围
@property (nonatomic, strong)NSMutableArray *atRangeArray;//存储at某人可点击范围

@property (nonatomic, strong)UIView *BGView;
@property (nonatomic, strong)UIView *commentBGView;

@property (nonatomic, strong)NSArray *imagesArray;
@property (nonatomic, strong)NSArray *commentArray;

@property (nonatomic, strong)CXPhotoBrowser *photoBrowser;
@property (nonatomic, strong)NSMutableArray *photoDataSource;

@end

@implementation DiscoverDynamicCell

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
-(void)clickImgViewPortraitAction:(UITapGestureRecognizer *)tap
{
    NSString *notifiName = [NSString string];
    if ([self.whereReuseFrom isEqualToString:@"discover"]) {
        notifiName = @"jumpToFocusPersonalVCByPortraitFromDiscover";
    }
    
    //跳转查看好友详情
    [[NSNotificationCenter defaultCenter]postNotificationName:notifiName object:self.modelCircleDynamicResult.user_id];
}

#pragma mark - <点击“赞”>
-(void)btnLikeAction:(UIButton *)sender
{
    NSString *notifiName = [NSString string];
    
    if (sender.selected) {
        if ([self.whereReuseFrom isEqualToString:@"discover"]) {
            notifiName = @"cancelLikeByClickFromDiscover";
        }else if ([self.whereReuseFrom isEqualToString:@"dynamicDetail"]){
            notifiName = @"cancelLikeByClickFromDynamicDetail";
        }
    }else{
        if ([self.whereReuseFrom isEqualToString:@"discover"]) {
            notifiName = @"likeByClickFromDiscover";
        }else if ([self.whereReuseFrom isEqualToString:@"dynamicDetail"]){
            notifiName = @"likeByClickFromDynamicDetail";
        }
    }
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:notifiName object:self.modelCircleDynamicResult.talk_id];
}

#pragma mark - <关注按钮响应>
-(void)btnOnfocusActionWithButton:(UIButton *)button
{
    NSString *notifiNameAttention = [NSString string];
    NSString *notifiNameCancelAttention = [NSString string];
    if ([self.whereReuseFrom isEqualToString:@"dynamicDetail"]) {
        notifiNameAttention = @"attentionFriendByDynamicDetail";
        notifiNameCancelAttention = @"cancelAttentionFriendByDynamicDetail";
    }else if ([self.whereReuseFrom isEqualToString:@"discover"]){
        notifiNameAttention = @"attentionFriendByDiscover";
        notifiNameCancelAttention = @"cancelAttentionFriendByDiscover";
    }
    
    if (!button.selected) {
        [[NSNotificationCenter defaultCenter]postNotificationName:notifiNameAttention object:self.modelCircleDynamicResult.user_id];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:notifiNameCancelAttention object:self.modelCircleDynamicResult.user_id];
    }
}

#pragma mark - <懒加载>
-(CXPhotoBrowser *)photoBrowser
{
    if (!_photoBrowser) {
        _photoBrowser = [[CXPhotoBrowser alloc]initWithDataSource:self delegate:self];
    }
    return _photoBrowser;
}

-(NSMutableArray *)photoDataSource
{
    if (!_photoDataSource) {
        _photoDataSource = [NSMutableArray array];
    }
    return _photoDataSource;
}

-(NSMutableArray *)atRangeArray
{
    if (!_atRangeArray) {
        _atRangeArray = [NSMutableArray array];
    }
    return _atRangeArray;
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
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImgViewPortraitAction:)];
        _imgViewPortrait.userInteractionEnabled = YES;
        [_imgViewPortrait addGestureRecognizer:tap];
    }
    return _imgViewPortrait;
}

-(UILabel *)labelNickName
{
    if (!_labelNickName) {
        _labelNickName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _labelNickName.font = [UIFont systemFontOfSize:15];
    }
    return _labelNickName;
}

-(UIButton *)btnLike
{
    if (!_btnLike) {
        _btnLike = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnLike.frame = CGRectMake(0, 0, 50, 50);
        
        [_btnLike setImage:[UIImage imageNamed:@"like_black"] forState:UIControlStateNormal];
        [_btnLike setImage:[UIImage imageNamed:@"like_yellow"] forState: UIControlStateSelected];
        
        [_btnLike addTarget:self action:@selector(btnLikeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLike;
}

-(UIButton *)btnComment
{
    if (!_btnComment) {
        _btnComment = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnComment.frame = CGRectMake(0, 0, 50, 50);
        
        [_btnComment setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
        _btnComment.userInteractionEnabled = NO;
        //        [_btnLike addTarget:self action:@selector() forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnComment;
}

-(UIButton *)btnOnFocus
{
    if (!_btnOnFocus) {
        _btnOnFocus = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnOnFocus.frame = CGRectMake(0, 0, 50, 50);
        _btnOnFocus.layer.borderWidth = 1;
        _btnOnFocus.layer.borderColor = kColorFromRGB(kThemeYellow).CGColor;
        _btnOnFocus.layer.cornerRadius = 3;
        _btnOnFocus.layer.masksToBounds = YES;
        _btnOnFocus.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [_btnOnFocus setTitle:@"+关注" forState:UIControlStateNormal];
        [_btnOnFocus setTitleColor:kColorFromRGB(kThemeYellow) forState:UIControlStateNormal];
        [_btnOnFocus setTitle:@"已关注" forState:UIControlStateSelected];
        [_btnOnFocus setTitleColor:kColorFromRGB(kThemeYellow) forState:UIControlStateSelected];
        
        [_btnOnFocus addTarget:self action:@selector(btnOnfocusActionWithButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnOnFocus;
}

-(UILabel *)labelContent
{
    if (!_labelContent) {
        _labelContent = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _labelContent.numberOfLines = 0;
        _labelContent.font = [UIFont systemFontOfSize:13];
        _labelContent.lineBreakMode = NSLineBreakByCharWrapping;
        _labelContent.textColor = kColorFromRGB(kBlack);
        _labelContent.highlightedTextColor = kColorFromRGB(kThemeYellow);
        _labelContent.delegate = self;
        //        _labelContent.enabledTextCheckingTypes = NSTextCheckingTypePhoneNumber|NSTextCheckingTypeAddress|NSTextCheckingTypeLink;
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

-(UILabel *)labelPraiseCount
{
    if (!_labelPraiseCount) {
        _labelPraiseCount = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _labelPraiseCount.font = [UIFont systemFontOfSize:11];
    }
    return _labelPraiseCount;
}

-(UILabel *)labelCommentCount
{
    if (!_labelCommentCount) {
        _labelCommentCount = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _labelCommentCount.font = [UIFont systemFontOfSize:11];
    }
    return _labelCommentCount;
}

-(UILabel *)labelAddTime
{
    if (!_labelAddTime) {
        _labelAddTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _labelAddTime.font = [UIFont systemFontOfSize:11];
        _labelAddTime.textAlignment = NSTextAlignmentRight;
    }
    return _labelAddTime;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 50, 50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 20;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.userInteractionEnabled = NO;
        
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSimpleCommentCellID];
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([commentLabelCell class]) bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([commentLabelCell class])];
    }
    return _tableView;
}

-(void)setUI
{
    [self.contentView addSubview:self.BGView];
    [self.BGView addSubview:self.imgViewPortrait];
    [self.BGView addSubview:self.labelNickName];
    [self.BGView addSubview:self.btnOnFocus];
    [self.BGView addSubview:self.labelContent];
    [self.BGView addSubview:self.collectionView];
    [self.BGView addSubview:self.commentBGView];
    [self.commentBGView addSubview:self.btnLike];
    [self.commentBGView addSubview:self.btnComment];
    [self.commentBGView addSubview:self.labelPraiseCount];
    [self.commentBGView addSubview:self.labelCommentCount];
    [self.commentBGView addSubview:self.labelAddTime];
    [self.BGView addSubview:self.tableView];
    
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
        make.left.mas_equalTo(weakSelf.imgViewPortrait.mas_right).with.offset(5);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(weakSelf.imgViewPortrait);
    }];
    [self.btnOnFocus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.labelNickName.mas_right);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(25);
        make.centerY.mas_equalTo(weakSelf.labelNickName);
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
    [self.btnComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.size.mas_offset(CGSizeMake(15, 15));
        make.centerY.mas_equalTo(0);
    }];
    [self.labelCommentCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.btnComment.mas_right).with.offset(5);
        make.size.mas_offset(CGSizeMake(25, 20));
        make.centerY.mas_equalTo(0);
    }];
    [self.btnLike mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.labelCommentCount.mas_right).with.offset(0);
        make.size.mas_offset(CGSizeMake(20, 20));
        make.centerY.mas_equalTo(0);
    }];
    [self.labelPraiseCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.btnLike.mas_right).with.offset(5);
        make.size.mas_offset(CGSizeMake(25, 20));
        make.centerY.mas_equalTo(0);
    }];
    [self.labelAddTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.size.mas_offset(CGSizeMake(120, 20));
        make.centerY.mas_equalTo(0);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.commentBGView.mas_bottom);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(5);
    }];
}



-(void)setModelCircleDynamicResult:(MyCircleDynamicResultModel *)modelCircleDynamicResult
{
    _modelCircleDynamicResult = modelCircleDynamicResult;
    [self.atRangeArray removeAllObjects];
    
    //collectionView
    self.imagesArray = modelCircleDynamicResult.images;
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
    
    //配置图片浏览器数据源
    [self.photoDataSource removeAllObjects];
    for (NSString *imgStr in self.imagesArray) {
        CXPhoto *photo = [[CXPhoto alloc]initWithURL:[NSURL URLWithString:imgStr]];
        [self.photoDataSource addObject:photo];
    }
    
    
    //imgViewPortrait
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelCircleDynamicResult.headimg];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewPortrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    //btnOnFocus
    if ([modelCircleDynamicResult.is_attentioned isEqualToString:@"1"]) {
        self.btnOnFocus.selected = YES;
    }else{
        self.btnOnFocus.selected = NO;
    }
    
    //btnLike
    if ([modelCircleDynamicResult.is_liked isEqualToString:@"1"]) {
        self.btnLike.selected = YES;
    }else{
        self.btnLike.selected = NO;
    }
    
    //label
    self.labelNickName.text = modelCircleDynamicResult.nickname;
    self.labelPraiseCount.text = modelCircleDynamicResult.like_count;
    self.labelCommentCount.text = modelCircleDynamicResult.reply_count;
    
    //labelAddTime
    //    NSInteger t = [modelCircleDynamicResult.addtime integerValue];
    //    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    //    NSString *dateStr = [formatter stringFromDate:date];
    //    self.labelAddTime.text = dateStr;
    self.labelAddTime.text = modelCircleDynamicResult.addtime;
    
    //labelContent
    NSArray *atArray = modelCircleDynamicResult.tips_info;
    NSMutableString *atStr = [NSMutableString string];
    for (MyCircleDynamicTips_infoModel *modelTipsInfo in atArray) {
        //        if (![modelTipsInfo.nickname isEqualToString:@""]) {
        [atStr appendFormat:@" @%@",modelTipsInfo.nickname];
        //        }
    }
    
    NSString *text = [NSString string];
    if (![modelCircleDynamicResult.topic_title isEqualToString:@""]) {
        text = [NSString stringWithFormat:@"#%@# %@ %@",modelCircleDynamicResult.topic_title,modelCircleDynamicResult.content,atStr];
    }else{
        text = [NSString stringWithFormat:@"%@ %@",modelCircleDynamicResult.content,atStr];
    }
    
    CGFloat contentHeight = [GetHeightOfText getHeightWithContent:text font:14 contentSize:CGSizeMake(kSCREEN_WIDTH-20, MAXFLOAT)];
    [self.labelContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentHeight);
    }];
    
    __weak typeof(self) weakSelf = self;
    [self.labelContent setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        //设置可点击文字的范围
        NSRange rangeEnable = [[mutableAttributedString string]rangeOfString:[NSString stringWithFormat:@"#%@#",modelCircleDynamicResult.topic_title] options:NSCaseInsensitiveSearch];
        weakSelf.rangeEnable = rangeEnable;
        
        //设置可点击文本的颜色;
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                        value:kColorFromRGB(kThemeYellow)
                                        range:rangeEnable];
        
        //加上下划线
        [mutableAttributedString addAttribute:NSUnderlineColorAttributeName
                                        value:[UIColor clearColor]
                                        range:rangeEnable];
        
        //处理at某人
        for (MyCircleDynamicTips_infoModel *modelTipsInfo in atArray) {
            //            if (![modelTipsInfo.nickname isEqualToString:@""]) {
            NSString *tempAtStr = [NSString stringWithFormat:@"@%@",modelTipsInfo.nickname];
            //设置可点击文字的范围
            NSRange rangeAt = [[mutableAttributedString string]rangeOfString:tempAtStr options:NSCaseInsensitiveSearch];
            NSData *rangeData = [NSData dataWithBytes:&rangeAt length:sizeof(rangeAt)];
            [weakSelf.atRangeArray addObject:rangeData];
            //设置可点击文本的颜色;
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:kColorFromRGB(kThemeYellow) range:rangeAt];
            //加上下划线
            [mutableAttributedString addAttribute:NSUnderlineColorAttributeName
                                            value:[UIColor clearColor]
                                            range:rangeAt];
            //            }
        }
        
        return mutableAttributedString;
    }];
    //给富文本添加url
    NSURL *urlTopicID = [NSURL URLWithString:modelCircleDynamicResult.topic_id];
    [self.labelContent addLinkToURL:urlTopicID withRange:self.rangeEnable];
    //    [self.labelContent setLinkAttributes:@{NSForegroundColorAttributeName:kColorFromRGB(kThemeYellow)}];
    //    [self.labelContent setActiveLinkAttributes:@{NSForegroundColorAttributeName:kColorFromRGB(kThemeYellow)}];
    
    for (int i = 0; i < atArray.count; i++) {
        MyCircleDynamicTips_infoModel *modelTipsInfo = atArray[i];
        //        if (![modelTipsInfo.nickname isEqualToString:@""]) {
        NSData *dataRangeAt = self.atRangeArray[i];
        NSRange rangeAt;
        [dataRangeAt getBytes:&rangeAt length:sizeof(rangeAt)];
        
        NSDictionary *dict = @{@"user_id":modelTipsInfo.user_id};
        
        [self.labelContent addLinkToAddress:dict withRange:rangeAt];
        //        }
    }
    
    //tableView
    self.commentArray = modelCircleDynamicResult.reply_info;
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    
    CGFloat rowHeight = 20;
    CGFloat tableViewHeight = 0;
    if (self.commentArray.count>=3) {
        tableViewHeight = rowHeight * (self.commentArray.count+1);
    }else{
        tableViewHeight = rowHeight * self.commentArray.count;
    }
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tableViewHeight);
    }];
    
    //height
    self.cellHeight = collectionHeight+contentHeight+tableViewHeight+120;
}


















#pragma mark - ***** TTTAttributedLabelDelegate *****
-(void)attributedLabel:(TTTAttributedLabel*)label didSelectLinkWithURL:(NSURL *)url
{
    NSString *topic_id = [url absoluteString];
    if (topic_id && ![topic_id isEqualToString:@""]) {
        
        NSString *notifiName = [NSString string];
        if ([self.whereReuseFrom isEqualToString:@"discover"]) {
            notifiName = @"jumpToFocusPersonalVCByTopicFromDiscover";
        }
        
        //跳转话题详情
        [[NSNotificationCenter defaultCenter]postNotificationName:notifiName object:topic_id];
    }
}

-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents
{
    NSString *user_id = addressComponents[@"user_id"];
    if (user_id && ![user_id isEqualToString:@""]) {
        
        NSString *notifiName = [NSString string];
        if ([self.whereReuseFrom isEqualToString:@"discover"]) {
            notifiName = @"jumpToFocusPersonalVCByAtSomeoneFromDiscover";
        }
        
        //跳转查看好友详情
        [[NSNotificationCenter defaultCenter]postNotificationName:notifiName object:user_id];
    }
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //图片浏览器
    
    [self.photoBrowser setInitialPageIndex:indexPath.item];
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *)nextResponder;
            [vc.navigationController pushViewController:self.photoBrowser animated:YES];
        }
    }
}


#pragma mark - ***** UITableViewDelegate,UITableViewDataSource *****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSimpleCommentCellID];
    
    commentLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([commentLabelCell class])];
    MyCircleDynamicReply_infoModel *modelReplyInfo = self.commentArray[indexPath.row];
    cell.labelComment.text = [NSString stringWithFormat:@"%@:%@",modelReplyInfo.nickname,modelReplyInfo.content];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",modelReplyInfo.nickname,modelReplyInfo.content];
//    cell.textLabel.font = [UIFont systemFontOfSize:12];
//    cell.textLabel.textColor = kColorFromRGB(kDeepGray);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



#pragma mark - ******* CXPhotoBrowserDelegate,CXPhotoBrowserDataSource ********
-(NSUInteger)numberOfPhotosInPhotoBrowser:(CXPhotoBrowser *)photoBrowser
{
    return self.photoDataSource.count;
}

-(id<CXPhotoProtocol>)photoBrowser:(CXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photoDataSource.count){
        return [self.photoDataSource objectAtIndex:index];
    }
    return nil;
}

-(CGFloat)heightForNavigationBarInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return 64;
}


@end
