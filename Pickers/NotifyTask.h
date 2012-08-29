//
//  NotifyGzrw.h
//  Pickers
//
//  Created by 张飞 on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotifyServices.h"
#import "Global.h"
#import "JSON.h"
#import "NotifyGzrwServices.h"
#import <AudioToolbox/AudioToolbox.h>

@interface NotifyTask : NSObject

+(void)runNotifyTask:(NSDictionary *)dic;
@end
