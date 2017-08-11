//
//  STPickerArea.m
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/15.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import "STPickerArea.h"

@interface STPickerArea()<UIPickerViewDataSource, UIPickerViewDelegate>

/** 1.数据源数组 */
@property (nonatomic, strong, nullable)NSArray *arrayRoot;
/** 2.当前省数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayProvince;
/** 3.当前城市数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayCity;
/** 4.当前地区数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayArea;
/** 5.当前选中数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arraySelected;

/** 6.省份 */
@property (nonatomic, strong, nullable)NSString *province;
/** 7.城市 */
@property (nonatomic, strong, nullable)NSString *city;
/** 8.地区 */
@property (nonatomic, strong, nullable)NSString *area;

@property (nonatomic, strong)NSMutableArray *arrayProvinceID;
@property (nonatomic, strong)NSMutableArray *arrayCityID;
@property (nonatomic, strong)NSMutableArray *arrayAreaID;


@property (nonatomic, strong)NSString *provinceID;
@property (nonatomic, strong)NSString *cityID;
@property (nonatomic, strong)NSString *areaID;

@end

@implementation STPickerArea



#pragma mark - --- init 视图初始化 ---

- (void)setupUI
{
    // 1.获取数据
    [self.arrayRoot enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.arrayProvince addObject:obj[@"state"]];
        [self.arrayProvince addObject:obj[@"name"]];
        [self.arrayProvinceID addObject:obj[@"id"]];
    }];

//    NSMutableArray *citys = [NSMutableArray arrayWithArray:[self.arrayRoot firstObject][@"cities"]];
    NSMutableArray *citys = [NSMutableArray arrayWithArray:[self.arrayRoot firstObject][@"children"]];
    
    [citys enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.arrayCity addObject:obj[@"city"]];
        [self.arrayCity addObject:obj[@"name"]];
        [self.arrayCityID addObject:obj[@"id"]];
    }];

//    self.arrayArea = [citys firstObject][@"area"];
    self.arrayArea = [citys firstObject][@"children"];
    [self.arrayArea enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayAreaID addObject:obj[@"id"]];
    }];

    self.province = self.arrayProvince[0];
    self.provinceID = self.arrayProvinceID[0];
    
    self.city = self.arrayCity[0];
    self.cityID = self.arrayCityID[0];
    
    if (self.arrayArea.count != 0) {
        self.area = self.arrayArea[0][@"name"];
        self.areaID = self.arrayAreaID[0];
    }else{
        self.area = @"";
        self.areaID = @"";
    }
    self.saveHistory = NO;
    
    // 2.设置视图的默认属性
    _heightPickerComponent = 32;
    [self setTitle:@"请选择城市地区"];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];

}
#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.arrayProvince.count;
    }else if (component == 1) {
        return self.arrayCity.count;
    }else{
        return self.arrayArea.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.arraySelected = self.arrayRoot[row][@"children"];

        [self.arrayCity removeAllObjects];
        [self.arrayCityID removeAllObjects];
        [self.arraySelected enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayCity addObject:obj[@"name"]];
            [self.arrayCityID addObject:obj[@"id"]];
        }];

        self.arrayArea = [NSMutableArray arrayWithArray:[self.arraySelected firstObject][@"children"]];
        [self.arrayAreaID removeAllObjects];
        [self.arrayArea enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayAreaID addObject:obj[@"id"]];
        }];

        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];

    }else if (component == 1) {
        if (self.arraySelected.count == 0) {
            self.arraySelected = [self.arrayRoot firstObject][@"children"];
        }
        
        self.arrayArea = [NSMutableArray arrayWithArray:[self.arraySelected objectAtIndex:row][@"children"]];
        [self.arrayAreaID removeAllObjects];
        [self.arrayArea enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayAreaID addObject:obj[@"id"]];
        }];

        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];

    }else{
//        self.areaID = self.arrayArea[row][@"id"];
    }

    [self reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{

    //设置分割线的颜色
    [pickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.size.height <=1) {
            obj.backgroundColor = self.borderButtonColor;
        }
    }];
    
    NSString *text;
    if (component == 0) {
        text =  self.arrayProvince[row];
        self.provinceID = self.arrayProvinceID[row];
    }else if (component == 1){
        text =  self.arrayCity[row];
        self.cityID = self.arrayCityID[row];
//        NSLog(@"%@:%@\n",text,self.cityID);
    }else{
        
        if (self.arrayArea.count > 0) {
            text = self.arrayArea[row][@"name"];
            self.areaID = self.arrayAreaID[row];
        }else{
            text =  @"";
            self.areaID = @"";
        }
    }
    
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setText:text];
    return label;
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    
    if (self.isSaveHistory) {
        NSDictionary *dicHistory = @{@"province":self.province, @"city":self.city, @"area":self.area};
        [[NSUserDefaults standardUserDefaults] setObject:dicHistory forKey:@"STPickerArea"];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"STPickerArea"];
    }
    
    if ([self.delegate respondsToSelector:@selector(pickerArea:province:city:area:provinceID:cityID:areaID:)]) {
        [self.delegate pickerArea:self province:self.province city:self.city area:self.area provinceID:self.provinceID cityID:self.cityID areaID:self.areaID];
    }
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    NSInteger index0 = [self.pickerView selectedRowInComponent:0];
    NSInteger index1 = [self.pickerView selectedRowInComponent:1];
    NSInteger index2 = [self.pickerView selectedRowInComponent:2];
    self.province = self.arrayProvince[index0];
    self.provinceID = self.arrayProvinceID[index0];
    
    self.city = self.arrayCity[index1];
    self.cityID = self.arrayCityID[index1];
    
    if (self.arrayArea.count != 0) {
        self.area = self.arrayArea[index2][@"name"];
        self.areaID = self.arrayAreaID[index2];
    }else{
        self.area = @"";
        self.areaID = @"";
    }
    
    NSString *title = [NSString stringWithFormat:@"%@ %@ %@", self.province, self.city, self.area];
    [self setTitle:title];

}

