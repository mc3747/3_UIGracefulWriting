//
//  ClickableLabel.m
//  UIGracefulWriting
//
//  Created by gjfax on 2018/7/23.
//  Copyright © 2018年 macheng. All rights reserved.
//

#import "ClickableLabel.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>

#define IPhone5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < __DBL_EPSILON__)

@implementation YBAttributeModel

@end

@interface ClickableLabel()

//是否有点击效果（默认有）
@property (nonatomic, assign) BOOL enabledTapEffect;

//选中文字颜色
@property (nonatomic, strong) UIColor *normalTextColor;

//选中文字颜色
@property (nonatomic, strong) UIColor *clickTextColor;

//选中背景颜色
@property (nonatomic, strong) UIColor *clickBackgroundColor;

//点击的范围
@property (nonatomic, assign) NSRange updateLineRange;

//点击的下划线颜色
@property (nonatomic, strong) UIColor *updateLineColor;

//下划线位置数组
@property (nonatomic, strong) NSMutableArray <NSValue *>*rangeArray;

//是否是点击
@property (nonatomic, assign) BOOL isClick;

@end

@implementation ClickableLabel

#pragma mark - AssociatedObjects
//被传入文字在字符串中的位置数组
- (NSMutableArray *)attributeStrings
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAttributeStrings:(NSMutableArray *)attributeStrings
{
    objc_setAssociatedObject(self, @selector(attributeStrings), attributeStrings, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)effectDic
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEffectDic:(NSMutableDictionary *)effectDic
{
    objc_setAssociatedObject(self, @selector(effectDic), effectDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isTapAction
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsTapAction:(BOOL)isTapAction
{
    objc_setAssociatedObject(self, @selector(isTapAction), @(isTapAction), OBJC_ASSOCIATION_ASSIGN);
}

- (void (^)(NSString *, NSRange, NSInteger))tapBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTapBlock:(void (^)(NSString *, NSRange, NSInteger))tapBlock
{
    objc_setAssociatedObject(self, @selector(tapBlock), tapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BOOL)enabledTapEffect
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setEnabledTapEffect:(BOOL)enabledTapEffect
{
    objc_setAssociatedObject(self, @selector(enabledTapEffect), @(enabledTapEffect), OBJC_ASSOCIATION_ASSIGN);
    self.isTapEffect = enabledTapEffect;
}

- (BOOL)isTapEffect
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsTapEffect:(BOOL)isTapEffect
{
    objc_setAssociatedObject(self, @selector(isTapEffect), @(isTapEffect), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark -  显示
- (void)gjs_addAttributeString:(NSString *)totalString
                     totalFont:(NSNumber *)totalFont
                    totalColor:(UIColor *)totalColor
                elementStrings:(NSArray <NSString *> *)elementStrings
                  elementFonts:(NSArray <NSNumber *> *)elementFonts
                 elementColors:(NSArray <UIColor *> *)elementColors
        elementUnderLineColors:(NSArray <UIColor *> *)elementUnderLineColors {
    
    _normalTextColor = totalColor;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:totalString];
    UIFont *font = [UIFont systemFontOfSize:[totalFont floatValue]];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, totalString.length)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:totalColor range:NSMakeRange(0, totalString.length)];
    
    for (int i = 0; i<elementStrings.count; i++) {
        
        NSRange range = [attributedString.string rangeOfString:elementStrings[i]];
        //字体
        UIFont *font = [UIFont systemFontOfSize:[elementFonts[i] floatValue]];
        [attributedString addAttribute:NSFontAttributeName value:font range:range];
        //颜色
        [attributedString addAttribute:NSForegroundColorAttributeName value:elementColors[i] range:range];

//        if (IPhone5) {
//                    [attributedString addAttribute:NSUnderlineStyleAttributeName value: @(NSUnderlineStyleSingle) range:range];
//            
//                    [attributedString addAttribute:NSUnderlineColorAttributeName value:elementUnderLineColors[i] range:range];
//        };
        NSValue *rangValue = [NSValue valueWithRange:range];
        [self.rangeArray addObject:rangValue];
        
    };
    self.attributedText = attributedString;
    
}
#pragma mark -  点击
- (void)gjs_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                            enabledTapEffect:(BOOL)enabledTapEffect
                              clickTextColor:(UIColor *)clickTextColor
                        clickBackgroundColor:(UIColor *)clickBackgroundColor
                                  tapClicked:(ClickBlock)tapClick {
    
    [self setEnabledTapEffect:enabledTapEffect];
    _clickTextColor = clickTextColor;
    _clickBackgroundColor = clickBackgroundColor;
    [self yb_getRangesWithStrings:strings];
    
    if (self.tapBlock != tapClick) {
        self.tapBlock = tapClick;
    }
}

#pragma mark - touchAction：触发事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isTapAction) {
        return;
    }
    
    if (objc_getAssociatedObject(self, @selector(enabledTapEffect))) {
        self.isTapEffect = self.enabledTapEffect;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak typeof(self) weakSelf = self;
    
    [self yb_getTapFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
        
        if (weakSelf.tapBlock) {
            weakSelf.tapBlock (string , range , index);
        }
        
        if (self.isTapEffect) {
            [self yb_saveEffectDicWithRange:range];
            [self yb_tapEffectWithStatus:YES];
        }
        
    }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (self.isTapAction) {
        if ([self yb_getTapFrameWithTouchPoint:point result:nil]) {
            return self;
        }
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark - getTapFrame：获取点击的位置
- (BOOL)yb_getTapFrameWithTouchPoint:(CGPoint)point result:(void (^) (NSString *string , NSRange range , NSInteger index))resultBlock
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    CGMutablePathRef Path = CGPathCreateMutable();
    CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    CFRange range = CTFrameGetVisibleStringRange(frame);
    if (self.attributedText.length > range.length) {
        UIFont *font ;
        if ([self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil]) {
            font = [self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
        }else if (self.font){
            font = self.font;
        }else {
            font = [UIFont systemFontOfSize:17];
        }
        CGPathRelease(Path);
        Path = CGPathCreateMutable();
        CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + font.lineHeight));
        frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    }
    CFArrayRef lines = CTFrameGetLines(frame);
    if (!lines) {
        CFRelease(frame);
        CFRelease(framesetter);
        CGPathRelease(Path);
        return NO;
    }
    CFIndex count = CFArrayGetCount(lines);
    CGPoint origins[count];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    CGAffineTransform transform = [self yb_transformForCoreText];
    CGFloat verticalOffset = 0;
    for (CFIndex i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGRect flippedRect = [self yb_getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        rect = CGRectInset(rect, 0, 0);
        rect = CGRectOffset(rect, 0, verticalOffset);
        NSParagraphStyle *style = [self.attributedText attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil];
        CGFloat lineSpace;
        if (style) {
            lineSpace = style.lineSpacing;
        }else {
            lineSpace = 0;
        }
        CGFloat lineOutSpace = (self.bounds.size.height - lineSpace * (count - 1) -rect.size.height * count) / 2;
        rect.origin.y = lineOutSpace + rect.size.height * i + lineSpace * i;
        if (CGRectContainsPoint(rect, point)) {
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            CGFloat offset;
            CTLineGetOffsetForStringIndex(line, index, &offset);
            if (offset > relativePoint.x) {
                index = index - 1;
            }
            NSInteger link_count = self.attributeStrings.count;
            for (int j = 0; j < link_count; j++) {
                YBAttributeModel *model = self.attributeStrings[j];
                NSRange link_range = model.range;
                if (NSLocationInRange(index, link_range)) {
                    if (resultBlock) {
                        resultBlock (model.str , model.range , (NSInteger)j);
                    }
                    CFRelease(frame);
                    CFRelease(framesetter);
                    CGPathRelease(Path);
                    return YES;
                }
            }
        }
    }
    CFRelease(frame);
    CFRelease(framesetter);
    CGPathRelease(Path);
    return NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isTapEffect) {
        [self performSelectorOnMainThread:@selector(yb_tapEffectWithStatus:) withObject:nil waitUntilDone:NO];
        [self yb_tapEffectWithStatus:NO];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isTapEffect) {
        
        [self performSelectorOnMainThread:@selector(yb_tapEffectWithStatus:) withObject:nil waitUntilDone:NO];
        [self yb_tapEffectWithStatus:NO];
    }
}

- (CGAffineTransform)yb_transformForCoreText
{
    return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
}

- (CGRect)yb_getLineBounds:(CTLineRef)line point:(CGPoint)point
{
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + fabs(descent) + leading;
    
    return CGRectMake(point.x, point.y , width, height);
}

#pragma mark - tapEffect
- (void)yb_tapEffectWithStatus:(BOOL)status
{
    if (self.isTapEffect) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        NSMutableAttributedString *subAtt = [[NSMutableAttributedString alloc] initWithAttributedString:[[self.effectDic allValues] firstObject]];
        NSRange range = NSRangeFromString([[self.effectDic allKeys] firstObject]);
        
        if (status) {
#pragma mark -  此处修改点击颜色等配置
            UIColor *textColor = _clickTextColor?_clickTextColor:[UIColor lightGrayColor];
            UIColor *backgroundColor = _clickBackgroundColor?_clickBackgroundColor:[UIColor lightGrayColor];
            [subAtt addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, subAtt.string.length)];
            
//            if (IPhone5) {
//                [subAtt addAttribute:NSUnderlineColorAttributeName value:textColor range:NSMakeRange(0, subAtt.string.length)];
//            };
            
            [subAtt addAttribute:NSBackgroundColorAttributeName value:backgroundColor range:NSMakeRange(0, subAtt.string.length)];
            _updateLineColor = _clickTextColor;
            _updateLineRange = range;
            [attStr replaceCharactersInRange:range withAttributedString:subAtt];
            
        }else {
            _updateLineColor = _normalTextColor;
            _updateLineRange = range;
            [attStr replaceCharactersInRange:range withAttributedString:subAtt];
        }
        self.attributedText = attStr;
    }
}

