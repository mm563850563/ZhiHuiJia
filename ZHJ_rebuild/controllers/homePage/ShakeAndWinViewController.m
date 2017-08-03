//
//  ShakeAndWinViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ShakeAndWinViewController.h"
#import <AudioToolbox/AudioToolbox.h>

//pods
#import <MarqueeLabel.h>

//tools
#import "HWPopTool.h"

//views
#import "ActivityRuleView.h"

//models
#import "GetUserPrizeModel.h"
#import "GetUserPrizeResultModel.h"
#import "GetUserPrize_PrizeListModel.h"


@interface ShakeAndWinViewController ()

@property (weak, nonatomic) IBOutlet UIView *scrollLabelBGView;
@property (weak, nonatomic) IBOutlet UILabel *labelWinPrizeCount;
@property (nonatomic, strong)MarqueeLabel *scrollLabel;
@property (nonatomic, strong)ActivityRuleView *ruleView;
@property (nonatomic, strong)UIView *popContentView;
@property (nonatomic, strong)GetUserPrizeResultModel *modelResult;

@end

@implementation ShakeAndWinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getUserPrizeData];
    [self initPopContentView];
    [self settingScrollLabel];
    [self settingSelfBecomeFirstResponder];
    [self respondWithRAC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self settingSelfResignFirstResponder];
}

#pragma mark - <获取中奖数据>
-(void)getUserPrizeData
{
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetUserPrize];
    NSString *userID = kUserDefaultObject(kUserInfo);
    NSDictionary *dictParameter = @{@"user_id":@"2596",
                                    @"type_id":self.type_id};
    [YQNetworking postWithUrl:urlStr refreshRequest:NO cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        [hud hideAnimated:YES afterDelay:1.0];
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            GetUserPrizeModel *model = [[GetUserPrizeModel alloc]initWithDictionary:dataDict error:nil];
            if ([model.code isEqualToString:@"200"]) {
                self.modelResult = model.data.result;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self sendDataToOutlets];
                });
            }else{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        }
    } failBlock:^(NSError *error) {
        [hud hideAnimated:YES afterDelay:1.0];
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.description];
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }];
}

#pragma mark - <填充数据>
-(void)sendDataToOutlets
{
    //拼接轮播文字
    NSArray *textArray = self.modelResult.prize_list;
    NSString *textScroll = @"";
    for (int i=0; i<textArray.count; i++) {
        GetUserPrize_PrizeListModel *model = textArray[i];
        NSString *textName = model.name;
        NSString *textPrize = model.gift_name;
        if (i == 0) {
            textScroll = [textScroll stringByAppendingString:textName];
            textScroll = [textScroll stringByAppendingFormat:@" %@ ",@"摇中了"];
            textScroll = [textScroll stringByAppendingString:textPrize];
        }else{
            textScroll = [textScroll stringByAppendingFormat:@"    %@",textName];
            textScroll = [textScroll stringByAppendingFormat:@" %@ ",@"摇中了"];
            textScroll = [textScroll stringByAppendingString:textPrize];
        }
    }
    self.scrollLabel.text = textScroll;
    NSUInteger length = textScroll.length;
    self.scrollLabel.scrollDuration = length * 0.1;
    
    //中奖人数
    self.labelWinPrizeCount.text = [NSString stringWithFormat:@"已有 %@ 人抢到豪礼",self.modelResult.count];
    
    //"活动规则"
    self.ruleView.tvActivityRule.text = self.modelResult.activity_rule;
}


#pragma mark - <实现摇一摇功能,使self成为第一响应>
-(void)settingSelfBecomeFirstResponder
{
    [self becomeFirstResponder];
}

#pragma mark - <实现摇一摇功能,使self释放第一响应>
-(void)settingSelfResignFirstResponder
{
    [self resignFirstResponder];
}

#pragma mark - <初始化“活动规则弹框”>
-(void)initPopContentView
{
    self.popContentView = [[UIView alloc]initWithFrame:CGRectMake(40, 200, kSCREEN_WIDTH-80, kSCREENH_HEIGHT-250)];
    self.popContentView.backgroundColor = kClearColor;
    
    self.ruleView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ActivityRuleView class]) owner:nil options:nil].lastObject;
    self.ruleView.frame = self.popContentView.bounds;
    self.ruleView.layer.cornerRadius = 5;
    self.ruleView.layer.masksToBounds = YES;
    
    [self.popContentView addSubview:self.ruleView];
}

#pragma mark - <设置文字滚动>
-(void)settingScrollLabel
{
    self.scrollLabel = [[MarqueeLabel alloc] initWithFrame:self.scrollLabelBGView.bounds duration:8.0 andFadeLength:10.0f];
    self.scrollLabel.marqueeType = MLContinuous;    self.scrollLabel.animationCurve = UIViewAnimationOptionRepeat;
    self.scrollLabel.textColor = kColorFromRGB( kWhite);
    self.scrollLabel.continuousMarqueeExtraBuffer = 1.0f;
    self.scrollLabel.font = [UIFont systemFontOfSize:14];
    self.scrollLabel.tag = 101;
    [self.scrollLabelBGView addSubview:self.scrollLabel];
}

#pragma mark - <点击“活动规则”按钮>
- (IBAction)btnMyRulesAction:(UIButton *)sender
{
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeNone;
    [[HWPopTool sharedInstance] showWithPresentView:self.popContentView animated:YES];
}

#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"closeRuleViewAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [[HWPopTool sharedInstance]closeWithBlcok:nil];
    }];
}








#pragma mark - <摇一摇相关方法>
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"began");
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"cancel");
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake) {//判断是否摇动结束
        NSLog(@"end");
        
//        // 2.设置播放音效
//        SystemSoundID soundID = 1000;
//        AudioServicesPlaySystemSound (soundID);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }else{
        return;
    }
}







@end
