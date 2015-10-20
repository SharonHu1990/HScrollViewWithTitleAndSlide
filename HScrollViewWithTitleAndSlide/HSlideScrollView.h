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

@interface HSlideScrollView : UIView<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
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
    

    
    BOOL showTotalFlag;//点击titleScrollView右侧的按钮展示全部标题列表
    UITableView *titleTableView;//title列表
    UIView *titleListHeaderView;//title列表上方的标题View
    UIView *arrowButtonBackgroundView;
    UIButton *showTotalButton;
    NSInteger selectedTitleListRow;//选中的titleList的某一行
    
    UIImage *myArrowImage;//箭头图片
    UIImage *myTickImage;//对勾图片
    NSString *myTitleListTitle;//title列表的标题
}

-(instancetype)initWithFrame:(CGRect)frame andTitleArrays:(NSArray *)titles andTitleScrollerViewHight:(CGFloat)titleScrollViewHight andNumverOfTitlesPerPage:(NSInteger)numberOfTitlesPerPage andArrowImage:(UIImage *)arrowImage andTickImage:(UIImage *)tickImage andTitleListTitle:(NSString *)titleListTitle;

-(void)loadContentViews;
@end
