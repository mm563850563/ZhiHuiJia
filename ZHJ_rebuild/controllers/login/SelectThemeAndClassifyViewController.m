//
//  SelectThemeAndClassifyViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/7.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SelectThemeAndClassifyViewController.h"

//cells
#import "ClassifyCollectionViewCell.h"
#import "ThemeCollectionViewCell.h"

//models
#import "ClassifyDataModel.h"
#import "ClassifyResultModel.h"

//tools
#import <AFHTTPSessionManager.h>

@interface SelectThemeAndClassifyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForClassifyBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForThemeBGView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewTheme;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayoutTheme;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewClassify;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayoutClassify;

@property (nonatomic, strong)NSMutableArray *themeArray;
@property (nonatomic, strong)NSArray *classifyArray;
@property (nonatomic, strong)NSMutableArray *selectClassifyArray;

@end

@implementation SelectThemeAndClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getClassifyData];
    [self settingCollectionViewTheme];
    [self settingCollectionViewClassify];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(NSMutableArray *)themeArray
{
    if (!_themeArray) {
        _themeArray = [NSMutableArray array];
    }
    return _themeArray;
}

-(NSMutableArray *)selectClassifyArray
{
    if (!_selectClassifyArray) {
        _selectClassifyArray = [NSMutableArray array];
    }
    return _selectClassifyArray;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <获取你喜欢的品类>
-(void)getClassifyData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetCategory];
    NSDictionary *dictParameter = @{@"user_id":@"3560"};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                ClassifyDataModel *modelData = [[ClassifyDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.classifyArray = modelData.result;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置heightForClassifyBGView
                    CGFloat itemWidth = (kSCREEN_WIDTH-20)/4.0;
                    CGFloat itemHeight = itemWidth/4.0*5.0;
                    NSInteger count = self.classifyArray.count/4;
                    if (self.classifyArray.count%4>0) {
                        count++;
                    }
                    CGFloat height = count * itemHeight;
                    self.heightForClassifyBGView.constant = height + 70;
                    //设置heightForScrollView
                    self.heightForScrollView.constant = self.heightForClassifyBGView.constant+self.heightForThemeBGView.constant+150;
                    if (kSCREENH_HEIGHT>self.heightForScrollView.constant) {
                        self.heightForScrollView.constant = kSCREENH_HEIGHT;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionViewClassify reloadData];
                        //默认选中
                        for (ClassifyResultModel *modelResult in self.classifyArray) {
                            if ([modelResult.is_selected isEqualToString:@"1"]) {
                                [self.selectClassifyArray addObject:modelResult.cat_id];
                            }
                        }
                        [hud hideAnimated:YES afterDelay:1.0];
                    });
                    
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        });
    }];
}


#pragma mark - <更新用户喜欢的品类>
-(void)updateUserFavouriteClassifyWithDictParameter:(NSDictionary *)dictParameter cat_ids:(NSArray *)cat_ids
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kUpdateFavoriteCategory];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",
                                                         @"multipart/form-data",
                                                         @"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json", nil];
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [manager POST:urlStr
       parameters:dictParameter
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    for (int i=0; i<cat_ids.count; i++) {
        NSString *name = [NSString stringWithFormat:@"cat_id[%d]",i];
        NSString *str = cat_ids[i];
        [formData appendPartWithFormData:[str dataUsingEncoding:NSUTF8StringEncoding] name:name];
    }
    
}
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if (responseObject) {
                  NSDictionary *dataDict = (NSDictionary *)responseObject;
                  NSNumber *code = (NSNumber *)dataDict[@"code"];
                  if ([code isEqual:@200]) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [hud hideAnimated:YES afterDelay:1.0];
                          MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                          [hudWarning hideAnimated:YES afterDelay:2.0];
                          hudWarning.completionBlock = ^{
                              [self dismissViewControllerAnimated:YES completion:nil];
                          };
                      });
                  }else{
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [hud hideAnimated:YES afterDelay:1.0];
                          MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                          [hudWarning hideAnimated:YES afterDelay:2.0];
                      });
                  }
              }else{
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [hud hideAnimated:YES afterDelay:1.0];
                      MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                      [hudWarning hideAnimated:YES afterDelay:2.0];
                  });
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [hud hideAnimated:YES afterDelay:1.0];
                  MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                  [hudWarning hideAnimated:YES afterDelay:2.0];
              });
          }];
//    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
//    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
//        if (response) {
//            NSDictionary *dataDict = (NSDictionary *)response;
//            NSNumber *code = (NSNumber *)dataDict[@"code"];
//            if ([code isEqual:@200]) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [hud hideAnimated:YES afterDelay:1.0];
//                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
//                    [hudWarning hideAnimated:YES afterDelay:2.0];
//                    hudWarning.completionBlock = ^{
//                        [self dismissViewControllerAnimated:YES completion:nil];
//                    };
//                });
//            }else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [hud hideAnimated:YES afterDelay:1.0];
//                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
//                    [hudWarning hideAnimated:YES afterDelay:2.0];
//                });
//            }
//        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [hud hideAnimated:YES afterDelay:1.0];
//                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
//                [hudWarning hideAnimated:YES afterDelay:2.0];
//            });
//        }
//    } failBlock:^(NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud hideAnimated:YES afterDelay:1.0];
//            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
//            [hudWarning hideAnimated:YES afterDelay:2.0];
//        });
//    }];
}