- (void)yb_saveEffectDicWithRange:(NSRange)range
{
    self.effectDic = [NSMutableDictionary dictionary];
    NSAttributedString *subAttribute = [self.attributedText attributedSubstringFromRange:range];
    [self.effectDic setObject:subAttribute forKey:NSStringFromRange(range)];
}

#pragma mark - getRange：获取传入文字的位置
- (void)yb_getRangesWithStrings:(NSArray <NSString *>  *)strings
{
    if (self.attributedText == nil) {
        self.isTapAction = NO;
        return;
    }
    self.isTapAction = YES;
    self.isTapEffect = YES;
    __block  NSString *totalStr = self.attributedText.string;
    self.attributeStrings = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    [strings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [totalStr rangeOfString:obj];
        if (range.length != 0) {
            totalStr = [totalStr stringByReplacingCharactersInRange:range withString:[weakSelf yb_getStringWithRange:range]];
            YBAttributeModel *model = [YBAttributeModel new];
            model.range = range;
            model.str = obj;
            [weakSelf.attributeStrings addObject:model];
        }
        
    }];
}

- (NSString *)yb_getStringWithRange:(NSRange)range
{
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < range.length ; i++) {
        [string appendString:@" "];
    }
    return string;
}
#pragma mark -  重置状态
- (void)resetState {
    [self yb_tapEffectWithStatus:NO];
}

