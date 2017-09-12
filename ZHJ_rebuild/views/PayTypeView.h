//
//  PayTypeView.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/12.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayTypeViewDelegate <NSObject>

-(void)didSelectPayType:(NSString *)payType;
-(void)didClickConfirmWithButton:(UIButton *)button;

@end

@interface PayTypeView : UIView

@property (nonatomic, weak)id<PayTypeViewDelegate> delegate;
@property (nonatomic, strong)NSString *feeDetail;

@end