#pragma mark - <配置collectionViewTheme>
-(void)settingCollectionViewTheme
{
    CGFloat itemWidth = (kSCREEN_WIDTH-20)/6.1;
    CGFloat itemHeight = itemWidth/3.0*4.0;
    self.flowLayoutTheme.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.flowLayoutTheme.minimumInteritemSpacing = 0;
    
    self.collectionViewTheme.delegate = self;
    self.collectionViewTheme.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([ThemeCollectionViewCell class]) bundle:nil];
    [self.collectionViewTheme registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([ThemeCollectionViewCell class])];
    
    NSDictionary *dict1 = @{@"imgViewTheme":@"theme_yellow",
                            @"labelNumber":@"01",
                            @"labelEnglishName":@"FASHION YELLOW",
                            @"labelChineseName":@"时尚黄"};
    NSDictionary *dict2 = @{@"imgViewTheme":@"theme_green",
                            @"labelNumber":@"02",
                            @"labelEnglishName":@"FRESH GREEN",
                            @"labelChineseName":@"清新绿"};
    NSDictionary *dict3 = @{@"imgViewTheme":@"theme_blue",
                            @"labelNumber":@"03",
                            @"labelEnglishName":@"WISDOM BLUE",
                            @"labelChineseName":@"智慧蓝"};
    NSDictionary *dict4 = @{@"imgViewTheme":@"theme_pink",
                            @"labelNumber":@"04",
                            @"labelEnglishName":@"YOUTH POWDER",
                            @"labelChineseName":@"青春粉"};
    NSDictionary *dict5 = @{@"imgViewTheme":@"theme_red",
                            @"labelNumber":@"05",
                            @"labelEnglishName":@"CHINA RED",
                            @"labelChineseName":@"中国红"};
    NSDictionary *dict6 = @{@"imgViewTheme":@"theme_gray",
                            @"labelNumber":@"06",
                            @"labelEnglishName":@"SPACE GRAY",
                            @"labelChineseName":@"太空灰"};
    [self.themeArray addObject:dict1];
    [self.themeArray addObject:dict2];
    [self.themeArray addObject:dict3];
    [self.themeArray addObject:dict4];
    [self.themeArray addObject:dict5];
    [self.themeArray addObject:dict6];
    
    //默认选中第一项
    [self.collectionViewTheme selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    //设置heightForThemeBGView
    CGFloat height = itemHeight + 40;
    self.heightForThemeBGView.constant = height;
}

#pragma mark - <配置collectionViewClassify>
-(void)settingCollectionViewClassify
{
    CGFloat itemWidth = (kSCREEN_WIDTH-20)/4.0;
    CGFloat itemHeight = itemWidth/4.0*5.0;
    self.flowLayoutClassify.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.flowLayoutClassify.minimumInteritemSpacing = 0;
    
    self.collectionViewClassify.delegate = self;
    self.collectionViewClassify.dataSource = self;
    self.collectionViewClassify.allowsSelection = YES;
    self.collectionViewClassify.allowsMultipleSelection = YES;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([ClassifyCollectionViewCell class]) bundle:nil];
    [self.collectionViewClassify registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([ClassifyCollectionViewCell class])];
}

#pragma mark - <返回按钮>
- (IBAction)btnBackAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <选好按钮>
- (IBAction)btnSelectedAction:(UIButton *)sender
{
    NSDictionary *dict = @{@"user_id":@"3560"};
    [self updateUserFavouriteClassifyWithDictParameter:dict cat_ids:self.selectClassifyArray];
}










#pragma mark - ***** UICollectionViewDelegate,UICollectionViewDataSource ******
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if (collectionView == self.collectionViewTheme) {
        number = 6;
    }else if (collectionView == self.collectionViewClassify){
        number = self.classifyArray.count;
    }
    return number;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [[UICollectionViewCell alloc]init];
    if (collectionView == self.collectionViewTheme) {
        ThemeCollectionViewCell *cellTheme = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ThemeCollectionViewCell class]) forIndexPath:indexPath];
        NSDictionary *dict = self.themeArray[indexPath.item];
        cellTheme.dict = dict;
        cell = cellTheme;
    }else if (collectionView == self.collectionViewClassify){
        ClassifyCollectionViewCell *cellClassify = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ClassifyCollectionViewCell class]) forIndexPath:indexPath];
        ClassifyResultModel *modelResult = self.classifyArray[indexPath.item];
        cellClassify.modelResult = modelResult;
        cell = cellClassify;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionViewTheme) {
        
    }else if (collectionView == self.collectionViewClassify){
        ClassifyResultModel *modelResult = self.classifyArray[indexPath.item];
        if (![self.selectClassifyArray containsObject:modelResult.cat_id]) {
            if (self.selectClassifyArray.count < 2) {
                ClassifyCollectionViewCell *cell = (ClassifyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
                cell.imgViewSelected.hidden = NO;
                [self.selectClassifyArray addObject:modelResult.cat_id];
                
            }else{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"最多选择2项"];
                [hudWarning hideAnimated:YES afterDelay:YES];
            }
        }
        
    }
    //所有选中的item
//    collectionView.indexPathsForSelectedItems;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionViewClassify) {
        ClassifyResultModel *modelResult = self.classifyArray[indexPath.item];
        if ([self.selectClassifyArray containsObject:modelResult.cat_id]) {
            if (self.selectClassifyArray.count > 1) {
                ClassifyCollectionViewCell *cell = (ClassifyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
                cell.imgViewSelected.hidden = YES;
                [self.selectClassifyArray removeObject:modelResult.cat_id];
                
            }
        }
        
    }
}

//-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (collectionView == self.collectionViewTheme) {
//        
//    }else if (collectionView == self.collectionViewClassify){
//        ClassifyCollectionViewCell *cell = (ClassifyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        cell.imgViewSelected.hidden = NO;
//    }
//    return YES;
//}
//
//-(BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (collectionView == self.collectionViewClassify) {
//        ClassifyCollectionViewCell *cell = (ClassifyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        cell.imgViewSelected.hidden = YES;
//    }
//    return  YES;
//}





@end
