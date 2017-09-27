//
//  SegmentTapView.m
//  SegmentTapView

#import "SegmentTapView.h"

#import "UIButton+Badge.h"


@interface SegmentTapView ()
@property (nonatomic, strong)NSMutableArray *buttonsArray;
@property (nonatomic, strong)UIImageView *lineImageView;
@end
@implementation SegmentTapView

-(instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)dataArray withFont:(CGFloat)font {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        _buttonsArray = [[NSMutableArray alloc] init];
        _dataArray = dataArray;
        _titleFont = font;
        
        //默认
        self.textNomalColor    = [UIColor blackColor];
        self.textSelectedColor = kColorFromRGB(kThemeYellow);
        self.lineColor = kColorFromRGB(kThemeYellow);
        
        [self addSubSegmentView];
    }
    return self;
}

-(void)addSubSegmentView
{
//    float count = (float)_dataArray.count;
    float width = self.frame.size.width / _dataArray.count;
    
    for (int i = 0 ; i < _dataArray.count ; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * width, 0, width, self.frame.size.height)];
        button.tag = i+1;
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:[_dataArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:self.textNomalColor    forState:UIControlStateNormal];
        [button setTitleColor:self.textSelectedColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:_titleFont];
        
        [button addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        //默认第一个选中
        if (i == 0) {
            button.selected = YES;
        }
        else{
            button.selected = NO;
        }
        
        [self.buttonsArray addObject:button];
        [self addSubview:button];
        
//        if (i != _dataArray.count || i != 0) {
//            UILabel *line = [[UILabel alloc ] initWithFrame:CGRectMake(i * width , 0, 0.45, 40)];
//            line.backgroundColor = [UIColor whiteColor];
//            [self bringSubviewToFront:line];
//            [self addSubview:line];
//        }
//        self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*width+width/3.0, self.frame.size.height-2, width/3.0, 2)];
//        self.lineImageView.backgroundColor = _lineColor;
//        [self addSubview:self.lineImageView];

    }
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width/3.0, self.frame.size.height-2, width/3.0, 2)];
    self.lineImageView.backgroundColor = _lineColor;
    [self addSubview:self.lineImageView];
}

-(void)tapAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    [UIView animateWithDuration:0.2 animations:^{
       self.lineImageView.frame = CGRectMake(button.frame.origin.x + button.frame.size.width/3.0, self.frame.size.height-2, button.frame.size.width/3.0, 2);
    }];
    for (UIButton *subButton in self.buttonsArray) {
        if (button == subButton) {
            subButton.selected = YES;
        }
        else{
            subButton.selected = NO;
        }
    }
    if ([self.delegate respondsToSelector:@selector(selectedIndex:)]) {
        [self.delegate selectedIndex:button.tag -1];
    }
}
-(void)selectIndex:(NSInteger)index
{
    for (UIButton *subButton in self.buttonsArray) {
        if (index != subButton.tag) {
            subButton.selected = NO;
        }
        else{
            subButton.selected = YES;
            [UIView animateWithDuration:0.2 animations:^{
                self.lineImageView.frame = CGRectMake(subButton.frame.origin.x + subButton.frame.size.width/3.0, self.frame.size.height-2, subButton.frame.size.width/3.0, 2);
            }];
        }
    }
}
#pragma mark -- set
-(void)setLineColor:(UIColor *)lineColor{
    if (_lineColor != lineColor) {
        self.lineImageView.backgroundColor = lineColor;
        _lineColor = lineColor;
    }
}
-(void)setTextNomalColor:(UIColor *)textNomalColor{
    if (_textNomalColor != textNomalColor) {
        for (UIButton *subButton in self.buttonsArray){
            [subButton setTitleColor:textNomalColor forState:UIControlStateNormal];
        }
        _textNomalColor = textNomalColor;
    }
}
-(void)setTextSelectedColor:(UIColor *)textSelectedColor{
    if (_textSelectedColor != textSelectedColor) {
        for (UIButton *subButton in self.buttonsArray){
            [subButton setTitleColor:textSelectedColor forState:UIControlStateSelected];
        }
        _textSelectedColor = textSelectedColor;
    }
}
-(void)setTitleFont:(CGFloat)titleFont{
    if (_titleFont != titleFont) {
        for (UIButton *subButton in self.buttonsArray){
            subButton.titleLabel.font = [UIFont systemFontOfSize:titleFont] ;
        }
        _titleFont = titleFont;
    }
}




#pragma mark - <添加未读消息数量>
-(void)addUnreadCountWithCount:(NSString *)count index:(NSInteger)index
{
    UIButton *button = self.buttonsArray[index];
    CGFloat position = (CGFloat)kSCREEN_WIDTH/self.buttonsArray.count;
    //写在第一句才起作用
    button.shouldHideBadgeAtZero = YES;
//    button.badgeValue = @"";
    button.badgeValue = count;
    button.badgeFont = [UIFont systemFontOfSize:7];
//    button.badgeMinSize = 1;
    button.badgeOriginX = position-30;
    button.badgeOriginY = 3;
}



@end
