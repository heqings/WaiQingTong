//
//  ImageViewForScrollView.m
//  SuningEMall
//
//  Created by Wang Jia on 11-1-10.
//  Copyright 2011 IBM. All rights reserved.
//

#import "ImageViewForScrollView.h"


@implementation ImageViewForScrollView

@synthesize displayHost,imageDidTouched;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
   
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if(self.displayHost != nil && [self.displayHost respondsToSelector:self.imageDidTouched])
		[self.displayHost performSelectorOnMainThread:self.imageDidTouched withObject:self waitUntilDone:NO];
}


@end
