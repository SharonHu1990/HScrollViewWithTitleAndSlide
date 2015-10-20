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
#define TitleFontColor [UIColor grayColor]
#define TitleListHeaderViewColor [UIColor lightGrayColor]
#define SlideColor [UIColor greenColor]
#define TitleScrollViewBackgroundColor [UIColor whiteColor]
#define TickImageSize CGSizeMake(30.0,30.0)
#define ArrowImageSize CGSizeMake(30.0,30.0)
#define ArrowButtonBackgroundViewWidth 2*ArrowImageSize.width


@implementation HSlideScrollView


-(instancetype)initWithFrame:(CGRect)frame andTitleArrays:(NSArray *)titles andTitleScrollerViewHight:(CGFloat)titleScrollViewHight andNumverOfTitlesPerPage:(NSInteger)numberOfTitlesPerPage andArrowImage:(UIImage *)arrowImage andTickImage:(UIImage *)tickImage andTitleListTitle:(NSString *)titleListTitle//每一页显示的标题的个数
{
    
    if (self == [super initWithFrame:frame]) {
        
        titlesArray = titles;
        myTitleScrollViewHight = titleScrollViewHight;
        myNumberOfTitlesPerPage = numberOfTitlesPerPage;
        titleWidth = frame.size.width / numberOfTitlesPerPage;
        myArrowImage = arrowImage;
        myTickImage = tickImage;
        myTitleListTitle = titleListTitle;
        
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
    titleListHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, myTitleScrollView.frame.origin.y, self.frame.size.width, myTitleScrollViewHight)];
    [titleListHeaderView setBackgroundColor:TitleListHeaderViewColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:myTitleListTitle];
    [titleLabel sizeToFit];
    [titleLabel setCenter:CGPointMake(titleLabel.frame.size.width/2.0 + 15, myTitleScrollViewHight/2.0)];
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
    [slideView setBackgroundColor:SlideColor];
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
        [titleButton setTitleColor:TitleFontColor forState:UIControlStateNormal];
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
    arrowButtonBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(myTitleScrollView.frame.size.width - ArrowButtonBackgroundViewWidth, myTitleScrollView.frame.origin.y, ArrowButtonBackgroundViewWidth, myTitleScrollViewHight)];
    [arrowButtonBackgroundView setBackgroundColor:TitleScrollViewBackgroundColor];
    [arrowButtonBackgroundView.layer setShadowColor:[UIColor whiteColor].CGColor];
    [arrowButtonBackgroundView.layer setShadowOffset:CGSizeMake(-4, 0)];
    [arrowButtonBackgroundView.layer setShadowOpacity:0.8];
    [arrowButtonBackgroundView.layer setShadowRadius:4];
    [self addSubview:arrowButtonBackgroundView];
    
    showTotalButton = [[UIButton alloc] initWithFrame:CGRectMake((arrowButtonBackgroundView.frame.size.width - ArrowImageSize.width)/2.0, (arrowButtonBackgroundView.frame.size.height - ArrowImageSize.height)/2.0, ArrowImageSize.width, ArrowImageSize.height)];
    [showTotalButton setImage:myArrowImage forState:UIControlStateNormal];
    [showTotalButton addTarget:self action:@selector(touchTheArrowButton:) forControlEvents:UIControlEventTouchUpInside];
    [arrowButtonBackgroundView addSubview:showTotalButton];
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
        [oneContentView setBackgroundColor:[UIColor redColor]];
        UILabel *contentLB = [[UILabel alloc] init];
        [contentLB setText:titlesArray[i]];
        [contentLB setCenter:CGPointMake(myContentScrollView.center.x, myContentScrollView.center.y - myContentScrollView.frame.origin.y)];
        [contentLB sizeToFit];
        
        
        [oneContentView addSubview:contentLB];
        [myContentScrollView addSubview:oneContentView];
    }
}

/**
 *  点击标题
 *
 *  @param sender 标题按钮
 */
-(void)touchTheTitleButton:(UIButton *)sender
{
    selectedTitleListRow = sender.tag;
    [myContentScrollView setContentOffset:CGPointMake(myContentScrollView.frame.size.width * sender.tag, 0) animated:YES];
    [self manageTheScrollEventWithIndex:sender.tag];
}

/**
 *  点击箭头按钮
 *
 *  @param sender 箭头按钮
 */
