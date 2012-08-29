//
//  JsonClientServer.h
//  Pickers
//
//  Created by 张飞 on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Global.h"
#import "Client.h"
#import "JSON.h"
#import "NetUtils.h"
#import "ClientInfo.h"
#import "ClientInfoServices.h"

@interface JsonClientServer : NSObject

+(NSArray*)getCompanGates:(User*)user isShow:(BOOL)isShow;
@end
