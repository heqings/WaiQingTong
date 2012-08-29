//
//  NotifyPlan.h
//  Pickers
//
//  Created by 张飞 on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "NotifyPlanServices.h"
#import "NotifyServices.h"
#import "Notify.h"
#import "PeopleServices.h"
#import "People.h"
#import "NetUtils.h"
#import "NotifyPlanE.h"
#import "MBProgressHUD.h"
#import "Client.h"
#import "ClientInfo.h"
#import "ClientServices.h"
#import "ClientInfoServices.h"
#import "JSON.h"


@interface NotifyPlan : NSObject

+(void)runNotifyPlan:(NSDictionary *)dic;
@end