-(void)touchTheArrowButton:(UIButton *)sender
{
    
    if (showTotalFlag) {
        [UIView animateWithDuration:0.3 animations:^{
            //顺时针旋转180度
            sender.transform = CGAffineTransformRotate(sender.transform, M_PI_2*1.0);
            sender.transform = CGAffineTransformRotate(sender.transform, M_PI_2*1.0);
            [titleListHeaderView setAlpha:0.f];
            [titleTableView setFrame:CGRectMake(0, myContentScrollView.frame.origin.y, myContentScrollView.frame.size.width, 0)];
            [arrowButtonBackgroundView setBackgroundColor:TitleScrollViewBackgroundColor];

            
        } completion:^(BOOL finished) {
            showTotalFlag = NO;
            
            [titleTableView reloadData];
            
            [arrowButtonBackgroundView.layer setShadowColor:[UIColor whiteColor].CGColor];
            [arrowButtonBackgroundView.layer setShadowOffset:CGSizeMake(-4, 0)];
            [arrowButtonBackgroundView.layer setShadowOpacity:0.8];
            [arrowButtonBackgroundView.layer setShadowRadius:4];
        }];
        
        
        
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            //逆时针旋转180度
            sender.transform = CGAffineTransformRotate(sender.transform, -M_PI_2*1.0);
            sender.transform = CGAffineTransformRotate(sender.transform, -M_PI_2*1.0);
            [titleListHeaderView setAlpha:1.0];
            [titleTableView setFrame:CGRectMake(0, myContentScrollView.frame.origin.y, myContentScrollView.frame.size.width, myContentScrollView.frame.size.height)];
            [arrowButtonBackgroundView setBackgroundColor:TitleListHeaderViewColor];
            [arrowButtonBackgroundView.layer setShadowOpacity:0];
        } completion:^(BOOL finished) {
            showTotalFlag = YES;
            
        }];
    }
}


/**
 *  管理滚动事件，使各项得以匹配
 *
 *  @param index (从0开始，滚动到第一个title)
 */
-(void)manageTheScrollEventWithIndex:(NSInteger)index
{
    if(index < myNumberOfTitlesPerPage/2){
        [myTitleScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if((titlesArray.count - index) <= ceilf(myNumberOfTitlesPerPage/2.0) - 2){
        [myTitleScrollView setContentOffset:CGPointMake((titlesArray.count - myNumberOfTitlesPerPage +1)*titleWidth, 0) animated:YES];
    }else{
        [myTitleScrollView setContentOffset:CGPointMake((index - myNumberOfTitlesPerPage/2)*titleWidth, 0) animated:YES];
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
    
    if ([cell.contentView viewWithTag:2] == nil) {
        UIImage *cellTickImage = myTickImage;
        UIImageView *tickImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 15 - TickImageSize.width, (cell.frame.size.height - TickImageSize.height)/2.0, TickImageSize.width, TickImageSize.height)];
        [tickImageView setImage:cellTickImage];
        [cell.contentView addSubview:tickImageView];
        [tickImageView setTag:2];
    }
    
    if (indexPath.row == selectedTitleListRow) {
        [[cell.contentView viewWithTag:2] setHidden:NO];
    }else
    {
        [[cell.contentView viewWithTag:2] setHidden:YES];
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedTitleListRow = indexPath.row;
    [self touchTheArrowButton: showTotalButton];
    //滑动到相应的Tab
    [myContentScrollView setContentOffset:CGPointMake(myContentScrollView.frame.size.width * indexPath.row, 0) animated:YES];
    [self manageTheScrollEventWithIndex:indexPath.row];

}



#pragma mark - UIScrollViewDelegate Methods
// 滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:myContentScrollView]) {
        selectedTitleListRow = myContentScrollView.contentOffset.x / myContentScrollView.frame.size.width;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //向上取整
    NSInteger index = ceilf(myContentScrollView.contentOffset.x / myContentScrollView.frame.size.width);
    selectedTitleListRow = index;
    [self manageTheScrollEventWithIndex:index];
}



// 当开始滚动视图时，执行该方法。一次有效滑动（开始滑动，滑动一小段距离，只要手指不松开，只算一次滑动），只执行一次。
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:myContentScrollView]) {
        contentScrollViewStartPosition = scrollView.contentOffset;
    }

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
