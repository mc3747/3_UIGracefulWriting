//
//  ViewController.m
//  UIGracefulWriting
//
//  Created by gjfax on 2018/6/13.
//  Copyright © 2018年 macheng. All rights reserved.
//

#import "ViewController.h"
#import "CommonViewController.h"

#import "BannerDemoVC.h"
#import "SDViewController.h"

#import "LeftViewController.h"
#import "RightViewController.h"
#import "SWRevealViewController.h"
#import "Demo1ViewController.h"
#import "CommonUnderlineButton.h"
#import "TextViewViewController.h"

#import "TabView_1_ViewController.h"
#import "TabView_2_ViewController.h"
#import "TabView_3_ViewController.h"
#import "TabView_4_ViewController.h"
#import "TabView_5_ViewController.h"
#import "TabView_6_ViewController.h"

#import "Common_ViewController.h"
#import "SGEventVC.h"
#import "SGCountdownVC.h"
#import "SGImagePositionVC.h"



@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UIButton *btn7;
@property (weak, nonatomic) IBOutlet UIButton *btn8;
@property (weak, nonatomic) IBOutlet UIButton *btn9;
@property (weak, nonatomic) IBOutlet UIButton *btn10;
@property (weak, nonatomic) IBOutlet UIButton *btn11;
@property (weak, nonatomic) IBOutlet UIButton *btn12;
@property (weak, nonatomic) IBOutlet UIButton *btn13;
@property (weak, nonatomic) IBOutlet UIButton *btn14;
@property (weak, nonatomic) IBOutlet UIButton *btn15;
@property (weak, nonatomic) IBOutlet UIButton *btn16;
@property (weak, nonatomic) IBOutlet UIButton *btn17;
@property (weak, nonatomic) IBOutlet UIButton *btn18;
@property (weak, nonatomic) IBOutlet UIButton *btn19;
@property (weak, nonatomic) IBOutlet UIButton *btn20;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    NSArray *buttonArray = @[_btn1,_btn2,_btn3,_btn4,_btn5,_btn6,_btn7,_btn8,_btn9,_btn10,_btn11,_btn12,_btn13,_btn14,_btn15,_btn16,_btn17,_btn18,_btn19,_btn20];
    [buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = (UIButton*)obj;
        NSString *selName = [NSString stringWithFormat:@"test%li",idx + 1];
        SEL sel = NSSelectorFromString(selName);
        [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    }];
}


#pragma mark -   普通滚动图片
- (void)test1 {
   
}