#pragma mark -  绘制下划线
- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
//    if (!IPhone5) {
//        [self.rangeArray enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSValue *rangValue = (NSValue *)obj;
//            NSRange range = [rangValue rangeValue];
//            [self drawUnderlinePath:range isClick:NO];
//        }];
//        [self drawUnderlinePath:_updateLineRange isClick:YES];
//    };
}

#pragma mark -  绘制
- (void)drawUnderlinePath:(NSRange)range isClick:(BOOL)isClick{
    
    //  前面内容
    NSRange headRange = NSMakeRange(0, range.location);
    NSString *headString = [self.text substringWithRange:headRange];
    CGSize headSize = [self returnTextSize:headString font:self.font.pointSize];
    CGFloat selectedX = headSize.width;
    //  选中内容
    NSString *selectedString = [self.text substringWithRange:range];
    CGSize selectedSize = [self returnTextSize:selectedString font:self.font.pointSize];
    CGFloat selectedWidth = selectedSize.width;
    //  绘制
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextRef, isClick?_updateLineColor.CGColor:_normalTextColor.CGColor);
    CGContextMoveToPoint(contextRef,  selectedX, self.font.capHeight + self.font.ascender + self.font.descender);
    CGContextAddLineToPoint(contextRef, selectedX + selectedWidth,self.font.capHeight + self.font.ascender + self.font.descender);
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke);
}
#pragma mark -  返回宽高
- (CGSize)returnTextSize:(NSString *)string font:(CGFloat )font {
    UIFont *labelFont = [UIFont systemFontOfSize:font];
    CGSize fontSize =[string sizeWithAttributes:@{NSFontAttributeName:labelFont}];
    return fontSize;
}
#pragma mark -懒加载
- (NSMutableArray *)rangeArray
{
    if (!_rangeArray) {
        _rangeArray = [[NSMutableArray alloc] init];
    }
    
    return _rangeArray;
}
@end
