//
//  NewPostImageCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/27.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "NewPostImageCell.h"

@implementation NewPostImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (IBAction)btnDeleteImageAction:(UIButton *)sender
{
    NSNumber *goods_row = [NSNumber numberWithInteger:self.tag];
    NSNumber *image_item = [NSNumber numberWithInteger:sender.tag];
    NSDictionary *dict = @{@"goods_row":goods_row,
                           @"image_item":image_item};
    if ([self.fromWhere isEqualToString:@"addComment"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteImageFromAddComment" object:dict];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteImage" object:sender];
    }
    
}

@end
