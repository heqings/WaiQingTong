//
//  GeneralSettingController.h
//  Pickers
//
//  Created by  on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoSelectController.h"
@interface GeneralSettingController : UITableViewController<InfoSelectProtocl>
{
    NSDictionary* myData;
    UILabel* labelImageQuality;
    NSArray* imageQualityData;
    NSDictionary* field;
}
-(void)goBack;
-(void)switchAction:(id)control;
@property (strong,atomic)  NSArray* imageQualityData;

@end
