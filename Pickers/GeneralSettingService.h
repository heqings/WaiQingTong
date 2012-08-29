//
//  GeneralSettingService.h
//  Pickers
//
//  Created by  on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"
@interface GeneralSettingService : ConnectionDataBase
{
    
}
+(GeneralSettingService *)getConnection;
-(NSMutableDictionary*)getGeneralSetting;
-(void)updateGeneralSetting:(NSDictionary*)dict;
-(void)insertGeneralSetting:(NSDictionary*)dic;
-(void)clearGeneralSetting;
@end
