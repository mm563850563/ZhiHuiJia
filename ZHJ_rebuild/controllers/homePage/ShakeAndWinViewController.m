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


@interface ShakeAndWinViewController ()

@property (weak, nonatomic) IBOutlet UIView *scrollLabelBGView;
@property (nonatomic, strong)MarqueeLabel *scrollLabel;
@property (nonatomic, strong)ActivityRuleView *ruleView;
@property (nonatomic, strong)UIView *popContentView;

@end

@implementation ShakeAndWinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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

#pragma mark - <设置文字滚动>
-(void)settingScrollLabel
{
    self.scrollLabel = [[MarqueeLabel alloc] initWithFrame:self.scrollLabelBGView.bounds duration:8.0 andFadeLength:10.0f];
    self.scrollLabel.marqueeType = MLContinuous;    self.scrollLabel.animationCurve = UIViewAnimationOptionRepeat;
    self.scrollLabel.textColor = kColorFromRGB( kWhite);
    self.scrollLabel.continuousMarqueeExtraBuffer = 1.0f;
    self.scrollLabel.text = @"我滚，我滚，我滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚";
    self.scrollLabel.font = [UIFont systemFontOfSize:14];
    self.scrollLabel.tag = 101;
    [self.scrollLabelBGView addSubview:self.scrollLabel];
}

#pragma mark - <点击“活动规则”按钮>
- (IBAction)btnMyRulesAction:(UIButton *)sender
{
    self.popContentView = [[UIView alloc]initWithFrame:CGRectMake(40, 200, kSCREEN_WIDTH-80, kSCREENH_HEIGHT-250)];
    self.popContentView.backgroundColor = kColorFromRGB(kWhite);
    
    self.ruleView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ActivityRuleView class]) owner:nil options:nil].lastObject;
    self.ruleView.frame = self.popContentView.bounds;
    self.ruleView.layer.cornerRadius = 5;
    self.ruleView.layer.masksToBounds = YES;
    
    [self.popContentView addSubview:self.ruleView];
    
    

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
