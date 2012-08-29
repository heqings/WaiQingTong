//
//  NotifiWork.h
//  Pickers
//
//  Created by 张飞 on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "NotifyGzrzServices.h"
#import "NotifyGzrz.h"
#import "Notify.h"
#import "NotifyServices.h"
#import "Global.h"
#import "NotifyGzrzServices.h"
#import "PeopleServices.h"
#import <AudioToolbox/AudioToolbox.h>

@interface NotifyWork : NSObject

+(void)runNotifyWork:(NSDictionary *)dic;

@end
