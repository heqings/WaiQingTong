//
//  JsonPlaceServer.m
//  Pickers
//
//  Created by 张飞 on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JsonPlaceServer.h"

@implementation JsonPlaceServer


+ (void)alertWithMassage:(NSString *)tMessage
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:tMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

+(NSArray*)getCompanGates:(User*)user{
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
    NSData *returnData=[NetUtils synPostData:postBody method:@"area/getterminal"];
    NSString *retrunVal = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSDictionary *result= [retrunVal JSONValue];
    
    NSMutableArray *places = [NSMutableArray arrayWithCapacity:10];
    
    if([[result objectForKey:@"result"]isEqualToString:@"success"]){
        for(int j=0;j<[pyArray count];j++){
            NSArray *array=[[result objectForKey:@"data"]objectForKey:[pyArray objectAtIndex:j]];
            if([array count]>0){
                for(int i=0;i<[array count];i++){
                    Place* p = [[Place alloc]init ];
                    p.name =[[array objectAtIndex:i]objectForKey:@"name"];
                    p.spId =[[[array objectAtIndex:i]objectForKey:@"id"] intValue];
                    p.imei =[[array objectAtIndex:i]objectForKey:@"imei"];
                    p.namePinyin =[[array objectAtIndex:i]objectForKey:@"namePinyin"];
                    p.nicke =[[array objectAtIndex:i]objectForKey:@"nicke"];
                    p.nickPinyin =[[array objectAtIndex:i]objectForKey:@"nickPinyin"];
                    p.topimg =[[array objectAtIndex:i]objectForKey:@"topimg"];
                    p.type =[[array objectAtIndex:i]objectForKey:@"type"];
                    p.email =[[array objectAtIndex:i]objectForKey:@"email"];
                    p.mobile =[[array objectAtIndex:i]objectForKey:@"mobile"];
                    p.groupPy = [pyArray objectAtIndex:j] ;
                    p.groupDp = @"";
                    [places addObject:p];
                }
            }
        }
    }else{
        [self alertWithMassage:@"没有权限查看人员位置！"];
    }
    return places;
}


+(void)downloadUserTopImage:(NSString*)fileName{
    
    AppGlobalServices* gns = [AppGlobalServices getConnection];
    NSDictionary* ds =  [gns findAll];
    
    NSString* imgURL=[ds valueForKey:@"t_downloadtopimgurl"];
    NSString *action  = [NSString stringWithFormat:@"%@%@",imgURL,fileName];
    
    NSData * retrunData=[NetUtils synGetHttpFile:action];
    fileName= [fileName lastPathComponent];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    [retrunData writeToFile:imagePath atomically:false];
}

@end
