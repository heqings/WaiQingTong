//
//  NotifyGzrzServices.h
//  Pickers
//
//  Created by 张飞 on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"
#import "NotifyGzrz.h"

@interface NotifyGzrzServices : ConnectionDataBase{
    
}

+(NotifyGzrzServices *)getConnection;

-(void)insertNotifyGzrz:(NSInteger)peopleId ntId:(NSInteger)ntId spId:(NSInteger)spId ngContent:(NSString *)ngContent ngCreateDate:(NSString *)ngCreateDate ngRemarkContent:(NSString *)ngRemarkContent ngRemarkPeople:(NSString *)ngRemarkPeople status:(NSString *)status ngType:(NSString *)ngType;

-(NSMutableArray *)findAll;
-(NotifyGzrz *)findByParam:(NSString *)field param:(NSInteger)param;
-(void)updateByParam:(NSInteger)spId ngRemarkContent:(NSString *)ngRemarkContent ngRemarkPeople:(NSString *)ngRemarkPeople status:(NSString *)status ngRemarkTime:(NSString *)ngRemarkTime;

-(void)deleteByNtId:(NSInteger)ntId;
@end
