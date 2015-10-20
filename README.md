# HScrollViewWithTitleAndSlide
拥有可滚动标题的ScrollView。


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
