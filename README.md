# HScrollViewWithTitleAndSlide
1. 模仿LOFTER发现界面的页面切换效果标题可以随着内容的滚动而滚动，并且可以下拉展示所有标题。
2. 下拉按钮的图片和勾选的图片可以自定义，每页最多显示的标题的个数可以自定义。
3. 封装的比较完整，使用起来很简单，几句代码搞定。


Xcode7.0.1


Objective-C


## 框架使用说明


1. 拖拽HSlideScrollView文件夹到你的工程目录.
2. 在需要使用该框架的ViewController中添加如下代码：

代码示例：

    /**
     *  添加MySlideScrollView
    */
    -(void)addMySlideScrollView
    {
        CGRect slideScrollFrame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
        NSArray *titlesArray = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J",     @"K", @"L", @"M", @"N", nil];
        mySlideScrollView = [[HSlideScrollView alloc] initWithFrame:slideScrollFrame andTitleArrays:titlesArray     andTitleScrollerViewHight:40.f andNumverOfTitlesPerPage:7 andArrowImage:[UIImage imageNamed:@"arrow_down"] andTickImage:[UIImage         imageNamed:@"tick"] andTitleListTitle:@"分类"];
         [self.view addSubview:mySlideScrollView];
    }


## 功能演示
![功能演示](http://7xlt6k.com1.z0.glb.clouddn.com/SlideScrollView.gif)


## 功能说明


1. 最基本的功能，滑动内容，标题和滑竿随之滑动；
2. 点击箭头可以展示所有的标题，点击标题展示相应的内容
