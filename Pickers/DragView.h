//
//  DragView.h
//  Pickers
//
//  Created by air macbook on 12-2-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DragView : UIImageView{
    CGPoint startLocation;
	CGSize originalSize;
	CGAffineTransform originalTransform;
    CFMutableDictionaryRef touchBeginPoints;
}

@end
