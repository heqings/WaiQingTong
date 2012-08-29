//
//  ClientServices.h
//  Pickers
//
//  Created by 张飞 on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"
#import "Client.h"


@interface ClientServices : ConnectionDataBase

+(ClientServices *)getConnection;

-(void)insertClient:(Client*)client;

-(NSMutableArray *)findAll;

-(Client *)findByCustomId:(NSInteger)customId;

-(void)clearClient;
@end
