//
//  DynamicDetailCommentCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/31.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "DynamicDetailCommentCell.h"

//models
#import "DynamicDetailCommentResultModel.h"

//tools
#import "GetHeightOfText.h"
#import <TTTAttributedLabel.h>

@interface DynamicDetailCommentCell ()<TTTAttributedLabelDelegate>


@property (strong, nonatomic) UIImageView *imgViewProtrait;
@property (strong, nonatomic) UILabel *labelNickName;
@property (strong, nonatomic) UILabel *labelAddTime;
@property (strong, nonatomic) UILabel *labelLikeCount;
@property (strong, nonatomic) UIView *peronalBGView;
@property (strong ,nonatomic) UIView *mainBGView;
@property (nonatomic, strong)TTTAttributedLabel *labelContent;
@property (nonatomic, strong)UIButton *btnLike;
@property (nonatomic, strong)UIButton *btnMore;

@end

@implementation DynamicDetailCommentCell

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

#pragma mark - <点击“赞”>
-(void)btnLikeAction:(UIButton *)sender
{
//    NSString *notifiName = [NSString string];
//    
//    if (sender.selected) {
//        if ([self.whereReuseFrom isEqualToString:@"dynamicDetailVC"]) {
//            notifiName = @"cancelLikeCommentByClickFromDynamicDetailVC";
//        }
//    }else{
//        if ([self.whereReuseFrom isEqualToString:@"dynamicDetailVC"]) {
//            notifiName = @"likeCommentByClickFromDynamicDetailVC";
//        }
//    }
//    
//    [[NSNotificationCenter defaultCenter]postNotificationName:notifiName object:self.modelDynamicCommentResult.talk_id];
}

#pragma mark - <“更多”响应>
- (void)btnMoreAction:(UIButton *)sender
{
    
}

-(UIView *)mainBGView
{
    if (!_mainBGView) {
        _mainBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _mainBGView.backgroundColor = kColorFromRGB(kWhite);
    }
    return _mainBGView;
}

-(UIView *)peronalBGView
{
    if (!_peronalBGView) {
        _peronalBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _peronalBGView.backgroundColor = kColorFromRGB(kWhite);
    }
    return _peronalBGView;
}

-(UIImageView *)imgViewProtrait
{
    if (!_imgViewProtrait) {
        _imgViewProtrait = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _imgViewProtrait.contentMode = UIViewContentModeScaleAspectFill;
        _imgViewProtrait.layer.cornerRadius = 15;
        _imgViewProtrait.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImgViewPortraitAction:)];
        _imgViewProtrait.userInteractionEnabled = YES;
        [_imgViewProtrait addGestureRecognizer:tap];
    }
    return _imgViewProtrait;
}

#pragma mark - <点击头像响应>
-(void)clickImgViewPortraitAction:(UITapGestureRecognizer *)tap
{
    NSString *notifiName = [NSString string];
    if ([self.whereReuseFrom isEqualToString:@"dynamicDetailVC"]) {
        notifiName = @"jumpToFocusPersonalVCByPortraitFromDynamicDetail";
    }
    
    //跳转查看好友详情
    [[NSNotificationCenter defaultCenter]postNotificationName:notifiName object:self.modelDynamicCommentResult.user_id];
}

-(UILabel *)labelNickName
{
    if (!_labelNickName) {
        _labelNickName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _labelNickName.font = [UIFont systemFontOfSize:14];
        _labelNickName.textColor = kColorFromRGB(kDeepGray);
    }
    return _labelNickName;
}

-(UILabel *)labelAddTime
{
    if (!_labelAddTime) {
        _labelAddTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _labelAddTime.font = [UIFont systemFontOfSize:10];
        _labelAddTime.textColor = kColorFromRGB(kDeepGray);
    }
    return _labelAddTime;
}

