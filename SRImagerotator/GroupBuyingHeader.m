//
//  GroupBuyingHeader.m
//  01-团购
//
//  Created by chao on 15/7/7.
//  Copyright (c) 2015年 chao. All rights reserved.
//

#import "GroupBuyingHeader.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "head.h"
@interface GroupBuyingHeader ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property(nonatomic,strong) NSArray *dataArray;
// scrollView的宽
#define SCROLLVIEW_WIDTH  self.scrollView.frame.size.width
#define SCROLLVIEW_HEIGHT self.scrollView.frame.size.height
// 图片个数
#define IMAGECOUNT  self.dataArray.count
@end
@implementation GroupBuyingHeader

// 加载xib时系统调用
- (void)awakeFromNib {
   
   
}

#pragma mark -置scrollView的属性
- (void)settingScrollViewAttribute {
    // 设置scorllView的contentSize
    self.scrollView.contentSize = CGSizeMake((IMAGECOUNT + 2) * SCROLLVIEW_WIDTH, 0);
    // 默认让scrollView滚动到第一页
    [self.scrollView setContentOffset:CGPointMake(SCROLLVIEW_WIDTH, 0)];
    
    // 也可以在xib或storyboard中连线
    //    self.scrollView.delegate = self;
    self.pageControl.numberOfPages = IMAGECOUNT;
    // 分页效果
    self.scrollView.pagingEnabled = YES;
    // 隐藏手平滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
}

#pragma mark - 给scrollView添加内容imageView
- (void)addImageViewInScrollView {
    // 添加scorllView中的内容图片
    for (int i = 0; i < IMAGECOUNT; ++i) {
        [self addImageViewWithImageNubmer:i imageWidth:SCROLLVIEW_WIDTH * i + SCROLLVIEW_WIDTH];
        
    }
    // 1.1 将最后一张图片放在第0个位置
    [self addImageViewWithImageNubmer:self.dataArray.count-1 imageWidth:0];
    
    // 1.2 将第一张图片放在最后1页
    [self addImageViewWithImageNubmer:0 imageWidth:(IMAGECOUNT + 1) * SCROLLVIEW_WIDTH];
}

#pragma mark - 通过传入图片索引名和图片的X来添加scrollView的内容图片
- (void)addImageViewWithImageNubmer:(NSInteger)nubmer imageWidth:(CGFloat)imageWidth  {
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"ad_0%zd", nubmer]]];
     UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
    head *myhead=self.dataArray[nubmer];
    [imageView sd_setImageWithURL:[NSURL URLWithString:myhead.imgsrc]];
    [self.scrollView addSubview:imageView];
}

#pragma mark - 在滚动视图滚动动画结束, 滚动视图调用的setContentOffset方法时动画结束后调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidStop:scrollView];
}

#pragma mark - 当滚动动画结束后调用
- (void)scrollViewDidStop:(UIScrollView *)scrollView {
    // 获取当前真实滚动到第几页
//    NSInteger page = (self.scrollView.contentOffset.x + SCROLLVIEW_WIDTH * 0.5) / SCROLLVIEW_WIDTH;
    NSInteger page = (self.scrollView.contentOffset.x) / SCROLLVIEW_WIDTH;
    // 如果是第0页就让他再滚动到第5页
    if (page == 0){
        [self.scrollView setContentOffset:CGPointMake(SCROLLVIEW_WIDTH * IMAGECOUNT, 0)];
        // 如果是第6页,就让他滚动到第1页
    } else if (page == (IMAGECOUNT + 1)) {
        [self.scrollView setContentOffset:CGPointMake(SCROLLVIEW_WIDTH , 0)];
    }
}

#pragma mark - 开始拖拽时移除定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 移除定时器
    [self removeTimer];
}

#pragma mark - 滚动中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 获取当前真实滚动页数
    //NSInteger page = (scrollView.contentOffset.x + SCROLLVIEW_WIDTH * 0.5) / SCROLLVIEW_WIDTH;
    NSInteger page = (self.scrollView.contentOffset.x) / SCROLLVIEW_WIDTH;
    // 真实页数减一为pageControl的当前
    page --;
    
    self.pageControl.currentPage = page;
}

#pragma mark - 停止拖拽时添加定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 添加定时器
    [self addTimer];
}

#pragma mark - 添加定时器
- (void)addTimer {
    // 创建并启动定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(next:) userInfo:@"haha" repeats:YES];
    // 添加定时器到运行循环 并设置运行循环为通过"全检测"模式
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 移出定时器
- (void)removeTimer {
    // 停止定时器
    [self.timer invalidate];
    // 清空指针
    self.timer = nil;
}

#pragma mark - 下一张
- (void)next:(NSTimer *)timer {

    // 取出当前页数
    NSInteger page = self.pageControl.currentPage;
    // 如果page不是5就+1 如果是就变为0
    page != IMAGECOUNT ? page++ : (page = 0);
    // 默认从第二张开始滚动
    CGPoint offset = CGPointMake(SCROLLVIEW_WIDTH * (page + 1), 0);
    [self.scrollView setContentOffset:offset animated:YES];

}
//设置图片数组时调用
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray=dataArray;

    // 给scrollView添加内容imageView
    [self addImageViewInScrollView];
    
    // 设置scrollView的属性
    [self settingScrollViewAttribute];
    
    // 添加定时器
    [self addTimer];
    
}
//加载图片数据
-(void)loadDataWith:(NSString *)urlString{
        [head getArrayWithUrlString:urlString completion:^(NSArray *array) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dataArray=array;
            });
    
        }];
}
#pragma mark - 快速创建头部视图
+(instancetype)groupBuyingHeader{
   

    return [[[NSBundle mainBundle] loadNibNamed:@"GroupBuyingHeader" owner:nil options:nil] lastObject];;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
}

@end
