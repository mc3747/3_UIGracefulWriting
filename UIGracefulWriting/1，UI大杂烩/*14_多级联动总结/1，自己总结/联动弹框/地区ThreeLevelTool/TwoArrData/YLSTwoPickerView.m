//
//  YLSOTPickerView.m
//  YLSPicker
//
//  Created by yulingsong on 16/9/1.
//  Copyright © 2016年 yulingsong. All rights reserved.
//

#define YLSRect(x, y, w, h)  CGRectMake([UIScreen mainScreen].bounds.size.width * x, [UIScreen mainScreen].bounds.size.height * y, [UIScreen mainScreen].bounds.size.width * w,  [UIScreen mainScreen].bounds.size.height * h)
#define YLSFont(f) [UIFont systemFontOfSize:[UIScreen mainScreen].bounds.size.width * f]
#define YLSColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define YLSMainBackColor [UIColor colorWithRed:240/255.0 green:239/255.0 blue:245/255.0 alpha:1]
#define BlueColor [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1]
#define ClearColor [UIColor clearColor]

#import "YLSTwoPickerView.h"

@interface YLSTwoPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
/** view */
@property (nonatomic,strong) UIView *topView;
/** button */
@property (nonatomic,strong) UIButton *doneBtn;
/** button */
@property (nonatomic,strong) UIButton *ranBtn;
/** pickerView */
@property (nonatomic,strong) UIPickerView *pickerView;

/** array */
@property (nonatomic,strong) NSMutableArray *oneArr;
/** array */
@property (nonatomic,strong) NSMutableArray *twoArr;

/** string */
@property (nonatomic,strong) NSString *result1;
/** string */
@property (nonatomic,strong) NSString *result2;
//背景view
@property (nonatomic, strong) UIView *bgView;
@end

@implementation YLSTwoPickerView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:YLSRect(0, 0, 1, 917/667)];
    
    if (self)
    {
        self.backgroundColor = YLSColorAlpha(0, 0, 0, 0.4);
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.topView = [[UIView alloc]initWithFrame:YLSRect(0, 667/667, 1, 250/667)];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topView];
    
    //为view上面的两个角做成圆角。不喜欢的可以注掉
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.topView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.topView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.topView.layer.mask = maskLayer;
    
    self.doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.doneBtn setTitle:@"确认" forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.doneBtn setFrame:YLSRect(320/375, 5/667, 50/375, 40/667)];
    [self.doneBtn addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.doneBtn];
    
    self.ranBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ranBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.ranBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.ranBtn setFrame:YLSRect(5/375, 5/667, 100/375, 40/667)];
    [self.ranBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.ranBtn];
    
    UILabel *titlelb = [[UILabel alloc]initWithFrame:YLSRect(100/375, 0, 175/375, 50/667)];
    titlelb.backgroundColor = ClearColor;
    titlelb.textAlignment = NSTextAlignmentCenter;
    titlelb.text = self.title;
    titlelb.font = YLSFont(20/375);
    [self.topView addSubview:titlelb];
    
    self.pickerView = [[UIPickerView alloc]init];
    [self.pickerView setFrame:YLSRect(0, 50/667, 1, 200/667)];
    [self.pickerView setBackgroundColor:YLSMainBackColor];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    [self.topView addSubview:self.pickerView];
    
}

//快速创建
+(instancetype)pickerView
{
    return [[self alloc]init];
}

//弹出
- (void)show
{
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

//添加弹出移除的动画效果
- (void)showInView:(UIView *)view
{
     self.bgView.hidden = NO;
    // 浮现
    GJWeakSelf;
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint point = weakSelf.center;
        point.y -= 250;
        weakSelf.center = point;
    } completion:^(BOOL finished) {
        
    }];
    [view addSubview:self];
}

#pragma mark -  选择完成
-(void)quit
{
     self.bgView.hidden = YES;
    GJWeakSelf;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0;
        CGPoint point = weakSelf.center;
        point.y += 250;
        weakSelf.center = point;
    } completion:^(BOOL finished) {
        if (!weakSelf.result1)
        {
            weakSelf.result1 = weakSelf.oneArr[0];
        }
        if (!weakSelf.result2)
        {
            weakSelf.result2 = weakSelf.twoArr[0];
        }
        NSInteger row1 = [weakSelf.pickerView selectedRowInComponent:0];
        NSInteger row2 = [weakSelf.pickerView selectedRowInComponent:1];
        NSString *selected1 = [weakSelf.oneArr objectAtIndex:row1];
        NSString *selected2 = [weakSelf.twoArr objectAtIndex:row2];
        NSString *result = [[NSString alloc] initWithFormat:@"%@,%@",selected1,selected2];
        if(weakSelf.pickBlock){
            weakSelf.pickBlock(result);
        }
        [weakSelf removeFromSuperview];
    }];
}
#pragma mark -  取消
-(void)dismiss:(UIPickerView *)picker
{
    self.bgView.hidden = YES;
    GJWeakSelf;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0;
        CGPoint point = weakSelf.center;
        point.y += 250;
        weakSelf.center = point;
    } completion:^(BOOL finished) {
      
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - 代理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.oneArr.count;
    }else
    {
        return self.twoArr.count;
    }
}

// 返回第component列第row行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [self.oneArr objectAtIndex:row];
    }else
    {
        return [self.twoArr objectAtIndex:row];
    }
}

// 选中第component第row的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        NSString *selectOne = self.oneArr[row];
        NSDictionary *selectDict = self.array[row];
        NSArray *array = [selectDict objectForKey:selectOne];
        self.twoArr = [[NSMutableArray alloc] initWithArray:array];
        self.result1 = self.oneArr[row];
        
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        
    }else
    {
        self.result2 = self.twoArr[row];
    }
}


//懒加载
-(NSMutableArray *)oneArr
{
    if (!_oneArr)
    {
        _oneArr = [[NSMutableArray alloc] init];
        for (int i = 0; i<self.array.count; i++) {
            NSDictionary *dic = self.array[i];
            [_oneArr addObject:dic.allKeys[0]];
        };
    }
    return _oneArr;
}

-(NSMutableArray *)twoArr
{
    if (!_twoArr)
    {
         _twoArr = [[NSMutableArray alloc] init];
        NSDictionary *dic = self.array[0];
        _twoArr = [[NSMutableArray alloc] initWithArray:dic.allValues[0]];
    }
    return _twoArr;
}
#pragma mark -  背景view
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        _bgView.frame = window.bounds;
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.6;
        //给背景添加一个手势，后续方便移除视图
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss:)];
        [_bgView addGestureRecognizer:tap];
        [self addSubview:_bgView];
    }
    
    return _bgView;
}
@end
