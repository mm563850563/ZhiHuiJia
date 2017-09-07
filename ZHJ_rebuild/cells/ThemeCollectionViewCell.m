//
//  ThemeCollectionViewCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/7.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ThemeCollectionViewCell.h"

@interface ThemeCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewTheme;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewSelected;
@property (weak, nonatomic) IBOutlet UILabel *labelNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelEnglishName;
@property (weak, nonatomic) IBOutlet UILabel *labelChineseName;

@end

@implementation ThemeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setSelected:(BOOL)selected
{
    if (selected) {
        self.imgViewSelected.hidden = NO;
    }else{
        self.imgViewSelected.hidden = YES;
    }
}

-(void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,dict[@"imgViewTheme"]];
    self.imgViewTheme.image = [UIImage imageNamed:imgStr];
    
    self.labelNumber.text = dict[@"labelNumber"];
    self.labelEnglishName.text = dict[@"labelEnglishName"];
    self.labelChineseName.text = dict[@"labelChineseName"];
    
}

@end
