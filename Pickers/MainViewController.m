//
//  MainViewController.m
//  NBEX
//
//  Created by Will on 10-6-11.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController
@synthesize array;


#pragma mark -
#pragma mark === viewDidLoad ===
#pragma mark -
- (void)viewDidLoad
{
	[super viewDidLoad];
	
    self.navigationItem.title=@"图片浏览";
    
	self.view.backgroundColor = [UIColor blackColor];
	for (int i=0; i<[array count]; i++){
		MyScrollView *ascrView = [[MyScrollView alloc] initWithFrame:CGRectMake(340*i, 0, 320, 440)];

        UIImage *image=[UIImage imageWithContentsOfFile:[array objectAtIndex:i]];
        
        CGSize size;
        size.width =  300;
        size.height = 400;
        
        UIGraphicsBeginImageContext(size);  
        // 绘制改变大小的图片  
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];  
        // 从当前context中创建一个改变大小后的图片  
        UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();  
        // 使当前的context出堆栈  
        UIGraphicsEndImageContext();
        
        
		ascrView.image = scaledImage;
		ascrView.tag = 100+i;
		
		[scrView addSubview:ascrView];
	}
	
	lastPage = 0;
    scrView.contentSize = CGSizeMake(340*[array count], 480);
	scrView.showsHorizontalScrollIndicator = NO;
}

#pragma mark -
#pragma mark === UIScrollView Delegate ===
#pragma mark -
//ScrollView 划动的动画结束后调用.
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	CGFloat pageWidth = scrollView.frame.size.width;
	NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

	if (lastPage != page) 
	{
		MyScrollView *aView = (MyScrollView *)[scrView viewWithTag:100+lastPage];
		aView.zoomScale = 1.0;
		
		lastPage = page;
	}
}

#pragma mark -
#pragma mark === UIViewController Delegate ===
#pragma mark -
- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
	scrView = nil;
}


@end
