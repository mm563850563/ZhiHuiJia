//
//  ProductDetailImageCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ProductDetailImageCell.h"
#import "GoodsDetailContentModel.h"

@interface ProductDetailImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgDetail;

@end

@implementation ProductDetailImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(GoodsDetailContentModel *)model
{
    if (_model != model) {
        _model = model;
        [self layoutIfNeeded];
        NSString *str = [NSString stringWithFormat:@"%@%@",kDomainImage,model.image_url];
        NSURL *url = [NSURL URLWithString:str];
        
        [self.imgDetail sd_setImageWithURL:url placeholderImage:kPlaceholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            CGSize size = image.size;
            CGFloat scale = kSCREEN_WIDTH / size.width;
            CGFloat height = scale * size.height;
            self.cellHeight = height;
        }];
    }
}

@end
