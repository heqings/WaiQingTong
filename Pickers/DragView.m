//
//  DragView.m
//  Pickers
//
//  Created by air macbook on 12-2-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DragView.h"

#define MAXZOOM 2.0f
#define MINZOOM 0.5f

@interface UITouch (TouchSorting)
- (NSComparisonResult)compareAddress:(id)obj;
@end

@implementation UITouch (TouchSorting)
- (NSComparisonResult)compareAddress:(id) obj 
{
    if ((__bridge void *)self < (__bridge void *)obj) return NSOrderedAscending;
    else if ((__bridge void *)self == (__bridge void *)obj) return NSOrderedSame;
	else return NSOrderedDescending;
}
@end

@implementation DragView 

- (id) initWithImage: (UIImage *) anImage
{
	if (self = [super initWithImage:anImage])
	{
		self.userInteractionEnabled = YES;
		self.multipleTouchEnabled = YES;
		self.exclusiveTouch = NO;
		originalSize = anImage.size;
		originalTransform = CGAffineTransformIdentity;
		touchBeginPoints = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
	}
	return self;
}


//计算单点或多点触摸的坐标点换算
- (CGAffineTransform)incrementalTransformWithTouches:(NSSet *)touches 
{
	// 多个touch数组
    NSArray *sortedTouches = [[touches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];
    NSInteger numTouches = [sortedTouches count];
	
	// 单点时，图片移动
	if (numTouches == 1) {
        
        UITouch *touch = [sortedTouches objectAtIndex:0];
        CGPoint beginPoint = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints, (__bridge void *) touch);
        CGPoint currentPoint = [touch locationInView:self.superview];
		return CGAffineTransformMakeTranslation(currentPoint.x - beginPoint.x, currentPoint.y - beginPoint.y);
	}
	
	// 多点触摸
	UITouch *touch1 = [sortedTouches objectAtIndex:0];
	UITouch *touch2 = [sortedTouches objectAtIndex:1];
	
    CGPoint beginPoint1 = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints, (__bridge void *)touch1);
    CGPoint currentPoint1 = [touch1 locationInView:self.superview];
    CGPoint beginPoint2 = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints, (__bridge void *)touch2);
    CGPoint currentPoint2 = [touch2 locationInView:self.superview];
	
	double layerX = self.center.x;
	double layerY = self.center.y;
	
	double x1 = beginPoint1.x - layerX;
	double y1 = beginPoint1.y - layerY;
	double x2 = beginPoint2.x - layerX;
	double y2 = beginPoint2.y - layerY;
	double x3 = currentPoint1.x - layerX;
	double y3 = currentPoint1.y - layerY;
	double x4 = currentPoint2.x - layerX;
	double y4 = currentPoint2.y - layerY;
	
	double D = (y1-y2)*(y1-y2) + (x1-x2)*(x1-x2);
	if (D < 0.1) {
        return CGAffineTransformMakeTranslation(x3-x1, y3-y1);
    }
	
	double a = (y1-y2)*(y3-y4) + (x1-x2)*(x3-x4);
    
    return CGAffineTransformMake(a/D, 0.0f, 0.0f, a/D, 0.0f, 0.0f);
}

//触摸开始时创建缓存
- (void)cacheBeginPointForTouches:(NSSet *)touches 
{
	for (UITouch *touch in touches) {
		CGPoint *point = (CGPoint *)CFDictionaryGetValue(touchBeginPoints, (__bridge void *)touch);
		if (point == NULL) {
			point = (CGPoint *)malloc(sizeof(CGPoint));
			CFDictionarySetValue(touchBeginPoints, (__bridge void *)touch, point);
		}
		*point = [touch locationInView:self.superview];
	}
}

//触摸完后清除缓存
- (void)removeTouchesFromCache:(NSSet *)touches 
{
    for (UITouch *touch in touches) {
        CGPoint *point = (CGPoint *)CFDictionaryGetValue(touchBeginPoints, (__bridge void *)touch);
        if (point != NULL) {
            free((void *)CFDictionaryGetValue(touchBeginPoints, (__bridge void *)touch));
            CFDictionaryRemoveValue(touchBeginPoints, (__bridge void *)touch);
        }
    }
}

//判断图片缩放时，限制宽度和高度缩放比例
- (void) setConstrainedTransform: (CGAffineTransform) aTransform
{
	self.transform = aTransform;
	CGAffineTransform concat;
	CGSize asize = self.frame.size;
	
	if (asize.width > MAXZOOM * originalSize.width)
	{
		concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeScale((MAXZOOM * originalSize.width / asize.width), 1.0f));
		self.transform = concat;
	}
	else if (asize.width < MINZOOM * originalSize.width)
	{
		concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeScale((MINZOOM * originalSize.width / asize.width), 1.0f));
		self.transform = concat;
	}
	if (asize.height > MAXZOOM * originalSize.height)
	{
		concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeScale(1.0f, (MAXZOOM * originalSize.height / asize.height)));
		self.transform = concat;
	}
	else if (asize.height < MINZOOM * originalSize.height)
	{
		concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeScale(1.0f, (MINZOOM * originalSize.height / asize.height)));
		self.transform = concat;
	}
    
}

//更新图片宽度高度
- (void)updateOriginalTransformForTouches:(NSSet *)touches 
{
    if ([touches count] > 0) {
        CGAffineTransform incrementalTransform = [self incrementalTransformWithTouches:touches];
        [self setConstrainedTransform:CGAffineTransformConcat(originalTransform, incrementalTransform)];
		originalTransform = self.transform;
    }
}

//触摸点击屏幕时
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	[[self superview] bringSubviewToFront:self];
    NSMutableSet *currentTouches = [[event touchesForView:self] mutableCopy];
    [currentTouches minusSet:touches];
    if ([currentTouches count] > 0) {
        [self updateOriginalTransformForTouches:currentTouches];
        [self cacheBeginPointForTouches:currentTouches];
    }
    [self cacheBeginPointForTouches:touches];
}

//触摸点击屏幕移动时
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    CGAffineTransform incrementalTransform = [self incrementalTransformWithTouches:[event touchesForView:self]];
	[self setConstrainedTransform:CGAffineTransformConcat(originalTransform, incrementalTransform)];
}

//触摸点击屏幕完成时
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [self updateOriginalTransformForTouches:[event touchesForView:self]];
    [self removeTouchesFromCache:touches];
	
    for (UITouch *touch in touches) {
        if (touch.tapCount >= 2) {
            [self.superview bringSubviewToFront:self];
        }
    }
	
    NSMutableSet *remainingTouches = [[event touchesForView:self] mutableCopy];
    [remainingTouches minusSet:touches];
    [self cacheBeginPointForTouches:remainingTouches];
}

//触摸点击屏幕取消
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [self touchesEnded:touches withEvent:event];
}

- (void)dealloc {
	if (touchBeginPoints) CFRelease(touchBeginPoints);
}

@end
