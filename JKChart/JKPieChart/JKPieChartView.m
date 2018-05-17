//
//  JKPieChartView.m
//  Test
//
//  Created by Jack on 2018/3/29.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "JKPieChartView.h"

static const float titleSize = 8.0f;

@implementation JKPieChartItem {
    @public
    UIBezierPath *_piePath;
    UIBezierPath *_linePath;
    CAShapeLayer *_pieLayer;
    CAShapeLayer *_lineLayer;
    UILabel *_titleLabel;
    CGPoint _center;
    CGFloat _radius;
    CGRect _titleRect;
    __weak JKPieChartItem *_preItem;
    __weak JKPieChartItem *_nextItem;
}

- (UIColor *)pieColor {
    if (!_pieColor) {
        float r = arc4random_uniform(255) / 255.0f;
        float g = arc4random_uniform(255) / 255.0f;
        float b = arc4random_uniform(255) / 255.0f;
        _pieColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    }
    return _pieColor;
}

- (void)setPercentage:(float)percentage {
    _percentage = percentage;
}

- (void)setStartAngle:(float)startAngle {
    _startAngle = startAngle;
}

- (void)setEndAngle:(float)endAngle {
    _endAngle = endAngle;
}

- (void)setSelect:(BOOL)select {
    _select = select;
    if (CGPointEqualToPoint(CGPointZero, _center) || _radius == 0) {
        return;
    }
    [self preparePieWithCenter:_center Radius:_radius];
}

- (void)preparePieWithCenter:(CGPoint)center Radius:(CGFloat)radius {
    _center = center;
    _radius = radius;
    
    if (self.select) {
        radius += radius * 0.1f;
    }
    
    _piePath = [UIBezierPath bezierPath];
    [_piePath moveToPoint:center];
    [_piePath addArcWithCenter:center radius:radius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
    if (_pieLayer == nil) {
        _pieLayer = [CAShapeLayer layer];
        _pieLayer.fillColor = self.pieColor.CGColor;
        _pieLayer.strokeColor = nil;
    }
    _pieLayer.path = _piePath.CGPath;
}

- (CGPoint)findLineEndPointWithCenter:(CGPoint)center Radius:(CGFloat)radius Detal:(CGFloat)detal {
    
    CGFloat start = self.startAngle;
    CGFloat end = self.endAngle;
    CGFloat angle = (start + end) / 2.0;
    
    CGFloat r = radius;
    
    CGFloat len = r + r * 0.35 + detal;
    if (len < r + r * 0.2) {
        return center;
    }
    
    CGFloat x = 0,y = 0;
    
    x = len * cos(angle);
    y = len * sin(angle);
    
    return CGPointMake(x + center.x, y + center.y);
}

- (void)showInView:(UIView *)view {
    [view.layer addSublayer:_lineLayer];
    [view.layer addSublayer:_pieLayer];
    [view addSubview:_titleLabel];
}

- (void)prepareNewStyleTitleInRect:(CGRect)rect WithCenter:(CGPoint)center Radius:(CGFloat)radius Height:(CGFloat)h AtIndex:(NSInteger)index ofQuadrant:(NSInteger)quad {
    
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:titleSize];
        _titleLabel.textColor = self.pieColor;
    }
    
    if (self.title.length == 0) {
        _titleLabel.text = [NSString stringWithFormat:@"%.2f%%",self.percentage * 100];
    } else {
        _titleLabel.text = [NSString stringWithFormat:@"%@(%.2f%%)",self.title,self.percentage * 100];
    }
        
    [_titleLabel sizeToFit];
    
    CGRect frame = _titleLabel.bounds;
    CGFloat y = CGRectGetMinY(rect);
    CGFloat x = CGRectGetMinX(rect);
    CGFloat originX = CGRectGetMinX(rect);
    // left
    if ([self inLeft]) {
        x = x + CGRectGetWidth(frame);
        originX = CGRectGetMinX(rect);
    } else {
        // right
        x = CGRectGetMaxX(rect) - CGRectGetWidth(frame);
        originX = x;
    }
    
    CGFloat maxY = 0, minY = 0;
    
    if (quad == 0) {
//        y = CGRectGetHeight(rect) - (h * (index + 0.5));
        minY = CGRectGetHeight(rect) - (h * (index + 1));
        maxY = CGRectGetHeight(rect) - (h * index);
        
    } else if (quad == 1) {
//        y = CGRectGetHeight(rect) - (h * (index + 0.5));
        minY = CGRectGetHeight(rect) - (h * (index + 1));
        maxY = CGRectGetHeight(rect) - (h * index);
        
    } else if (quad == 2) {
//        y = (h * (index + 0.5));
        minY = h * index;
        maxY = h * (index + 1);
        
    } else if (quad == 3) {
//        y = (h * (index + 0.5));
        minY = h * index;
        maxY = h * (index + 1);
    }
    
    CGPoint point = [self findLineEndPointWithCenter:center Radius:radius Detal:0];
    y = [self perfectYForMaxY:maxY MinY:minY BaseY:point.y TextHeight:CGRectGetHeight(frame)];
    
    frame.origin.x = originX;
    frame.origin.y = y - CGRectGetHeight(frame) * 0.5;
    _titleLabel.frame = frame;
    _titleRect = frame;
    
    // line
    _linePath = [UIBezierPath bezierPath];
    [_linePath moveToPoint:center];
    [_linePath addLineToPoint:point];
    [_linePath addLineToPoint:CGPointMake(x, y)];
    if (_lineLayer == nil) {
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.strokeColor = self.pieColor.CGColor;
        _lineLayer.fillColor = nil;
        _lineLayer.lineWidth = 0.5f;
        _lineLayer.lineJoin = kCALineJoinRound;
    }
    _lineLayer.path = _linePath.CGPath;
}

