//
//  JsonSocket.m
//  Pickers
//
//  Created by HeQing on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JsonSocket.h"
#import "User.h"
#import "Global.h"
#import "JSON.h"
@implementation JsonSocket
-(id)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}
-(void)connectedSocket{
        BOOL connectOK = NO;
           
            NSError *error;
            connectOK = [self connectToHost: [Global getServerIp] onPort: [Global getServerPort] error: &error];
            
            if (!connectOK){
                NSException* e  = [NSException exceptionWithName:@"SocketException" reason:error.description
                                   
                                                        userInfo:nil];
                @throw e;
                
            }
            [self setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}

-(void)loginSocket
{
    
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if(user!=nil){
        NSDictionary *dic=[
                           [NSDictionary alloc] 
                           initWithObjects:
                           [NSArray arrayWithObjects:@"",@"",@"",@"",@"",[Global getOAUTH],user.imei,nil]
                           forKeys:
                           [NSArray arrayWithObjects:@"body",@"len",@"id",@"to",@"date",@"type",@"fm",nil]
                           ];
        
        NSString *json=[[dic JSONRepresentation] stringByAppendingFormat:@"eof"];  
        NSData *newData=[json dataUsingEncoding: NSUTF8StringEncoding];
     
        [self writeData: newData withTimeout: -1 tag: 0];
        
    }
  

}
@end
