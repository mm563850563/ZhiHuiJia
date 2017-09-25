//
//  SuccessPayRecommendMemberCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/15.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetInterestingCircleResultModel;

@interface SuccessPayRecommendMemberCell : UICollectionViewCell

@property (nonatomic, strong)GetInterestingCircleResultModel *modelInterestCircle;
//旋转指令
@property (nonatomic, strong)NSString *rotationOrder;

@end
