//
//  HSlideScrollView.h
//  HScrollViewWithTitleAndSlide
//
//  Created by 胡晓阳 on 15/10/14.
//  Copyright © 2015年 HXY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DirectionLeft,
    DirectionRight,
} ScrollDirection;

@interface HSlideScrollView : UIView<UIScrollViewDelegate>
{
    NSArray *titlesArray;
    CGFloat myTitleScrollViewHight;
    UIScrollView *myTitleScrollView;
    UIScrollView *myContentScrollView;
    NSInteger myNumberOfTitlesPerPage;//每一页显示的标题的个数
    UIView *slideView;//滑竿
    
    CGFloat titleWidth;//每个标题的宽度
    
    CGPoint contentScrollViewCurrentPosition;
    CGPoint contentScrollViewStartPosition;//开始拖拽的位置
    ScrollDirection scrollDirection;
    
    BOOL titleTouchTopLeft;
    BOOL titleTouchTopRight;
    
}

@property (nonatomic) UIColor* slideColor;
@property (nonatomic) UIColor* titleScrollViewColor;


-(instancetype)initWithFrame:(CGRect)frame andTitleArrays:(NSArray *)titles andTitleScrollerViewHight:(CGFloat)titleScrollViewHight andNumverOfTitlesPerPage:(NSInteger)numberOfTitlesPerPage;

-(void)loadContentViews;
@end
