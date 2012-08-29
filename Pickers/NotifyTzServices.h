//
//  NotifyTzServices.h
//  Pickers
//
//  Created by 张飞 on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"
#import "NotifyTzE.h"

@interface NotifyTzServices : ConnectionDataBase{
    
}
+(NotifyTzServices *)getConnection;

-(void)insertNotifyTz:(NSInteger)peopleId ntId:(NSInteger)ntId spId:(NSInteger)spId nteContent:(NSString *)nteContent nteCreateDate:(NSString *)nteCreateDate nteCreateUser:(NSString *)nteCreateUser ntTitle:(NSString *)ntTitle;
-(NSMutableArray *)findAll;
-(void)deleteByNtId:(NSInteger)ntId;
@end
