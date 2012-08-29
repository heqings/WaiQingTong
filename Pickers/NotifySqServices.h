//
//  NotifySqServices.h
//  Pickers
//
//  Created by 张飞 on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"
#import "NotifySq.h"

@interface NotifySqServices : ConnectionDataBase{
    
}
+(NotifySqServices *)getConnection;

-(void)insertNotifySq:(NSInteger)peopleId ntId:(NSInteger)ntId spId:(NSInteger)spId nsContent:(NSString *)nsContent nsCreateDate:(NSString *)nsCreateDate nsRemarkPeople:(NSString *)nsRemarkPeople nsRemarkContent:(NSString *)nsRemarkContent status:(NSString *)status nsType:(NSString *)nsType;

-(NSMutableArray *)findAll;
-(NotifySq *)findByParam:(NSString *)field param:(NSInteger)param;
-(void)updateByParam:(NSInteger)spId nsRemarkContent:(NSString *)nsRemarkContent nsRemarkPeople:(NSString *)nsRemarkPeople status:(NSString *)status nsRemarkTime:(NSString *)nsRemarkTime nsRemarkType:(NSString *)nsRemarkType;
-(void)deleteById:(NSInteger)spId;
-(void)deleteByNtId:(NSInteger)ntId;
@end
