//
//  BrandStoryViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "BrandStoryViewController.h"

@interface BrandStoryViewController ()

@property (nonatomic, strong)UITextView *tvStory;

@end

@implementation BrandStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(UITextView *)tvStory
{
    if (!_tvStory) {
        _tvStory = [[UITextView alloc]init];
        _tvStory.editable = NO;
        _tvStory.font = [UIFont systemFontOfSize:14];
    }
    return _tvStory;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <setUI>
-(void)setUI
{
    [self.view addSubview:self.tvStory];
    [self.tvStory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(10, 20, 20, 10));
    }];
    
    self.tvStory.text = @"计算机房个 v 哦时间。 是非观地方的高度 个。市发动第四个三个地方个地方个点风格的 风格的风格的多幅高的 的风格 的父母官高 看见i简介哦哦破饿哦速度佛；罗迪克 流口水的；；肌肤可我饿哭人为哦人陪了我日； 啦啦；a.ns努力；拉舒服的能力及 边框和拉萨了地方计算机房个 v 哦时间。 是非观地方的高度 个。市发动第四个三个地方个地方个点风格的 风格的风格的多幅高的 的风格 的父母官高 看见i简介哦哦破饿哦速度佛；罗迪克 流口水的；；肌肤可我饿哭人为哦人陪了我日； 啦啦；a.ns努力；拉舒服的能力及 边框和拉萨了地方计算机房个 v 哦时间。 是非观地方的高度 个。市发动第四个三个地方个地方个点风格的 风格的风格的多幅高的 的风格 的父母官高 看见i简介哦哦破饿哦速度佛；罗迪克 流口水的；；肌肤可我饿哭人为哦人陪了我日； 啦啦；a.ns努力；拉舒服的能力及 边框和拉萨了地方计算机房个 v 哦时间。 是非观地方的高度 个。市发动第四个三个地方个地方个点风格的 风格的风格的多幅高的 的风格 的父母官高 看见i简介哦哦破饿哦速度佛；罗迪克 流口水的；；肌肤可我饿哭人为哦人陪了我日； 啦啦；a.ns努力；拉舒服的能力及 边框和拉萨了地方计算机房个 v 哦时间。 是非观地方的高度 个。市发动第四个三个地方个地方个点风格的 风格的风格的多幅高的 的风格 的父母官高 看见i简介哦哦破饿哦速度佛；罗迪克 流口水的；；肌肤可我饿哭人为哦人陪了我日； 啦啦；a.ns努力；拉舒服的能力及 边框和拉萨了地方计算机房个 v 哦时间。 是非观地方的高度 个。市发动第四个三个地方个地方个点风格的 风格的风格的多幅高的 的风格 的父母官高 看见i简介哦哦破饿哦速度佛；罗迪克 流口水的；；肌肤可我饿哭人为哦人陪了我日； 啦啦；a.ns努力；拉舒服的能力及 边框和拉萨了地方计算机房个 v 哦时间。 是非观地方的高度 个。市发动第四个三个地方个地方个点风格的 风格的风格的多幅高的 的风格 的父母官高 看见i简介哦哦破饿哦速度佛；罗迪克 流口水的；；肌肤可我饿哭人为哦人陪了我日； 啦啦；a.ns努力；拉舒服的能力及 边框和拉萨了地方计算机房个 v 哦时间。 是非观地方的高度 个。市发动第四个三个地方个地方个点风格的 风格的风格的多幅高的 的风格 的父母官高 看见i简介哦哦破饿哦速度佛；罗迪克 流口水的；；肌肤可我饿哭人为哦人陪了我日； 啦啦；a.ns努力；拉舒服的能力及 边框和拉萨了地方计算机房个 v 哦时间。 是非观地方的高度 个。市发动第四个三个地方个地方个点风格的 风格的风格的多幅高的 的风格 的父母官高 看见i简介哦哦破饿哦速度佛；罗迪克 流口水的；；肌肤可我饿哭人为哦人陪了我日； 啦啦；a.ns努力；拉舒服的能力及 边框和拉萨了地方计算机房个 v 哦时间。 是非观地方的高度 个。市发动第四个三个地方个地方个点风格的 风格的风格的多幅高的 的风格 的父母官高 看见i简介哦哦破饿哦速度佛；罗迪克 流口水的；；肌肤可我饿哭人为哦人陪了我日； 啦啦；a.ns努力；拉舒服的能力及 边框和拉萨了地方计算机房个 v 哦时间。 是非观地方的高度 个。市发动第四个三个地方个地方个点风格的 风格的风格的多幅高的 的风格 的父母官高 看见i简介哦哦破饿哦速度佛；罗迪克 流口水的；；肌肤可我饿哭人为哦人陪了我日； 啦啦；a.ns努力；拉舒服的能力及 边框和拉萨了地方";
}








@end
