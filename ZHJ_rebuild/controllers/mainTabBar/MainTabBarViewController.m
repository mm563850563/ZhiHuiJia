//
//  MainTabBarViewController.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/5.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingTabBarItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)settingTabBarItem
{
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kColorFromRGB(kThemeYellow),NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateSelected];
    
    //home_image
    UIImage *image1_normal = [UIImage imageNamed:@"themeYellow_home_normal"];
    UIImage *image1_selected = [UIImage imageNamed:@"themeYellow_home_selected"];
    image1_selected = [image1_selected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //categate_image
    UIImage *image2_normal = [UIImage imageNamed:@"themeYellow_categate_normal"];
    UIImage *image2_selected = [UIImage imageNamed:@"themeYellow_categate_selected"];
    image2_selected = [image2_selected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //discover_image
    UIImage *image3_normal = [UIImage imageNamed:@"themeYellow_discover_normal"];
    image3_normal = [image3_normal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image3_selected = [UIImage imageNamed:@"themeYellow_discover_selected"];
    image3_selected = [image3_selected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //cart_image
    UIImage *image4_normal = [UIImage imageNamed:@"themeYellow_cart_normal"];
    image4_normal = [image4_normal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image4_selected = [UIImage imageNamed:@"themeYellow_cart_selected"];
    image4_selected = [image4_selected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //personal_image
    UIImage *image5_normal = [UIImage imageNamed:@"themeYellow_personal_normal"];
    image5_normal = [image5_normal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image5_selected = [UIImage imageNamed:@"themeYellow_personal_selected"];
    image5_selected = [image5_selected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    
    
    
    
    
    
    UITabBar *tabBar = self.tabBar;
    //item_home
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    [item0 setImage:image1_normal];
    [item0 setSelectedImage:image1_selected];
    
    //item_categate
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    [item1 setImage:image2_normal];
    [item1 setSelectedImage:image2_selected];
    
    //item_discover
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    [item2 setImage:image3_normal];
    [item2 setSelectedImage:image3_selected];
    
    //item_cart
    UITabBarItem *item3 = [tabBar.items objectAtIndex:3];
    [item3 setImage:image4_normal];
    [item3 setSelectedImage:image4_selected];
    
    //item_cart
    UITabBarItem *item4 = [tabBar.items objectAtIndex:4];
    [item4 setImage:image5_normal];
    [item4 setSelectedImage:image5_selected];
}



@end
