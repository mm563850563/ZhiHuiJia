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
    [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteImage" object:sender];
}

@end
