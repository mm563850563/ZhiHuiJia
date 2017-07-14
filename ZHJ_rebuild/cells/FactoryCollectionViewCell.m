//
//  FactoryCollectionViewCell.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/6.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "FactoryCollectionViewCell.h"
#import "BaseModel.h"
#import "BaseCollectionViewCell.h"

@implementation FactoryCollectionViewCell

+(BaseCollectionViewCell *)createTableViewCellWithModel:(BaseModel *)model collection:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    //1.获取cell的名字
    NSString *cellName = NSStringFromClass([model class]);
    //2.创建cell
    BaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    //3.返回cell
    return cell;
}

@end
