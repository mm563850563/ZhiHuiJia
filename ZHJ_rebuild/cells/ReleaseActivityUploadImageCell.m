//
//  ReleaseActivityUploadImageCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/24.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ReleaseActivityUploadImageCell.h"

@interface ReleaseActivityUploadImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ReleaseActivityUploadImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setImg:(UIImage *)img
{
    self.imgView.image = img;
}

@end
