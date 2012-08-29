//
//  SignInService.h
//  Pickers
//
//  Created by  on 12-5-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"
#import "SignIn.h"
@interface SignInService : ConnectionDataBase
+(SignInService *)getConnection;

-(void)insertSignIn:(SignIn*)si;
-(NSMutableArray *)findAll;
@end