-(UIButton *)btnLike
{
    if (!_btnLike) {
        _btnLike = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnLike.frame = CGRectMake(0, 0, 50, 50);
        
        [_btnLike setImage:[UIImage imageNamed:@"like_black"] forState:UIControlStateNormal];
        [_btnLike setImage:[UIImage imageNamed:@"like_yellow"] forState:UIControlStateSelected];
        
        [_btnLike addTarget:self action:@selector(btnLikeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLike;
}

-(UIButton *)btnMore
{
    if (!_btnMore) {
        _btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnMore.frame = CGRectMake(0, 0, 50, 50);
        _btnMore.backgroundColor = kColorFromRGB(kThemeYellow);
        _btnMore.hidden = YES;
    }
    return _btnMore;
}

-(UILabel *)labelLikeCount
{
    if (!_labelLikeCount) {
        _labelLikeCount = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _labelLikeCount.font = [UIFont systemFontOfSize:11];
        _labelLikeCount.textAlignment = 2;
    }
    return _labelLikeCount;
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

-(void)setUI
{
    [self.contentView addSubview:self.mainBGView];
    [self.mainBGView addSubview:self.peronalBGView];
    [self.mainBGView addSubview:self.labelContent];
    [self.peronalBGView addSubview:self.imgViewProtrait];
    [self.peronalBGView addSubview:self.labelNickName];
    [self.peronalBGView addSubview:self.labelAddTime];
//    [self.peronalBGView addSubview:self.btnMore];
    [self.peronalBGView addSubview:self.btnLike];
    [self.peronalBGView addSubview:self.labelLikeCount];
    
    
    __weak typeof(self) weakSelf = self;
    [self.mainBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.5);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.peronalBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.peronalBGView.mas_bottom).with.offset(10);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(5);
    }];
    [self.imgViewProtrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(30, 30));
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
    }];
    [self.labelNickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imgViewProtrait.mas_right).with.offset(10);
        make.right.mas_equalTo(-100);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(-10);
    }];
    [self.labelAddTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imgViewProtrait.mas_right).with.offset(10);
        make.right.mas_equalTo(-100);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(10);
    }];
//    [self.btnMore mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-10);
//        make.size.mas_offset(CGSizeMake(20, 20));
//        make.centerY.mas_equalTo(0);
//    }];
    [self.btnLike mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.size.mas_offset(CGSizeMake(18, 18));
        make.centerY.mas_equalTo(0);
    }];
    [self.labelLikeCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.labelNickName.mas_right).with.offset(5);
        make.right.mas_equalTo(weakSelf.btnLike.mas_left).with.offset(-5);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
    }];
}

-(void)setModelDynamicCommentResult:(DynamicDetailCommentResultModel *)modelDynamicCommentResult
{
    _modelDynamicCommentResult = modelDynamicCommentResult;
    
    //label
    self.labelNickName.text = modelDynamicCommentResult.nickname;
    self.labelAddTime.text = modelDynamicCommentResult.addtime;
    self.labelLikeCount.text = modelDynamicCommentResult.like_count;
    
    //imgViewPortrait
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelDynamicCommentResult.headimg];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewProtrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
    /*
    //btnLike
    if ([modelDynamicCommentResult.is_liked isEqualToString:@"1"]) {
        self.btnLike.selected = YES;
    }else{
        self.btnLike.selected = NO;
    }
    */
    
    //labelContent
    NSString *strContent = [NSString string];
    if ([modelDynamicCommentResult.tips isEqualToString:@""]) {
        strContent = modelDynamicCommentResult.content;
    }else{
        strContent = [NSString stringWithFormat:@"回复 %@: %@",modelDynamicCommentResult.reply_nickname,modelDynamicCommentResult.content];
    }
    
    CGFloat contentHeight = [GetHeightOfText getHeightWithContent:strContent font:13 contentSize:CGSizeMake(kSCREEN_WIDTH-20, MAXFLOAT)];
    [self.labelContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentHeight);
    }];
    
    //富文本
    //富文本不加下划线（加了下划线会影响富文本颜色）
    self.labelContent.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
//    __weak typeof(self) weakSelf = self;
    [self.labelContent setText:strContent afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        if (![modelDynamicCommentResult.tips isEqualToString:@""]) {
            //设置可点击范围
            NSRange rangeReply = [[mutableAttributedString string]rangeOfString:@"回复" options:NSCaseInsensitiveSearch];
            NSRange rangeReplier = [[mutableAttributedString string]rangeOfString:[NSString stringWithFormat:@"%@:",modelDynamicCommentResult.reply_nickname] options:NSCaseInsensitiveSearch];
            
            //设置可点击文本的颜色;
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                            value:kColorFromRGB(kDeepGray)
                                            range:rangeReply];
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                            value:kColorFromRGB(kDeepGray)
                                            range:rangeReplier];
            
            
            //加上下划线
//            [mutableAttributedString addAttribute:NSUnderlineColorAttributeName
//                                            value:[UIColor clearColor]
//                                            range:rangeReply];
//            [mutableAttributedString addAttribute:NSUnderlineColorAttributeName
//                                            value:[UIColor clearColor]
//                                            range:rangeReplier];
        }
        return mutableAttributedString;
    }];
    
    self.cellHeight = contentHeight + 70;
}


@end
