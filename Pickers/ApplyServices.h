//
//  ApplyServices.h
//  Pickers
//
//  Created by air macbook on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"
#import "Apply.h"

@interface ApplyServices : ConnectionDataBase{
    
}

+(ApplyServices *)getConnection;

-(void)insertApply:(NSString *)type content:(NSString *)content applyTime:(NSString *)applytime status:(NSString *)status;

-(void)deleteById:(NSInteger)appId;

-(NSMutableArray *)findAll;
@end
