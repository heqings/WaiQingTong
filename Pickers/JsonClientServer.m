//
//  JsonClientServer.m
//  Pickers
//
//  Created by 张飞 on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JsonClientServer.h"

@implementation JsonClientServer

+ (void)alertWithMassage:(NSString *)tMessage
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:tMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

+(NSArray*)getCompanGates:(User*)user isShow:(BOOL)isShow{
    NSArray* pyArray=[NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    NSDictionary *dic=[
                       [NSDictionary alloc] 
                       initWithObjects:
                       [NSArray arrayWithObjects:user.imei,[Global getKey],nil]
                       forKeys:[NSArray arrayWithObjects:@"imei",@"key",nil]
                       ];
    
    
    NSString *json=[dic JSONRepresentation];
    NSMutableData *postBody = [NSMutableData data];
    NSString *param =[NSString stringWithFormat:@"param=%@",json];
    [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]]; 
    NSData *returnData=[NetUtils synPostData:postBody method:@"custom/getcustom"];
    NSString *retrunVal = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSDictionary *result= [retrunVal JSONValue];
    
    NSMutableArray *clients = [NSMutableArray arrayWithCapacity:10];
    
    if([[result objectForKey:@"result"]isEqualToString:@"success"]){
        for(int j=0;j<[pyArray count];j++){
            NSArray *array=[[result objectForKey:@"data"]objectForKey:[pyArray objectAtIndex:j]];
            if([array count]>0){
                for(int i=0;i<[array count];i++){
     
                    Client *c = [[Client alloc]init];
                    c.createtime =[[array objectAtIndex:i]objectForKey:@"createtime"];
                    c.customId =[[[array objectAtIndex:i]objectForKey:@"customId"] intValue];
                    c.faxphone =[[array objectAtIndex:i]objectForKey:@"faxphone"];
                    c.email =[[array objectAtIndex:i]objectForKey:@"email"];
                    c.address =[[array objectAtIndex:i]objectForKey:@"address"];
                    c.namePinyin =[[array objectAtIndex:i]objectForKey:@"namePinyin"];
                    c.uri =[[array objectAtIndex:i]objectForKey:@"uri"];
                    c.telphone =[[array objectAtIndex:i]objectForKey:@"telphone"];
                    c.name=[[array objectAtIndex:i]objectForKey:@"name"];
                    c.groupPy = [pyArray objectAtIndex:j] ;
                    
                
                    NSArray *linkMans=[[array objectAtIndex:i]objectForKey:@"linkmanList"];
                    for(int j=0;j<[linkMans count];j++){
                        ClientInfo *info=[[ClientInfo alloc]init];
                        info.linkmobile=[[linkMans objectAtIndex:j] objectForKey:@"linkmobile"];
                        info.officetel=[[linkMans objectAtIndex:j] objectForKey:@"officetel"];
                        info.remark=[[linkMans objectAtIndex:j] objectForKey:@"remark"];
                        info.email=[[linkMans objectAtIndex:j] objectForKey:@"email"];
                        info.linkname=[[linkMans objectAtIndex:j] objectForKey:@"linkname"];
                        info.spId=[[[linkMans objectAtIndex:j] objectForKey:@"id"] intValue];
                        info.cId=[[[array objectAtIndex:i]objectForKey:@"customId"] intValue];
                        
                        ClientInfoServices *conn=[ClientInfoServices getConnection];
                        [conn insertClientInfo:info];
                    }
                
                    [clients addObject:c];
                }
            }
        }
    }else{
        if(isShow){
            [self alertWithMassage:@"没有权限查看客户资料！"];
        }
    }
    return clients;
    
}
@end
