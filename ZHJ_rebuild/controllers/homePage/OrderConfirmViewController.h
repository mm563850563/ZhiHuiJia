//
//  OrderConfirmViewController.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/8.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderConfirmViewController : UIViewController

@property (nonatomic, strong)NSString *goods_id;
@property (nonatomic, strong)NSString *goods_num;
@property (nonatomic, strong)NSArray *goods_spec;
@property (nonatomic, strong)NSDictionary *Parameter;

@end
