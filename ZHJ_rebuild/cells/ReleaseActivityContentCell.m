//
//  ReleaseActivityContentCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/24.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ReleaseActivityContentCell.h"

//views
#import "STPickerArea.h"
#import "STPickerDate.h"

@interface ReleaseActivityContentCell ()<UITextFieldDelegate,STPickerAreaDelegate,STPickerDateDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfTitle;
@property (weak, nonatomic) IBOutlet UITextField *tfStartTime;
@property (weak, nonatomic) IBOutlet UITextField *tfEndTime;
@property (weak, nonatomic) IBOutlet UITextField *tfRegion;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress;
@property (weak, nonatomic) IBOutlet UITextField *tfInitiator;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfFee;
@property (weak, nonatomic) IBOutlet UITextField *tfDetail;

@property (nonatomic, strong)STPickerArea *pickerArea;
@property (nonatomic, strong)STPickerDate *pickerDateStart;
@property (nonatomic, strong)STPickerDate *pickerDateEnd;

@property (nonatomic, strong)NSString *timeStart;//活动开始时间
@property (nonatomic, strong)NSString *timeEnd;//活动结束时间
@property (nonatomic, strong)NSString *province;//省ID
@property (nonatomic, strong)NSString *city;//市ID
@property (nonatomic, strong)NSString *district;//区ID


@end

@implementation ReleaseActivityContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self settingOutlets];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - <配置参数>
-(void)settingOutlets
{
    self.tfEndTime.delegate = self;
    self.tfStartTime.delegate = self;
    self.tfRegion.delegate = self;
}

-(STPickerArea *)pickerArea
{
    if (!_pickerArea) {
        _pickerArea = [[STPickerArea alloc]init];
        _pickerArea.delegate = self;
    }
    return _pickerArea;
}

-(STPickerDate *)pickerDateStart
{
    if (!_pickerDateStart) {
        _pickerDateStart = [[STPickerDate alloc]init];
        _pickerDateStart.delegate = self;
        _pickerDateStart.yearLeast = 1970;
        _pickerDateStart.yearSum = 200;
    }
    return _pickerDateStart;
}

-(STPickerDate *)pickerDateEnd
{
    if (!_pickerDateEnd) {
        _pickerDateEnd = [[STPickerDate alloc]init];
        _pickerDateEnd.delegate = self;
        _pickerDateEnd.yearLeast = 1970;
        _pickerDateEnd.yearSum = 200;
    }
    return _pickerDateEnd;
}













#pragma mark - *** UITextFieldDelegate ****
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.tfRegion) {
        [self.pickerArea show];
        return NO;
    }else if (textField == self.tfStartTime){
        [self.pickerDateStart show];
        return NO;
    }else if (textField == self.tfEndTime){
        [self.pickerDateEnd show];
        return NO;
    }
    return YES;
}

#pragma mark - *** STPickerDateDelegate ***
-(void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,(long)month,(long)day];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:dateStr];
    NSTimeInterval timeInterval = [date timeIntervalSince1970]+28800;
    NSString *timeStamp = [NSString stringWithFormat:@"%.0f",timeInterval];
    
//    NSDate *testDate = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    
    if (pickerDate == self.pickerDateStart) {
        self.tfStartTime.text = dateStr;
        self.timeStart = timeStamp;
    }else if (pickerDate == self.pickerDateEnd){
        self.tfEndTime.text = dateStr;
        self.timeEnd = timeStamp;
    }
}

#pragma mark - **** STPickerAreaDelegate ***
-(void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area provinceID:(NSString *)provinceID cityID:(NSString *)cityID areaID:(NSString *)areaID
{
    
}



@end
