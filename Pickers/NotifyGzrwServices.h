//
//  NotifyGzrwServices.h
//  Pickers
//
//  Created by 张飞 on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"
#import "NotifyGzrw.h"

@interface NotifyGzrwServices : ConnectionDataBase{
    
}
+(NotifyGzrwServices *)getConnection;

-(void)insertNotifySq:(NSInteger)peopleId ntId:(NSInteger)ntId spId:(NSInteger)spId ngTitle:(NSString *)ngTitle ngContent:(NSString *)ngContent ngCreateDate:(NSString *)ngCreateDate ngLevel:(NSString *)ngLevel status:(NSString *)status finishTime:(NSString *)finishTime createUser:(NSString *)createUser remarkUser:(NSString *)remarkUser remarkContent:(NSString *)remarkContent;

-(NSMutableArray *)findAll;

-(void)updateByParam:(NSInteger)spId rlTime:(NSString *)rlTime status:(NSString *)status;
-(void)updateByParam:(NSInteger)spId remarkUser:(NSString *)remarkUser remarkContent:(NSString *)remarkContent status:(NSString *)status;
-(void)deleteByNtId:(NSInteger)ntId;
@end
