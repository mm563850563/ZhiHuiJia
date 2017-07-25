//
//  ShakeAndWinViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ShakeAndWinViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>

//pods
#import <MarqueeLabel.h>


@interface ShakeAndWinViewController ()

@property (weak, nonatomic) IBOutlet UIView *scrollLabelBGView;
@property (nonatomic, strong)MarqueeLabel *scrollLabel;

@end

@implementation ShakeAndWinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self settingScrollLabel];
    [self settingSelfBecomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self settingSelfResignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
//    MarqueeLabel *lengthyLabel = [[MarqueeLabel alloc] initWithFrame:self.scrollLabelBGView.bounds duration:8.0 andFadeLength:10.0f];
//    [self.scrollLabelBGView addSubview:lengthyLabel];
//    lengthyLabel.text = @"开始觉得可能打开 空 空i 我 口肉文i u 各位 i 俄 u 如何iu肉文 i 我哦 ii 我。 uui 为 i 哦额为了论文啦；我 京味儿看了五块。我3i哦 in 尼玛尼玛。快哦 阿里点就起来 哦吉欧欧哦哦片哦opines口哦饭离开哦 欧哦。";
    
    self.scrollLabel = [[MarqueeLabel alloc] initWithFrame:self.scrollLabelBGView.bounds duration:8.0 andFadeLength:10.0f];
    self.scrollLabel.marqueeType = MLContinuous;
//    self.scrollLabel.scrollDuration = 5;
    self.scrollLabel.animationCurve = UIViewAnimationOptionRepeat;
//    self.scrollLabel.fadeLength = 1.0f;
    self.scrollLabel.textColor = kColorFromRGB( kWhite);
    self.scrollLabel.continuousMarqueeExtraBuffer = 1.0f;
    self.scrollLabel.text = @"我滚，我滚，我滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚滚";
    self.scrollLabel.tag = 101;
    [self.scrollLabelBGView addSubview:self.scrollLabel];
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
        
        // 2.设置播放音效
//        SystemSoundID soundID;
//        NSString *path = [[NSBundle mainBundle ] pathForResource:@"shake_sound_male" ofType:@"wav"];
//        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
//        // 添加摇动声音
//        AudioServicesPlaySystemSound (soundID);
//        
//        // 3.设置震动
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }else{
        return;
    }
}







@end