#pragma mark - --- setters 属性 ---

- (void)setSaveHistory:(BOOL)saveHistory{
    _saveHistory = saveHistory;
    
    if (saveHistory) {
        NSDictionary *dicHistory = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"STPickerArea"];
        __block NSUInteger numberProvince = 0;
        __block NSUInteger numberCity = 0;
        __block NSUInteger numberArea = 0;
        
        if (dicHistory) {
            NSString *province = [NSString stringWithFormat:@"%@", dicHistory[@"province"]];
            NSString *city = [NSString stringWithFormat:@"%@", dicHistory[@"city"]];
            NSString *area = [NSString stringWithFormat:@"%@", dicHistory[@"area"]];
            
            [self.arrayProvince enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:province]) {
                    numberProvince = idx;
                }
            }];
            
            self.arraySelected = self.arrayRoot[numberProvince][@"children"];
            
            [self.arrayCity removeAllObjects];
            [self.arraySelected enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.arrayCity addObject:obj[@"name"]];
            }];
            
            [self.arrayCity enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:city]) {
                    numberCity = idx;
                }
            }];
            
            
            if (self.arraySelected.count == 0) {
                self.arraySelected = [self.arrayRoot firstObject][@"children"];
            }
            
            self.arrayArea = [NSMutableArray arrayWithArray:[self.arraySelected objectAtIndex:numberCity][@"children"]];
            
            [self.arrayArea enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:area]) {
                    numberArea = idx;
                }
            }];
            
            [self.pickerView selectRow:numberProvince inComponent:0 animated:NO];
            [self.pickerView selectRow:numberCity inComponent:1 animated:NO];
            [self.pickerView selectRow:numberArea inComponent:2 animated:NO];
            [self.pickerView reloadAllComponents];
            [self reloadData];
        }
    }
}

#pragma mark - --- getters 属性 ---

- (NSArray *)arrayRoot
{
    if (!_arrayRoot) {
        NSString *path = [[NSBundle bundleForClass:[STPickerView class]] pathForResource:@"RegionList" ofType:@"plist"];
        _arrayRoot = [[NSArray alloc]initWithContentsOfFile:path];
    }
    return _arrayRoot;
}

- (NSMutableArray *)arrayProvince
{
    if (!_arrayProvince) {
        _arrayProvince = @[].mutableCopy;
    }
    return _arrayProvince;
}

- (NSMutableArray *)arrayCity
{
    if (!_arrayCity) {
        _arrayCity = @[].mutableCopy;
    }
    return _arrayCity;
}

- (NSMutableArray *)arrayArea
{
    if (!_arrayArea) {
        _arrayArea = @[].mutableCopy;
    }
    return _arrayArea;
}

- (NSMutableArray *)arraySelected
{
    if (!_arraySelected) {
        _arraySelected = @[].mutableCopy;
    }
    return _arraySelected;
}

-(NSMutableArray *)arrayProvinceID
{
    if (!_arrayProvinceID) {
        _arrayProvinceID = @[].mutableCopy;
    }
    return _arrayProvinceID;
}

-(NSMutableArray *)arrayCityID
{
    if (!_arrayCityID) {
        _arrayCityID = @[].mutableCopy;
    }
    return _arrayCityID;
}

-(NSMutableArray *)arrayAreaID
{
    if (!_arrayAreaID) {
        _arrayAreaID = @[].mutableCopy;
    }
    return _arrayAreaID;
}

@end


