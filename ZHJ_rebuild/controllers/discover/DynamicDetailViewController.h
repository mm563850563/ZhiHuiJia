//
//  DynamicDetailViewController.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/19.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicDetailViewController : UIViewController

@property (nonatomic, strong)NSString *user_id;
@property (nonatomic, strong)NSString *talk_id;
@property (nonatomic, strong)NSString *message_id;

@property (nonatomic, strong)NSString *whereReuseFrom;

@end
