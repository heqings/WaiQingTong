//
//  NotifyPlanServices.h
//  Pickers
//
//  Created by 张飞 on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"
#import "NotifyPlanE.h"

@interface NotifyPlanServices : ConnectionDataBase{
    
}
+(NotifyPlanServices *)getConnection;
-(void)insertNotifyPlan:(NotifyPlanE *)notifyPlanE;
-(NSMutableArray *)findAll;
-(NotifyPlanE *)findBySpId:(NSInteger)spId;
-(void)clearAll;
@end
