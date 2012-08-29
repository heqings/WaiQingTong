//
//  MyScrollView.h
//  PhotoBrowserEx
//
//  Created by  on 10-6-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyScrollView : UIScrollView <UIScrollViewDelegate>
{
	UIImage *image;
	UIImageView *imageView;
}

@property (nonatomic, retain) UIImage *image;

@end
