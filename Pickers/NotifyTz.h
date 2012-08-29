//
//  NotifyTz.h
//  Pickers
//
//  Created by 张飞 on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Notify.h"
#import "NotifyServices.h"
#import "JSON.h"
#import "NotifyTzServices.h"
#import "Global.h"
#import <AudioToolbox/AudioToolbox.h>

@interface NotifyTz : NSObject

+(void)runNotifyTz:(NSDictionary *)dic;
@end
