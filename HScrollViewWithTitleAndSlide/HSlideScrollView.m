//
//  HSlideScrollView.m
//  HScrollViewWithTitleAndSlide
//
//  Created by 胡晓阳 on 15/10/14.
//  Copyright © 2015年 HXY. All rights reserved.
//

#import "HSlideScrollView.h"
#import <math.h>
#define SlideHeight 2.f
#define ShowMoreButtonWidth 50.f
#define TitleColor [UIColor whiteColor]
#define TitleListHeaderViewColor [UIColor grayColor]
#define TitleList_Title @"标题列表"



@implementation HSlideScrollView


-(instancetype)initWithFrame:(CGRect)frame andTitleArrays:(NSArray *)titles andTitleScrollerViewHight:(CGFloat)titleScrollViewHight andNumverOfTitlesPerPage:(NSInteger)numberOfTitlesPerPage//每一页显示的标题的个数
{
    
    if (self == [super initWithFrame:frame]) {
        
        titlesArray = titles;
        myTitleScrollViewHight = titleScrollViewHight;
        myNumberOfTitlesPerPage = numberOfTitlesPerPage;
        
        titleWidth = frame.size.width / numberOfTitlesPerPage;
        
        [self initiateTitleScrollView];
        [self loadTitleButtons];
        [self loadTitleListHeaderView];
        [self loadShowTotalButton];
        [self initiateSlideView];
        [self initiateContentScrollView];
        [self initiateTitleTableView];
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
}

/**
 *  初始化标题列表
 */
-(void)initiateTitleTableView
{
    titleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, myContentScrollView.frame.origin.y, self.frame.size.width, 0) style:UITableViewStylePlain];
    titleTableView.dataSource = self;
    titleTableView.delegate = self;
    
    if([titleTableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [titleTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    [titleTableView setTableFooterView:footerView];
    [self addSubview:titleTableView];

}

/**
 *  添加title列表上方的View
 */
-(void)loadTitleListHeaderView
{
    titleListHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, myTitleScrollViewHight)];
    [titleTableView setBackgroundColor:TitleListHeaderViewColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:TitleList_Title];
    [titleLabel sizeToFit];
    [titleLabel setCenter:CGPointMake(20, (myTitleScrollViewHight - titleLabel.frame.size.height)/2.0)];
    [titleListHeaderView addSubview:titleLabel];
    [self addSubview:titleListHeaderView];
    [titleListHeaderView setAlpha:0.f];
}

/**
 *  初始化滑竿
 */
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
        [titleButton addTarget:self action:@selector(touchTheTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        [myTitleScrollView addSubview:titleButton];
    }
}

/**
 *  添加totalButton
 */
-(void)loadShowTotalButton
{
    UIView *showTotalButtonBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(myTitleScrollView.frame.size.width - ShowMoreButtonWidth, myTitleScrollView.frame.origin.y, ShowMoreButtonWidth, myTitleScrollViewHight)];
    [showTotalButtonBackgroundView setBackgroundColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.7]];
    [self addSubview:showTotalButtonBackgroundView];
    
    UIButton *showTotalButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ShowMoreButtonWidth, myTitleScrollViewHight)];
    [showTotalButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [showTotalButton addTarget:self action:@selector(touchTheTotalButton:) forControlEvents:UIControlEventTouchUpInside];
    [showTotalButtonBackgroundView addSubview:showTotalButton];
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


-(void)touchTheTitleButton:(UIButton *)sender
{
    [myContentScrollView setContentOffset:CGPointMake(myContentScrollView.frame.size.width * sender.tag, 0) animated:YES];
}

-(void)touchTheTotalButton:(UIButton *)sender
{
    
    if (showTotalFlag) {
        [UIView animateWithDuration:0.3 animations:^{
            //顺时针旋转180度
            sender.transform = CGAffineTransformRotate(sender.transform, M_PI_2*1.0);
            sender.transform = CGAffineTransformRotate(sender.transform, M_PI_2*1.0);
            [titleListHeaderView setAlpha:0.f];
            [titleTableView setFrame:CGRectMake(0, myContentScrollView.frame.origin.y, myContentScrollView.frame.size.width, 0)];
            
        } completion:^(BOOL finished) {
            showTotalFlag = NO;
        }];
        
        
        
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            //逆时针旋转180度
            sender.transform = CGAffineTransformRotate(sender.transform, -M_PI_2*1.0);
            sender.transform = CGAffineTransformRotate(sender.transform, -M_PI_2*1.0);
            [titleListHeaderView setAlpha:1.0];
            [titleTableView setFrame:CGRectMake(0, myContentScrollView.frame.origin.y, myContentScrollView.frame.size.width, myContentScrollView.frame.size.height)];
            
        } completion:^(BOOL finished) {
            showTotalFlag = YES;
        }];
    }
}



#pragma mark - UITableViewDelegate Methods & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titlesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"TitleCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    //configure cell
    [cell.textLabel setText:titlesArray[indexPath.row]];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    return cell;
}



#pragma mark - UIScrollViewDelegate Methods
// 滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
//    NSLog(@"DidEndDecelerating");
    if ([scrollView isEqual:myContentScrollView]) {
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"DidEndDragging");
    
    
    //向上取整
    int page = ceilf(myContentScrollView.contentOffset.x / myContentScrollView.frame.size.width);
    NSLog(@"page:%d",page);
    
    if (page >= myNumberOfTitlesPerPage/2  && (titlesArray.count - page) > ceil(myNumberOfTitlesPerPage/2.0) - 2) {
        
        [myTitleScrollView setContentOffset:CGPointMake((page - myNumberOfTitlesPerPage/2)*titleWidth, 0) animated:YES];
        NSLog(@"%f",myTitleScrollView.contentOffset.x);
    }
   
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{

//    NSLog(@"WillBeginDecelerating");

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

}


// 当滚动视图动画完成后，调用该方法，如果没有动画，那么该方法将不被调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
//    NSLog(@"scrollViewDidEndScrollingAnimation");
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"didScroll");
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
    
    
#warning 将执行TitleScrollView滚动的动作 和  ContentView相关联 而不是Slide
    
}
@end
