//
//  RealmCandleChartViewController.m
//  ChartsDemo
//
//  Created by Daniel Cohen Gindi on 17/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts
//

#import "RealmCandleChartViewController.h"
#import "ChartsDemo-Swift.h"
#import <Realm/Realm.h>
#import "RealmDemoData.h"

@interface RealmCandleChartViewController () <ChartViewDelegate>

@property (nonatomic, strong) IBOutlet CandleStickChartView *chartView;

@end

@implementation RealmCandleChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self writeRandomCandleDataToDbWithObjectCount:50];
    
    self.title = @"Realm.io CandleStick Chart Chart";
    
    self.options = @[
                     @{@"key": @"toggleValues", @"label": @"Toggle Values"},
                     @{@"key": @"toggleHighlight", @"label": @"Toggle Highlight"},
                     @{@"key": @"toggleStartZero", @"label": @"Toggle StartZero"},
                     @{@"key": @"animateX", @"label": @"Animate X"},
                     @{@"key": @"animateY", @"label": @"Animate Y"},
                     @{@"key": @"animateXY", @"label": @"Animate XY"},
                     @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"},
                     @{@"key": @"togglePinchZoom", @"label": @"Toggle PinchZoom"},
                     @{@"key": @"toggleAutoScaleMinMax", @"label": @"Toggle auto scale min/max"},
                     @{@"key": @"toggleShadowColorSameAsCandle", @"label": @"Toggle shadow same color"},
                     ];
    
    
    _chartView.delegate = self;
    
    [self setupBarLineChartView:_chartView];
    
    _chartView.leftAxis.drawGridLinesEnabled = NO;
    _chartView.xAxis.drawGridLinesEnabled = NO;
    
    [self setData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setData
{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    RLMResults *results = [RealmDemoData allObjectsInRealm:realm];
    
    RealmCandleDataSet *set = [[RealmCandleDataSet alloc] initWithResults:results highField:@"high" lowField:@"low" openField:@"open" closeField:@"close" xIndexField:@"xIndex"];

    set.label = @"Realm CandleDataSet";
    set.shadowColor = UIColor.darkGrayColor;
    set.shadowWidth = 0.7f;
    set.decreasingColor = UIColor.redColor;
    set.decreasingFilled = NO;
    set.increasingColor = [UIColor colorWithRed:122/255.f green:242/255.f blue:84/255.f alpha:1.f];
    set.increasingFilled = YES;
    
    NSArray<RealmCandleDataSet *> *dataSets = @[set];

    CandleChartData *data = [[CandleChartData alloc] init];
    data.dataSets = dataSets;
    [data loadXValuesFromRealmResults:results xValueField:@"xValue"];
    [self styleData:data];
    
    [_chartView zoom:5.f scaleY:1.f x:0.f y:0.f];
    _chartView.data = data;
    
    [_chartView animateWithYAxisDuration:1.4 easingOption:ChartEasingOptionEaseInOutQuart];
}

- (void)optionTapped:(NSString *)key
{
    if ([key isEqualToString:@"toggleValues"])
    {
        for (id<IChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawValuesEnabled = !set.isDrawValuesEnabled;
        }
        
        [_chartView setNeedsDisplay];
    }
        
    if ([key isEqualToString:@"toggleHighlight"])
    {
        _chartView.data.highlightEnabled = !_chartView.data.isHighlightEnabled;
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleStartZero"])
    {
        _chartView.leftAxis.startAtZeroEnabled = !_chartView.leftAxis.isStartAtZeroEnabled;
        _chartView.rightAxis.startAtZeroEnabled = !_chartView.rightAxis.isStartAtZeroEnabled;
        
        [_chartView notifyDataSetChanged];
    }
    
    if ([key isEqualToString:@"animateX"])
    {
        [_chartView animateWithXAxisDuration:3.0];
    }
    
    if ([key isEqualToString:@"animateY"])
    {
        [_chartView animateWithYAxisDuration:3.0];
    }
    
    if ([key isEqualToString:@"animateXY"])
    {
        [_chartView animateWithXAxisDuration:3.0 yAxisDuration:3.0];
    }
    
    if ([key isEqualToString:@"saveToGallery"])
    {
        [_chartView saveToCameraRoll];
    }
    
    if ([key isEqualToString:@"togglePinchZoom"])
    {
        _chartView.pinchZoomEnabled = !_chartView.isPinchZoomEnabled;
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleAutoScaleMinMax"])
    {
        _chartView.autoScaleMinMaxEnabled = !_chartView.isAutoScaleMinMaxEnabled;
        [_chartView notifyDataSetChanged];
    }
    
    if ([key isEqualToString:@"toggleShadowColorSameAsCandle"])
    {
        for (id<ICandleChartDataSet> set in _chartView.data.dataSets)
        {
            set.shadowColorSameAsCandle = !set.shadowColorSameAsCandle;
        }
        
        [_chartView notifyDataSetChanged];
    }
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

@end
