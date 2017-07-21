//
//  ProductDetailViewController.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/11.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "RatingBar.h"
#import <STPickerArea.h>

@interface ProductDetailViewController ()<STPickerAreaDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForScrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *starBarBGView;
@property (weak, nonatomic) IBOutlet UIView *cycleScrollBGView;
@property (weak, nonatomic) IBOutlet UILabel *labelArea;

@property (nonatomic, strong)RatingBar *starBar;
@property (nonatomic, strong)STPickerArea *areaPicker;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addRatingBar];
    [self addCycleScollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <添加cycleScrollView>
-(void)addCycleScollView
{
    
}

#pragma mark - <添加ratingBar>
-(void)addRatingBar
{
    self.starBar = [[RatingBar alloc]initWithFrame:self.starBarBGView.bounds];
    [self.starBarBGView addSubview:self.starBar];
    self.starBar.starNumber = 3;
    self.starBar.enable = NO;
    [self.starBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - <选择送货地点>
- (IBAction)btnSelectArea:(UIButton *)sender
{
    self.areaPicker = [[STPickerArea alloc]init];
    self.areaPicker.delegate = self;
    [self.areaPicker show];
}







#pragma mark - **** STPickerAreaDelegate ****
-(void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    NSMutableArray *array = [NSMutableArray array];
    if (![province isEqualToString:@""]) {
        [array addObject:province];
    }
    if (![city isEqualToString:@""]){
        [array addObject:city];
    }
    if (![area isEqualToString:@""]){
        [array addObject:area];
    }
    
    NSString *string = province;
    for (int i = 1; i < array.count; i++) {
        string = [string stringByAppendingFormat:@">%@",array[i]];
    }
    self.labelArea.text = string;
}



@end
