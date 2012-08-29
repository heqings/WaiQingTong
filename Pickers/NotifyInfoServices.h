//
//  NotifyInfoServices.h
//  Pickers
//
//  Created by 张飞 on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"
#import "NotifyInfo.h"

@interface NotifyInfoServices : ConnectionDataBase

+(NotifyInfoServices *)getConnection;
-(void)insertNotifyInfo:(NSInteger)ntId peopelId:(NSInteger)peopelId niType:(NSString *)niType niName:(NSString *)niName niPath:(NSString *)niPath niStatus:(NSString *)niStatus niDate:(NSString *)niDate isRead:(NSString *)isRead isMySpeaking:(NSString *)isMySpeaking niContent:(NSString *)niContent recordTime:(NSString *)recordTime;

-(NSMutableArray *)findAll:(NSInteger)ntId;

-(void)deleteByNtId:(NSInteger)ntId;
@end
