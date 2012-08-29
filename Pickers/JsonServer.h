//
//  JsonServer.h
//  Pickers
//
//  Created by  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "People.h"
#import "SignIn.h"
@interface JsonServer : NSObject
+(NSDictionary*)updateUserInfoToServer:(User*)ds;
+(NSDictionary*)getUserInfo:(NSString*)imei Key:(NSString*)key;
+(void)uploadUserTopImage:(User*)user;
+(NSDictionary*)loginUser:(NSDictionary*)dic;
+(void)downloadUserTopImage:(NSString*)fileName;
+(NSDictionary*)registerUser:(NSDictionary*)dic;
+(NSArray*)getCompanGates:(User*)user;
+(NSDictionary*)getAreajson:(NSString*)imei key:(NSString*)key;
+(NSDictionary *)getOffline:(NSString*)imei key:(NSString*)key;
+(void)saveSignIn:(User*)user signIn:(SignIn*)signIn;
+(NSDictionary*)updateVisitstatus:(User*)user np_id:(int)np_id;
+(NSDictionary*)sumitattendance:(User*)user lat:(float)lat lng:(float)lng address:(NSString*)address;
+(NSDictionary*)getpoiByVisitPoiId:(NSDictionary*)dic;
@end
