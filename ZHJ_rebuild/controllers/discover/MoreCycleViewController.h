//
//  MoreCycleViewController.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/27.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreCycleViewController : UIViewController

@property (nonatomic, strong)NSString *moreType;
@property (nonatomic, strong)NSString *classify_id;

//区别：记录从哪里跳转的
@property (nonatomic, strong)NSString *whereReuseFrom;

@end
