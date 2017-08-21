//
//  UIImage+Orientation.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Orientation)

//纠正iphone拍摄的照片上传后的旋转问题
+(UIImage *)fixOrientation:(UIImage *)aImage;

@end
