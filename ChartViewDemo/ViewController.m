//
//  ViewController.m
//  ChartViewDemo
//
//  Created by Jack on 2018/4/4.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "ViewController.h"
#import "JKPieChartView.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet JKPieChartView *pieChart;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.pieChart.radius = 40;
    self.pieChart.newStyle = YES;

    JKPieChartItem *itmx = [JKPieChartItem new];
    itmx.value = 1;
    itmx.title = @"Part 0";

    JKPieChartItem *itm0 = [JKPieChartItem new];
    itm0.value = 29;
    itm0.title = @"Part 1";

    JKPieChartItem *itm1 = [JKPieChartItem new];
    itm1.value = 30;
    itm1.title = @"Part 2";

    JKPieChartItem *itm2 = [JKPieChartItem new];
    itm2.value = 30;
    itm2.title = @"Part 3";
    itm2.select = YES;

    JKPieChartItem *itm3 = [JKPieChartItem new];
    itm3.value = 7;
    itm3.title = @"Part 4";

    JKPieChartItem *itm4 = [JKPieChartItem new];
    itm4.value = 1;
    itm4.title = @"Part 5";

    JKPieChartItem *itm5 = [JKPieChartItem new];
    itm5.value = 1;
    itm5.title = @"Part 6";

    JKPieChartItem *itm6 = [JKPieChartItem new];
    itm6.value = 1;
    itm6.title = @"Part 7";

    JKPieChartItem *itm7 = [JKPieChartItem new];
    itm7.value = 1;
    itm7.title = @"Part 8";

    JKPieChartItem *itm8 = [JKPieChartItem new];
    itm8.value = 1;
    itm8.title = @"Part 9";

//    self.pieChart.pieChartItems = [@[itmx,itm0,itm4,itm5,itm6,itm7,itm1,itm2,itm3] mutableCopy];
    self.pieChart.pieChartItems = [@[itmx,itm0,itm1,itm2,itm3,itm4,itm5,itm6,itm7,itm8] mutableCopy];

    itm0.pieColor = [UIColor redColor];
    itm1.pieColor = [UIColor greenColor];
    itm2.pieColor = [UIColor blueColor];
//    self.pieChart.pieChartItems = @[itm0,itm1,itm2];

    self.pieChart.hollow = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
