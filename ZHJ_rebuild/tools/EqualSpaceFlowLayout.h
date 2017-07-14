//
//  EqualSpaceFlowLayout.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/13.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  EqualSpaceFlowLayoutDelegate<UICollectionViewDelegateFlowLayout>

@end

@interface EqualSpaceFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,weak) id<EqualSpaceFlowLayoutDelegate> delegate;

@end
