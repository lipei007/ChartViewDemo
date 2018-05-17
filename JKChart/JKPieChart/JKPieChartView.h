//
//  JKPieChartView.h
//  Test
//
//  Created by Jack on 2018/3/29.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKPieChartItem,JKPieChartView;
@protocol JKPieChartDelegate <NSObject>

@optional
- (void)pieChartView:(JKPieChartView *)pieChartView didSelectedItem:(JKPieChartItem *)item;

@end

@interface JKPieChartItem : NSObject

@property (nonatomic,assign) float value;
@property (nonatomic,strong) UIColor *pieColor;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) BOOL select;

@property (nonatomic,assign,readonly) float percentage;
@property (nonatomic,assign,readonly) float startAngle;
@property (nonatomic,assign,readonly) float endAngle;

@end


@interface JKPieChartView : UIControl

@property (nonatomic,strong) NSArray *pieChartItems;
@property (nonatomic,assign) CGFloat radius;
@property (nonatomic,assign) BOOL hollow;///<空心
@property (nonatomic,assign) BOOL newStyle;
@property (nonatomic,weak) id<JKPieChartDelegate> delegate;


- (void)selectItem:(JKPieChartItem *)selectedItem;

@end
