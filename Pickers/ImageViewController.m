//
//  ImageViewController.m
//  Pickers
//
//  Created by air macbook on 12-2-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageViewController.h"
#import "DragView.h"

@implementation ImageViewController
@synthesize url;

-(UIImage*)scaleToSize:(CGSize)size forImage:(UIImage *) img 
{  
    CGFloat width = img.size.width;
    CGFloat height = img.size.height;  
    
    float verticalRadio = size.height*1.0/height;   
    float horizontalRadio = size.width*1.0/width;  
    
    float radio = 1;  
    if(verticalRadio>1 && horizontalRadio>1)  
    {  
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;     
    }  
    else  
    {  
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;     
    }  
    
    width = width*radio;  
    height = height*radio;  
    
    //int xPos = (size.width - width)/2;  
    int yPos = (size.height-height)/2;  
    
    // 创建一个bitmap的context    
    // 并把它设置成为当前正在使用的context    
    UIGraphicsBeginImageContext(size);    
    
    // 绘制改变大小的图片    
    [img drawInRect:CGRectMake(10, yPos-70, width, height+60)];    
    
    // 从当前context中创建一个改变大小后的图片    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();    
    
    // 使当前的context出堆栈    
    UIGraphicsEndImageContext();    
    
    // 返回新的改变大小后的图片    
    return scaledImage;  
} 

- (void) viewDidLoad
{
    self.navigationItem.title=@"图片预览";
    UIImage *image=[UIImage imageWithContentsOfFile:url];
	DragView *dragger = [[DragView alloc] initWithImage:image];
    dragger.frame=CGRectMake(0, 0, 320, 460);
	dragger.userInteractionEnabled = YES;
	[self.view addSubview:dragger];
}


@end
