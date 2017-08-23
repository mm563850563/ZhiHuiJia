//
//  NewPostImageCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/27.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPostImageCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteImage;
@property (nonatomic, strong)NSString *fromWhere;
@end
