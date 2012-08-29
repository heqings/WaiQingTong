//
//  ClientInfoServices.h
//  Pickers
//
//  Created by 张飞 on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"
#import "ClientInfo.h"

@interface ClientInfoServices : ConnectionDataBase

+(ClientInfoServices *)getConnection;

-(void)insertClientInfo:(ClientInfo *)info;

-(NSMutableArray *)findAll;

-(NSMutableArray *)findByCId:(NSInteger)cId;

-(void)clearClientInfo;
@end
