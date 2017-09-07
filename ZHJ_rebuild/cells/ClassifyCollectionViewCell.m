//
//  ClassifyCollectionViewCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/7.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ClassifyCollectionViewCell.h"

#import "ClassifyResultModel.h"

@interface ClassifyCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewClassify;
@property (weak, nonatomic) IBOutlet UILabel *labelName;

@end

@implementation ClassifyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//-(void)setSelected:(BOOL)selected
//{
//    if (selected) {
//        self.imgViewSelected.hidden = NO;
//    }else{
//        self.imgViewSelected.hidden = YES;
//    }
//}

-(void)drawRect:(CGRect)rect
{
    CGRect frame = self.imgViewClassify.frame;
    CGFloat corner = frame.size.width/2.0;
    
    self.imgViewClassify.layer.cornerRadius = corner;
    self.imgViewClassify.layer.masksToBounds = YES;
    
    self.imgViewSelected.layer.cornerRadius = corner;
    self.imgViewSelected.layer.masksToBounds = YES;
}


-(void)setModelResult:(ClassifyResultModel *)modelResult
{
    _modelResult = modelResult;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelResult.image];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewClassify sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    self.labelName.text = modelResult.cat_name;
    
    if ([modelResult.is_selected isEqualToString:@"1"]) {
        self.imgViewSelected.hidden = NO;
    }else{
        self.imgViewSelected.hidden = YES;
    }
}



@end
