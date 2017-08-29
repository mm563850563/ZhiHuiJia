//
//  MyCircleDynamicImageCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/29.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyCircleDynamicImageCell.h"

@interface MyCircleDynamicImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewDynamic;

@end

@implementation MyCircleDynamicImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setImgStr:(NSString *)imgStr
{
    _imgStr = imgStr;
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewDynamic sd_setImageWithURL:url placeholderImage:kPlaceholder];
}




@end
