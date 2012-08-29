//
//  ImageViewForScrollView.h
//  SuningEMall
//
//  Created by Wang Jia on 11-1-10.
//  Copyright 2011 IBM. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageViewForScrollView : UIImageView {
	NSObject	*displayHost;
	SEL		imageDidTouched;
}

@property (nonatomic, strong) NSObject *displayHost;
@property (nonatomic, assign) SEL	imageDidTouched;

@end
