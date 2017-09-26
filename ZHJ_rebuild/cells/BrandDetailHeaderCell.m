//
//  BrandDetailHeaderCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "BrandDetailHeaderCell.h"
#import "BrandDetail_BrandDetailModel.h"

#import "ZHJMessageViewController.h"

@interface BrandDetailHeaderCell ()<EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource>

@end

@implementation BrandDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    [self.imgProduct mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(200);
    }];
}

-(void)setModel:(BrandDetail_BrandDetailModel *)model
{
    if (_model != model) {
        _model = model;
        
        NSString *imgBannerStr = [NSString stringWithFormat:@"%@%@",kDomainImage,model.banner];
        NSURL *urlBanner = [NSURL URLWithString:imgBannerStr];
        [self.imgProduct sd_setImageWithURL:urlBanner placeholderImage:kPlaceholder];
        
        NSString *imgLogoStr  =[NSString stringWithFormat:@"%@%@",kDomainImage,model.logo];
        NSURL *urlLogo = [NSURL URLWithString:imgLogoStr];
        [self.imgBrand sd_setImageWithURL:urlLogo placeholderImage:kPlaceholder];
        
        self.labelStoreName.text = _model.brand_name;
        
    }
}


#pragma mark - <跳转“客服界面”>
-(void)jumpToSingleChatVCWithChatter:(NSString *)chatter
{
    
}




#pragma mark - <点击在线客服按钮响应>
- (IBAction)btnOnlineContactAction:(UIButton *)sender
{
    //在当前当前控件遍历所在的viewcontroller
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *)nextResponder;
            ZHJMessageViewController *singleChatVC = [[ZHJMessageViewController alloc]initWithConversationChatter:kZHJService conversationType:EMConversationTypeChat];
            singleChatVC.delegate = self;
            singleChatVC.dataSource = self;
            singleChatVC.navigationItem.title = @"智惠加客服";
            [vc.navigationController pushViewController:singleChatVC animated:YES];
        }
    }
}










#pragma mark - **** EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource ****
-(id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    if (model.isSender) {
        NSString *headimg = kUserDefaultObject(kUserHeadimg);
        model.avatarURLPath = headimg;
        model.nickname = @"";
    }else{
        model.avatarImage = [UIImage imageNamed:@"appLogo"];
        model.nickname = @"";
    }
    model.failImageName = @"huantu";
    return model;
}

@end
