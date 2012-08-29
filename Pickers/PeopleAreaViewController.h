
//
//  PeopleAreaViewController.h
//  Pickers
//
//  Created by  on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "People.h"
@interface PeopleAreaViewController : UITableViewController
{
    NSArray* mainData;
    NSArray* areaData;
}
-(UIImage*)getPeopleTopImage:(People*)p;
@property (atomic,strong)  NSArray* areaData;
@property (atomic,strong)  NSArray* mainData;
@end

