//
//  JsonPlaceServer.h
//  Pickers
//
//  Created by 张飞 on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"
#import "User.h"
#import "Global.h"
#import "JSON.h"
#import "NetUtils.h"
#import "AppGlobalServices.h"
#import "MBProgressHUD.h"

@interface JsonPlaceServer : NSObject<UIAlertViewDelegate>

+(NSArray*)getCompanGates:(User*)user;

+(void)downloadUserTopImage:(NSString*)fileName;
@end