- (CGFloat)perfectYForMaxY:(CGFloat)maxY MinY:(CGFloat)minY BaseY:(CGFloat)py TextHeight:(CGFloat)h {
    
    float min_y = py - h * 0.5f, max_y = py + h * 0.5f;
    if (min_y >= minY && max_y <= maxY) {
        return py;
    }
    
    if ((min_y - minY) < 0) {
        py += minY - min_y;
    } else {
        py -= max_y - maxY;
    }
    
    return py;
}

- (BOOL)inLeft {
    
    CGFloat angle = [self angle];
    // left
    if (angle > M_PI_2 && angle <= M_PI_2 * 3) {
        return YES;
    } else {
        // right
        return NO;
    }
}

- (BOOL)inTop {
    CGFloat angle = [self angle];
    // left
    if (angle > M_PI && angle <= M_PI * 2) {
        return YES;
    } else {
        // right
        return NO;
    }
}

- (float)angle {
    CGFloat start = self.startAngle;
    CGFloat end = self.endAngle;
    CGFloat angle = (start + end) / 2.0;
    return angle;
}

@end

#pragma mark - View

@implementation JKPieChartView {
    float _total;
    JKPieChartItem *_selectedItem;
    CAShapeLayer *_heart;
}

- (CGPoint)center {
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    
    CGPoint center = CGPointMake(w * 0.5, h * 0.5);
    return center;
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor darkGrayColor];
    }
    return self;
}