#pragma mark -  循环滚动
- (void)test2 {
    SDViewController *vc = [[SDViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -  复杂滚动
- (void)test3 {
    BannerDemoVC *vc = [[BannerDemoVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -  collectionView
- (void)test4 {
    
    //左侧菜单栏
    LeftViewController *leftViewController = [[LeftViewController alloc] init];
    
    //首页
    Demo1ViewController *centerView1Controller = [[Demo1ViewController alloc] init];
    
    //右侧菜单栏
    RightViewController *rightViewController = [[RightViewController alloc] init];
    
    SWRevealViewController *revealViewController = [[SWRevealViewController alloc] initWithRearViewController:leftViewController frontViewController:centerView1Controller];
    revealViewController.rightViewController = rightViewController;
    
    //浮动层离左边距的宽度
    revealViewController.rearViewRevealWidth = 230;
    //    revealViewController.rightViewRevealWidth = 230;
    
    //是否让浮动层弹回原位
    //mainRevealController.bounceBackOnOverdraw = NO;
    [revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    
    [self.navigationController pushViewController:revealViewController animated:YES];
}
#pragma mark -  5,label可以点击和带下划线
- (void)test5 {

    
}

#pragma mark -  6，textfield相关见storyboard
//直接在stroyboard中跳转展示

#pragma mark -  7，button相关
- (void)test6 {
    
    CommonUnderlineButton *btn = [[CommonUnderlineButton alloc]
                                                initWithButtonFrame: CGRectMake(10, 100, 200, 50)
                                                    textNormalColor:[UIColor yellowColor]
                                  textHighlightColor:[UIColor blueColor]
                                  lineNormalColor:[UIColor yellowColor]
                                  lineHighlightColor:[UIColor redColor]
                                  underDistance:5.f clickBlock:^(CommonUnderlineButton *button) {
        NSLog(@"点击了");
    }];
    
    [btn setTitle:@"带下划线的button" forState:UIControlStateNormal];
    
    [self pushVCWithView:btn];
}
#pragma mark -  8，文字图片组合按钮
- (void)test7 {
    SGImagePositionVC *vc = [[SGImagePositionVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -  9,重复点击时间按钮
- (void)test8 {
    SGEventVC *vc = [[SGEventVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -  10,倒计时按钮
- (void)test9 {
    SGCountdownVC *vc = [[SGCountdownVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -  11,textView相关
- (void)test10 {
    TextViewViewController *vc = [[TextViewViewController alloc] init];
     vc.title = @"textView相关";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -  12,tableView常用设置
- (void)test11 {
    TabView_1_ViewController *vc = [[TabView_1_ViewController alloc] init];
     vc.title = @"tableView常用设置";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -  13,tableView自定义等高
- (void)test12 {
    TabView_2_ViewController *vc = [[TabView_2_ViewController alloc] init];
     vc.title = @"tableView自定义等高";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -  14,tableView自定义不等高
- (void)test13 {
    TabView_3_ViewController *vc = [[TabView_3_ViewController alloc] init];
     vc.title = @"tableView自定义不等高";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -  15,tableView优雅地写
- (void)test14 {
    TabView_4_ViewController *vc = [[TabView_4_ViewController alloc] init];
    vc.title = @"tableView优雅地写";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -  16,炫酷效果
- (void)test15 {
    TabView_5_ViewController *vc = [[TabView_5_ViewController alloc] init];
     vc.title = @"tableView炫酷效果";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -  17,性能优化
- (void)test16 {
    TabView_6_ViewController *vc = [[TabView_6_ViewController alloc] init];
     vc.title = @"tableView性能优化";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -  18,备用
- (void)test17 {
   
}
#pragma mark -  19,备用
- (void)test18 {
  
}

#pragma mark -  20,备用
- (void)test19 {
    
}
#pragma mark -  21,其他
- (void)test20 {
    Common_ViewController *vc = [[Common_ViewController alloc] init];
    
    vc.title = @"其他UI效果";
    
    vc.vcNameArray =
@[
@[@"CQJigsawViewController"],
@[@"ClickableLabelVC",@"LabelLeaveSpaceVC",@"CountDownLabelVC",@"LabelAlignVC",@"AdjustSizeVC",@"MoneyAnimationVC"],
@[@"EnlargeButtonVC",@"SGImagePositionVC",@"UnderlineButtonVC",@"SGEventVC",@"SGCountdownVC",@"JMButtonVC"],
@[@"TabView_1_ViewController",@"TabView_2_ViewController",@"TabView_3_ViewController",@"TabView_4_ViewController",@"TabView_5_ViewController",@"TabView_6_ViewController",@"NoDataTableViewVC",@"MemoTableViewController"],
@[@"ScrollPageVC"],
@[@"SWRevealViewController"],
@[@"InputFloatVC",@"InputFilterVC"],
@[@"ShadeEffectVC",@"CQFilterViewController",@"DimImageViewController",@"IconFontViewController",@"ScreenShotVC",@"RichTextVC",@"MemoTableViewController",@"DemosViewController",@"WonderfulColorVC",@"JMButtonVC"],
    @[@"DropDownViewController",@"YZDropViewController"],
    @[@"AlertViewController",@"AlertTableViewController",@"ActionSheetTableViewController",@"ShowViewController"],
    @[@"FatherAndSonVC",@"Switch2_ViewController",@"Switch3_ViewController",@"Switch4_ViewController",@"STListController"],
    @[@"TestViewController",@"NoDataTableViewVC",@"NineGridVC",@"InputFilterVC",@"CreateQRCodeVC"]];
    
    vc.subtitleArray = @[
@[@"比例拼图"],
@[@"可点击label",@"label留白",@"倒计时label",@"label文字对齐各种效果",@"自适应宽高的label",@"金额跳动label"],
@[@"扩大点击button",@"文字图片组合button",@"带下划线button",@"防重复点击button",@"倒计时button",@"各种样式的button"],
@[@"原生常用",@"自定义等高",@"自定义不等高",@"优雅地写",@"炫酷效果",@"性能优化",@"无数据动画",@"便签效果"],
@[@"ScrollView相关"],
@[@"CollectionView相关"],
@[@"输入上浮",@"输入过滤"],
@[@"渐变效果",@"模态弹窗",@"模糊效果",@"IconFont的使用",@"截屏展示",@"富文本总结",@"便签效果",@"IGListKit的Demo",@"完美颜色",@"各种button的封装"],
                         @[@"仿美团二级菜单",@"袁崢二级菜单"],
  @[@"系统alert和sheet",@"LEE的alert",@"LEE的sheet",@"JXT的Alert汇总"],
  @[@"父子控制器",@"袁崢切换",@"SGPagingView横向切换",@"JXCategory横向切换",@"ST顶部可滚动切换"],
  @[@"测试控制器跳转过渡页",@"tableView无数据过渡页动画",@"九宫格",@"输入过滤",@"生成二维码"]];
    
    vc.sectionTitleArray =@[@"view相关",@"lable相关",@"button相关",@"tableView相关",@"scrollView相关",
                            @"collectionView相关",@"textField相关",@"textView相关",@"颜色总结",@"字体总结",
                            @"弹框总结",@"富文本总结",@"九宫格总结",@"多级联动总结",@"导航切换总结"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -  push出通用控制器
- (void)pushVCWithView:(UIView *)view {
    CommonViewController *vc = [[CommonViewController alloc] init];
    [vc.view addSubview:view];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
