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
#import <TTTAttributedLabel.h>


@interface FocusPersonCell ()<UICollectionViewDelegate,UICollectionViewDataSource,TTTAttributedLabelDelegate>

@property (strong, nonatomic) UIImageView *imgViewPortrait;
@property (strong, nonatomic) UILabel *labelNickName;
@property (strong, nonatomic) UILabel *labelAddTime;
//@property (strong, nonatomic) UILabel *labelContent;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)UIImageView *imgViewPraise;
@property (nonatomic, strong)UIImageView *imgViewComment;
@property (nonatomic, strong)UILabel *labelPraiseCount;
@property (nonatomic, strong)UILabel *labelCommentCount;
@property (nonatomic, strong)TTTAttributedLabel *labelContent;
@property (nonatomic, assign)NSRange rangeEnable;//可点击富文本的范围
@property (nonatomic, strong)NSMutableArray *atRangeArray;//存储at某人可点击范围

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kColorFromRGB(kLightGray);
        [self setUI];
    }
    return self;
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
        CGFloat itemWidth = (kSCREEN_WIDTH-20)/3.0;
        CGFloat itemHeight = itemWidth;
        self.flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.flowLayout.minimumLineSpacing = 0;
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

-(UIImageView *)imgViewPraise
{
    if (!_imgViewPraise) {
        _imgViewPraise = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _imgViewPraise.contentMode = UIViewContentModeScaleAspectFit;
        _imgViewPraise.backgroundColor = kColorFromRGB(kThemeYellow);
    }
    return _imgViewPraise;
}

-(UIImageView *)imgViewComment
{
    if (!_imgViewComment) {
        _imgViewComment = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _imgViewComment.contentMode = UIViewContentModeScaleAspectFit;
        _imgViewComment.backgroundColor = kColorFromRGB(kThemeYellow);
    }
    return _imgViewComment;
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
        make.left.mas_equalTo(weakSelf.imgViewPortrait.mas_right).with.offset(5);
        make.right.mas_equalTo(10);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(weakSelf.imgViewPortrait);
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
        make.left.mas_equalTo(weakSelf.imgViewPraise.mas_right).with.offset(5);
        make.size.mas_offset(CGSizeMake(30, 20));
        make.centerY.mas_equalTo(0);
    }];
    [self.imgViewComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.labelPraiseCount.mas_right).with.offset(10);
        make.size.mas_offset(CGSizeMake(15, 15));
        make.centerY.mas_equalTo(0);
    }];
    [self.labelCommentCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imgViewComment.mas_right).with.offset(5);
        make.size.mas_offset(CGSizeMake(30, 20));
        make.centerY.mas_equalTo(0);
    }];
    [self.labelAddTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.size.mas_offset(CGSizeMake(120, 20));
        make.centerY.mas_equalTo(0);
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
    
    //imgViewPortrait
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelCircleDynamicResult.headimg];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewPortrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
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
        [mutableAttributedString addAttribute:(NSString *)kCTBackgroundColorAttributeName
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
    
    //height
    self.cellHeight = collectionHeight+contentHeight+120;
}


















#pragma mark - ***** TTTAttributedLabelDelegate *****
-(void)attributedLabel:(TTTAttributedLabel*)label didSelectLinkWithURL:(NSURL *)url
{
    NSString *topic_id = [url absoluteString];
    if (topic_id && ![topic_id isEqualToString:@""]) {
        //跳转话题
    }
}

-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents
{
    NSString *user_id = addressComponents[@"user_id"];
    if (user_id && ![user_id isEqualToString:@""]) {
        //跳转查看好友详情
        [[NSNotificationCenter defaultCenter]postNotificationName:@"jumpToFocusPersonalVCFromAtSomeone" object:user_id];
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






@end