- (void)setPieChartItems:(NSArray *)pieChartItems {
    _pieChartItems = pieChartItems;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    if ([self prepareChartItems]) {
        [self showPie];
    }
    if (self.hollow) {
        if (_heart == nil) {
            _heart = [CAShapeLayer layer];
            _heart.fillColor = self.backgroundColor.CGColor;
            _heart.strokeColor = nil;
        }
        UIBezierPath *heartPath = [UIBezierPath bezierPathWithArcCenter:[self center] radius:self.radius * 0.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        _heart.path = heartPath.CGPath;
        [self.layer addSublayer:_heart];
    }
}

- (BOOL)prepareChartItems {
    
    _selectedItem = nil;
    _total = 0;
    for (JKPieChartItem *item in self.pieChartItems) {
        _total += item.value;
        if (item.select) {
            _selectedItem = item;
        }

    }
    
    float offset = 0;
    
    for (int i = 0; i < self.pieChartItems.count; i++) {
        JKPieChartItem *item = [self.pieChartItems objectAtIndex:i];
        [item setPercentage:item.value / _total];
        [item setStartAngle:M_PI * 2 * offset];
        [item setEndAngle:M_PI * 2 * item.percentage + item.startAngle];
        offset += item.percentage;
        
        if (self.pieChartItems.count > 1) {
            if (i == 0) {
                item->_preItem = [self.pieChartItems objectAtIndex:self.pieChartItems.count - 1];
            } else {
                item->_preItem = [self.pieChartItems objectAtIndex:i - 1];
            }
            
            if (i == self.pieChartItems.count - 1) {
                item->_nextItem = [self.pieChartItems objectAtIndex:0];
            } else {
                item->_nextItem = [self.pieChartItems objectAtIndex:i + 1];
            }
        }
        
    }
    
    // prepare Pie
    CGPoint center = [self center];
    
    for (int i = 0; i < self.pieChartItems.count; i++) {
        JKPieChartItem *item = [self.pieChartItems objectAtIndex:i];
        [item preparePieWithCenter:center Radius:self.radius];
    }
    
    // prepare Title

    NSMutableArray *ltArr = [NSMutableArray array];
    NSMutableArray *lbArr = [NSMutableArray array];
    NSMutableArray *rtArr = [NSMutableArray array];
    NSMutableArray *rbArr = [NSMutableArray array];
    for (int i = 0; i < self.pieChartItems.count; i++) {
        JKPieChartItem *item = [self.pieChartItems objectAtIndex:i];
        //-----------
        if ([item inLeft]) {
            if ([item inTop]) {
                [ltArr addObject:item];
            } else {
                [lbArr addObject:item];
            }
        } else {
            if ([item inTop]) {
                [rtArr addObject:item];
            } else {
                [rbArr addObject:item];
            }
        }
    }
    
    [self betterBubble:lbArr withValue:M_PI_2];
    [self betterBubble:rbArr withValue:M_PI_2];
    [self betterBubble:rtArr withValue:M_PI_2 * 3];
    [self betterBubble:ltArr withValue:M_PI_2 * 3];
    
    
    NSInteger lcount = lbArr.count + ltArr.count;
    NSInteger rcount = rbArr.count + rtArr.count;
//        CGRect rect = CGRectMake(25, 25, 250, 250);
    CGRect rect = self.bounds;
    CGFloat h = CGRectGetHeight(rect);
    
    for (int i = 0; i < lbArr.count; i++) {
        JKPieChartItem *item = [lbArr objectAtIndex:i];
        [item prepareNewStyleTitleInRect:rect WithCenter:[self center] Radius:self.radius Height:h / lcount AtIndex:i ofQuadrant:0];
    }
    
    for (int i = 0; i < rbArr.count; i++) {
        JKPieChartItem *item = [rbArr objectAtIndex:i];
        [item prepareNewStyleTitleInRect:rect WithCenter:[self center] Radius:self.radius Height:h / rcount AtIndex:i ofQuadrant:1];
    }
    
    for (int i = 0; i < rtArr.count; i++) {
        JKPieChartItem *item = [rtArr objectAtIndex:i];
        [item prepareNewStyleTitleInRect:rect WithCenter:[self center] Radius:self.radius Height:h / rcount AtIndex:i ofQuadrant:2];
    }
    
    for (int i = 0; i < ltArr.count; i++) {
        JKPieChartItem *item = [ltArr objectAtIndex:i];
        [item prepareNewStyleTitleInRect:rect WithCenter:[self center] Radius:self.radius Height:h / lcount AtIndex:i ofQuadrant:3];
    }
    return YES;
}


- (void)showPie {
    
    NSArray *subViews = [self.subviews mutableCopy];
    for (UIView *subView in subViews) {
        [subView removeFromSuperview];
    }
    
    NSArray *subLayers = [self.layer.sublayers mutableCopy];
    for (CALayer *subLayer in subLayers) {
        [subLayer removeFromSuperlayer];
    }
    for (int i = 0; i < self.pieChartItems.count; i++) {
        JKPieChartItem *item = [self.pieChartItems objectAtIndex:i];
        [item showInView:self];
    }
}

- (void)betterBubble:(NSMutableArray *)arr withValue:(float)value {
    
    int low = 0;
    int high = (int)arr.count - 1;
    int j;
    while(low < high)
    {
        for (j= low; j < high; ++j) {//正向冒泡,找到最大者
            JKPieChartItem *item0 = [arr objectAtIndex:j];
            JKPieChartItem *item1 = [arr objectAtIndex:j + 1];
            
            float value0 = ABS([item0 angle] - value);
            float value1 = ABS([item1 angle] - value);
            
            if (value0 > value1)
            {
                [arr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
        --high;                 //修改high值, 前移一位
        
        for ( j=high; j>low; --j) {//反向冒泡,找到最小者
            
            JKPieChartItem *item0 = [arr objectAtIndex:j];
            JKPieChartItem *item1 = [arr objectAtIndex:j - 1];
            
            float value0 = ABS([item0 angle] - value);
            float value1 = ABS([item1 angle] - value);
            
            if (value0 < value1)
            {
                [arr exchangeObjectAtIndex:j withObjectAtIndex:j-1];
            }
        }
        ++low;                  //修改low值,后移一位
    }
}


#pragma mark - Action

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    [self touchAtPoint:touchPoint];
}

- (void)touchAtPoint:(CGPoint)point {

    CGPoint center = [self center];
    CGFloat r = self.radius;
    
    CGFloat distance = sqrt(pow(point.x - center.x, 2) + pow(point.y - center.y, 2));
    
    if (distance > r * 1.1f) {
        return;
    }
    
    CGFloat angle = [self angleforCenter:center toPoint:point];
    JKPieChartItem *touchedItem = [self findTouchedItemWithAngle:angle];
    if (!touchedItem.select) {
        [self selectItem:touchedItem];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(pieChartView:didSelectedItem:)]) {
            [self.delegate pieChartView:self didSelectedItem:touchedItem];
        }
    }
}

- (void)selectItem:(JKPieChartItem *)selectedItem {
    
    selectedItem.select = YES;
    if (_selectedItem) {
        _selectedItem.select = NO;
    }
    _selectedItem = selectedItem;
}

- (JKPieChartItem *)findTouchedItemWithAngle:(CGFloat)angle {
    
    for (JKPieChartItem *item in self.pieChartItems) {
        
        if (item.startAngle <= angle && item.endAngle >= angle) {
            return item;
        }
        
    }
    return nil;
}

- (CGFloat)angleforCenter:(CGPoint)center toPoint:(CGPoint)point {
    
    CGFloat distance = sqrt(pow(point.x - center.x, 2) + pow(point.y - center.y, 2));
    CGFloat angle = asinf(ABS(point.y - center.y) / distance);
    CGFloat offsetX = point.x - center.x;
    CGFloat offsetY = point.y - center.y;
    if (offsetX > 0 && offsetY > 0) {
        return angle;
    }
    if (offsetX < 0 && offsetY > 0) {
        return M_PI - angle;
    }
    if (offsetX < 0 && offsetY < 0) {
        return M_PI + angle;
    }
    if (offsetX > 0 && offsetY < 0) {
        return M_PI * 2 - angle;
    }
    if (offsetX == 0) {
        if (offsetY > 0) {
            return M_PI;
        }
        if (offsetY < 0) {
            return M_PI_2 * 3;
        }
    }
    if (offsetY == 0) {
        if (offsetX > 0) {
            return 0;
        }
        if (offsetX < 0) {
            return M_PI;
        }
    }
    
    return 0;
}

@end
