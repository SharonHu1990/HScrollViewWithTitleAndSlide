//
//  ViewController.m
//  HScrollViewWithTitleAndSlide
//
//  Created by 胡晓阳 on 15/10/14.
//  Copyright © 2015年 HXY. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addMySlideScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  添加MySlideScrollView
 */
-(void)addMySlideScrollView
{
    CGRect slideScrollFrame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    
    NSArray *titlesArray = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", nil];
    mySlideScrollView = [[HSlideScrollView alloc] initWithFrame:slideScrollFrame andTitleArrays:titlesArray andTitleScrollerViewHight:40.f andNumverOfTitlesPerPage:6];
    mySlideScrollView.titleScrollViewColor = [UIColor lightGrayColor];
    mySlideScrollView.slideColor = [UIColor greenColor];
    
    [self.view addSubview:mySlideScrollView];


}



@end
