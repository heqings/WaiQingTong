//
//  InitDataServer.h
//  Pickers
//
//  Created by air macbook on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"

@interface InitDataServer : ConnectionDataBase{
    
}
+(InitDataServer *)getConnection;

-(void)initAttendance;

-(void)initWorklog;

-(void)initApply;

-(void)initNotify;

-(void)initNotifyInfo;

-(void)initUser;

-(void)initGeneralSetting;

-(void)initPeople;

-(void)clearAllData;

-(void)initAppGlobal;

-(void)initNotifyGzrz;

-(void)initNotifyTz;

-(void)initNotifySq;

-(void)initNotifyGzrw;

-(void)initNotifyPlan;

-(void)initNotifyPoi;

-(void)initPoiInfo;

-(void)initPoiHistory;

-(void)initSignIn;

-(void)initPlace;

-(void)initClient;

-(void)initClientInfo;
@end
