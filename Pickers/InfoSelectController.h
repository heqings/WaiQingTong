//
//  InfoSelectController.h
//  Pickers
//
//  Created by  on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol InfoSelectProtocl <NSObject>      
- (void)onSelectItem:(NSDictionary*)data Tag:(int)tag;      
@end  
@interface InfoSelectController : UITableViewController
{
    NSArray* myData;
    int currentIndex;
    id <InfoSelectProtocl> myDelegate; 
    int tag;

}
@property (strong,atomic)  NSArray* myData;
@property (readwrite,atomic) int currentIndex;
@property (strong,atomic)  id <InfoSelectProtocl> myDelegate;
@property (readwrite,atomic) int tag;
@end
