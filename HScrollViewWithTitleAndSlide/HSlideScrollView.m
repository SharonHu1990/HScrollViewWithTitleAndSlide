//
//  HSlideScrollView.m
//  HScrollViewWithTitleAndSlide
//
//  Created by 胡晓阳 on 15/10/14.
//  Copyright © 2015年 HXY. All rights reserved.
//

#import "HSlideScrollView.h"
#define SlideHeight 2.f
#define TitleColor [UIColor grayColor]



@implementation HSlideScrollView


-(instancetype)initWithFrame:(CGRect)frame andTitleArrays:(NSArray *)titles andTitleScrollerViewHight:(CGFloat)titleScrollViewHight andNumverOfTitlesPerPage:(NSInteger)numberOfTitlesPerPage//每一页显示的标题的个数
{
    
    if (self == [super initWithFrame:frame]) {
        
        titlesArray = titles;
        myTitleScrollViewHight = titleScrollViewHight;
        myNumberOfTitlesPerPage = numberOfTitlesPerPage;
        
        titleWidth = frame.size.width / numberOfTitlesPerPage;
        
        [self initiateTitleScrollView];
        [self initiateContentScrollView];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


/**
 *  初始化TitleScrollView
 */
-(void)initiateTitleScrollView
{
    myTitleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, myTitleScrollViewHight)];
    [myTitleScrollView setContentSize:CGSizeMake(titleWidth * titlesArray.count, myTitleScrollViewHight)];
    [myTitleScrollView setShowsHorizontalScrollIndicator:NO];
    [self addSubview:myTitleScrollView];
    myTitleScrollView.delegate = self;

    
    [self loadTitleButtons];
    [self initiateSlideView];
    

}

-(void)initiateSlideView
{
    slideView = [[UIView alloc] initWithFrame:CGRectMake(0, myTitleScrollViewHight - SlideHeight, titleWidth, SlideHeight)];
    [myTitleScrollView addSubview:slideView];
}

/**
 *  初始化ContentScrollView
 */
-(void)initiateContentScrollView
{
    myContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, myTitleScrollViewHight, self.frame.size.width, self.frame.size.height - myTitleScrollViewHight)];
    myContentScrollView.delegate = self;
    [myContentScrollView setShowsHorizontalScrollIndicator:NO];
    [myContentScrollView setContentSize:CGSizeMake(self.frame.size.width * titlesArray.count, myContentScrollView.frame.size.height)];
    [myContentScrollView setScrollEnabled:YES];
    myContentScrollView.pagingEnabled = YES;
    [self addSubview:myContentScrollView];
 
    [self loadContentViews];
}

/**
 *  添加title按钮
 *
 *  @param titlesArray <#titlesArray description#>
 */
-(void)loadTitleButtons
{
    for (int i = 0; i < titlesArray.count; i ++) {
        UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(titleWidth * i, 0, titleWidth, myTitleScrollViewHight - SlideHeight)];
        [titleButton setTitle:titlesArray[i] forState:UIControlStateNormal];
        [titleButton setTitleColor:TitleColor forState:UIControlStateNormal];
        [titleButton setTag:i];
        [myTitleScrollView addSubview:titleButton];
    }

}

/**
 *  添加ContentView
 *
 *  @param contentViewsArray <#contentViewsArray description#>
 */
-(void)loadContentViews
{
    for (int i = 0; i < titlesArray.count; i++) {
        
        UIView *oneContentView = [[UIView alloc] initWithFrame:CGRectMake(i * myContentScrollView.frame.size.width, 0, myContentScrollView.frame.size.width, myContentScrollView.frame.size.height)];
        
        UILabel *contentLB = [[UILabel alloc] init];
        [contentLB setText:titlesArray[i]];
        [contentLB setCenter:CGPointMake(myContentScrollView.center.x, myContentScrollView.center.y - myContentScrollView.frame.origin.y)];
        [contentLB sizeToFit];
        
        
        [oneContentView addSubview:contentLB];
        [myContentScrollView addSubview:oneContentView];
    }
}

-(void)setSlideColor:(UIColor *)slideColor
{
    [slideView setBackgroundColor:slideColor];
}


-(void)setTitleScrollViewColor:(UIColor *)titleScrollViewColor
{
    [myTitleScrollView setBackgroundColor:titleScrollViewColor];
}


#pragma mark - UIScrollViewDelegate Methods
// 滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"停止拖拽");
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //    NSLog(@"scrollViewDidEndDecelerating");
    
    
}



// 滑动scrollView，并且手指离开时执行。一次有效滑动，只执行一次。
// 当pagingEnabled属性为YES时，不调用，该方法
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
//    NSLog(@"scrollViewWillEndDragging");
    
}

// 当开始滚动视图时，执行该方法。一次有效滑动（开始滑动，滑动一小段距离，只要手指不松开，只算一次滑动），只执行一次。
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
//    NSLog(@"scrollViewWillBeginDragging");
    if ([scrollView isEqual:myContentScrollView]) {
        contentScrollViewStartPosition = scrollView.contentOffset;
    }
    
    if ([scrollView isEqual:myContentScrollView]) {
        if (scrollDirection == DirectionRight) {
            
            //右滑超过一半
            BOOL scrollMoreThanHalf = (slideView.frame.origin.x - myTitleScrollView.contentOffset.x)/titleWidth > myNumberOfTitlesPerPage/2;
            
            //最后一个title已经出现
            BOOL lastTitleAppears = (myTitleScrollView.contentSize.width - myTitleScrollView.contentOffset.x)/titleWidth == myNumberOfTitlesPerPage ? YES : NO;
            
            
            
            if (scrollMoreThanHalf && !lastTitleAppears)
                    {
                NSInteger contentPage = myContentScrollView.contentOffset.x / myContentScrollView.frame.size.width;
                
                [myTitleScrollView setContentOffset:CGPointMake(titleWidth * (contentPage - myNumberOfTitlesPerPage/2), 0) animated:YES];
                    }
            
        }else{
            
            //第一个title已经出现
            BOOL firstTitleAppears = myTitleScrollView.contentOffset.x == 0 ? YES : NO;
            
            if (!firstTitleAppears) {
                
                if (myTitleScrollView.contentOffset.x > 0) {
                    NSInteger contentPage = myContentScrollView.contentOffset.x / myContentScrollView.frame.size.width;
                    [myTitleScrollView setContentOffset:CGPointMake(titleWidth * (contentPage - myNumberOfTitlesPerPage/2 - 2) , 0) animated:YES];
                }
            }
        }
        
    }

}


// 当滚动视图动画完成后，调用该方法，如果没有动画，那么该方法将不被调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
//    NSLog(@"scrollViewDidEndScrollingAnimation");
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if ([scrollView isEqual:myContentScrollView]) {
        contentScrollViewCurrentPosition = scrollView.contentOffset;
        
        //滑竿移动
        CGFloat rate = contentScrollViewCurrentPosition.x / myContentScrollView.contentSize.width;
        CGFloat slideMoveDistance = rate * myTitleScrollView.contentSize.width;
        [slideView setFrame:CGRectMake(slideMoveDistance, slideView.frame.origin.y, slideView.frame.size.width, slideView.frame.size.height)];
        
        
        if (contentScrollViewCurrentPosition.x < contentScrollViewStartPosition.x &&
            contentScrollViewCurrentPosition.x < myContentScrollView.contentSize.width) {
            scrollDirection = DirectionLeft;
        }else if(contentScrollViewCurrentPosition.x > contentScrollViewStartPosition.x &&
                 contentScrollViewCurrentPosition.x > 0){
            scrollDirection = DirectionRight;
        }
    }
    

}
@end
