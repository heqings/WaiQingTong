//
//  NotifyAudit.h
//  Pickers
//
//  Created by 张飞 on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "JSON.h"
#import "NotifySqServices.h"
#import "NotifySq.h"
#import "Notify.h"
#import "NotifyServices.h"
#import "Global.h"
#import "People.h"
#import "PeopleServices.h"

@interface NotifyAudit : NSObject

+(void)runNotifyAudit:(NSDictionary *)dic;
@end
