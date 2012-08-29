//
//  NotifyServices.h
//  Pickers
//
//  Created by 张飞 on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"
#import "Notify.h"

@interface NotifyServices : ConnectionDataBase{
    
}
+(NotifyServices *)getConnection;

-(void)insertNotify:(NSString *)ntTitle isRead:(NSString *)isRead readCount:(NSInteger)readCount ntDate:(NSString *)ntDate toUser:(NSString *)toUser groupId:(NSString *)groupId ntType:(NSString*)ntType detailText:(NSString *)detailText;
-(NSMutableArray *)findAll;
-(void)deleteById:(NSInteger)ntId;
-(void)updateById:(NSInteger)ntId readCount:(NSInteger)readCount detailText:(NSString*)detailText ntDate:(NSString*)ntDate;
-(void)updateById:(NSInteger)ntId readCount:(NSInteger)readCount;
-(Notify *)findById:(NSInteger)ntId;
-(Notify *)findByGroup:(NSString *)groupId;
-(Notify *)findByParam:(NSString *)field param:(NSString *)param;
-(void)updateDetailText:(NSString *)detailText type:(NSString*)type;
-(void)updateToUser:(NSInteger)ntId toUser:(NSString*)toUser;
@end
