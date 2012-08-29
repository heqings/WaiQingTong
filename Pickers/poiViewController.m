//
//  poiViewController.m
//  Pickers
//
//  Created by 张飞 on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "poiViewController.h"
#import "NotifyPoiServices.h"
#import "JsonServer.h"
@implementation poiViewController
@synthesize table,cellsDataArray,longitude,latitude;



-(void)viewDidLoad{
    self.navigationItem.title=@"签到信息";
    cellsDataArray=[[NSMutableArray alloc]init];
    
    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"正在查询..." animated:NO];
    NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    NSDictionary *dic=[
                       [NSDictionary alloc] 
                       initWithObjects:
                       [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f",latitude],[NSString stringWithFormat:@"%f",longitude],[Global getKey],user.imei,nil]
                       forKeys:[NSArray arrayWithObjects:@"OLat",@"OLng",@"key",@"imei",nil]
                       ];
    
    NSString *json=[dic JSONRepresentation];
    NSMutableData *postBody = [NSMutableData data];
    NSString *param =[NSString stringWithFormat:@"param=%@",json];
    [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]];
    
    [[NetUtils shareNetworkHelper] requestDataFromURL:@"poi/findpoibylatg" withParams:postBody withHelperDelegate:self withSuccessRequestMethod:@"requestSuccess:" withFaildRequestMethod:@"requestFaild:" contentType:NO];
    
    [super viewDidLoad];
}

-(void)viewDidUnload{
    [super viewDidUnload];

    table=nil;
    cellsDataArray=nil;  
}

- (void)alertWithMassage:(NSString *)tMessage
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:tMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)requestSuccess:(NSObject*)result{
    NSDictionary *resultDict = (NSDictionary *)result;
    if([[resultDict objectForKey:@"result"]isEqualToString:@"success"]){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSMutableArray *array=[resultDict objectForKey:@"data"];
        if([array count]>0){    
            for(int i=0;i<[array count];i++){
                PoiInfo *poi=[[PoiInfo alloc]init];
                poi.spId=[[[array objectAtIndex:i]objectForKey:@"id"] intValue];
                poi.poiType=[[array objectAtIndex:i]objectForKey:@"type"];
                poi.poiName=[[array objectAtIndex:i]objectForKey:@"name"];
                poi.poiAddress=[[array objectAtIndex:i]objectForKey:@"address"];
                poi.OLng=[[[array objectAtIndex:i]objectForKey:@"OLng"] doubleValue];
                poi.OLat=[[[array objectAtIndex:i]objectForKey:@"OLat"] doubleValue];
                [cellsDataArray addObject:poi];
            }
        }
        [table reloadData];
        
    }else{
        [self alertWithMassage:[resultDict objectForKey:@"msg"]];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)requestFaild:(NSObject*)result
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cellsDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  
    PoiInfo *poi=(PoiInfo *)[cellsDataArray objectAtIndex:indexPath.row];
    UIImage *image;           
    if([poi.poiType isEqualToString:@"KH"]){//客户
        image = [UIImage imageNamed:@"icon_kh"];
        
        UIFont *font = [UIFont systemFontOfSize:13];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(215,-5, 80, 30)];
        label.backgroundColor=[UIColor clearColor];
        label.text=[NSString stringWithFormat:@"[客户]"];
        label.textColor=[UIColor blueColor];
        [label setFont:font];
        [cell addSubview:label];
        
    }else if([poi.poiType isEqualToString:@"MD"]){//门店
        image = [UIImage imageNamed:@"icon_qy"];
        
        UIFont *font = [UIFont systemFontOfSize:13];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(215, -5, 80, 30)];
        label.backgroundColor=[UIColor clearColor];
        label.text=[NSString stringWithFormat:@"[门店]"];
        label.textColor=[UIColor blueColor];
        [label setFont:font];
        [cell addSubview:label];
    }else if([poi.poiType isEqualToString:@"QD"]){//渠道
        image = [UIImage imageNamed:@"icon_qd"];
        
        UIFont *font = [UIFont systemFontOfSize:13];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(215, -5, 80, 30)];
        label.backgroundColor=[UIColor clearColor];
        label.text=[NSString stringWithFormat:@"[渠道]"];
        label.textColor=[UIColor blueColor];
        [label setFont:font];
        [cell addSubview:label];
    }else if([poi.poiType isEqualToString:@"QT"]){//其他
        image = [UIImage imageNamed:@"icon_qt"];
        
        UIFont *font = [UIFont systemFontOfSize:13];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(215, -5, 80, 30)];
        label.backgroundColor=[UIColor clearColor];
        label.text=[NSString stringWithFormat:@"[其他]"];
        label.textColor=[UIColor blueColor];
        [label setFont:font];
        [cell addSubview:label];
    }
     
    cell.imageView.image = image;
    
    UIFont *font = [UIFont systemFontOfSize:15];
    UIFont *font1 = [UIFont systemFontOfSize:12.5];
    
    [cell.textLabel setFont:font];
	[cell.textLabel setText:poi.poiName];
    [cell.detailTextLabel setFont:font1];
    [cell.detailTextLabel setText:poi.poiAddress];
    cell.detailTextLabel.frame=CGRectMake(0, 0, 240, 25);
    
    UIButton *btn=(UIButton *)[cell viewWithTag:currentPoi];
    if(btn!=nil){
        [btn removeFromSuperview];
    }
    
    
    PoiInfoServices *p=[PoiInfoServices getConnection];
    PoiInfo *poiInfo=[p findBySpId:poi.spId]; 
    
    double longNum=[Global DistanceOfTwoPoints:poi.OLng lat1:poi.OLat lng2:longitude lat2:latitude gs:nil];

    if(longNum>0){
        NSRange idsRange = NSMakeRange(0,5);
 
        UIFont *font2 = [UIFont systemFontOfSize:13];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(255, -4, 80, 30)];
        label.backgroundColor=[UIColor clearColor];
        label.text=[NSString stringWithFormat:@"%@米内",[[NSString stringWithFormat:@"%f",longNum] substringWithRange:idsRange]];
        label.textColor=[UIColor blueColor];
        [label setFont:font2];
        [cell addSubview:label];
    }

    if(poiInfo.spId==poi.spId){
        UIButton *qt=[[UIButton alloc]initWithFrame:CGRectMake(258, 22, 57, 30)];
        qt.tag=[indexPath row];
        [qt setTitle:@"签退" forState:UIControlStateNormal];
        [qt addTarget:self action:@selector(qtSaveClick:) forControlEvents:UIControlEventTouchUpInside];
        [qt setImage:[UIImage imageNamed:@"qiantui"] forState:UIControlStateNormal];
        [qt setImage:[UIImage imageNamed:@"qiantui_hover"] forState:UIControlStateHighlighted];
        [cell addSubview:qt];
    }else{
        UIButton *qd=[[UIButton alloc]initWithFrame:CGRectMake(258, 22, 57, 30)];
        qd.tag=[indexPath row];
        [qd setTitle:@"签到" forState:UIControlStateNormal];
        [qd addTarget:self action:@selector(qdSaveClick:) forControlEvents:UIControlEventTouchUpInside];
        [qd setImage:[UIImage imageNamed:@"qiandao"] forState:UIControlStateNormal];
        [qd setImage:[UIImage imageNamed:@"qiandao_hover"] forState:UIControlStateHighlighted];
        [cell addSubview:qd];
    }
    return cell;
}



//设置table行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.0f;
}

//点击表格行方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中行的颜色
}    

//签到事件
-(void)qdSaveClick:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"发送数据中.." animated:NO];
    UIButton *btn=(UIButton *)sender;
    
    PoiInfo *poi=[cellsDataArray objectAtIndex:btn.tag];
    currentPoi=btn.tag;
    NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    NSString *poiType;
    if([poi.poiType isEqualToString:@"KH"]){
        poiType=@"C";
    }else{
         poiType=@"P";
    }
    
    NSDictionary *dic=[
                       [NSDictionary alloc] 
                       initWithObjects:
                       [NSArray arrayWithObjects:[NSString stringWithFormat:@"%i",poi.spId],@"",[Global getKey],user.imei,poiType,nil]
                       forKeys:[NSArray arrayWithObjects:@"poiId",@"slId",@"key",@"imei",@"poiType",nil]
                       ];
    
    NSString *json=[dic JSONRepresentation];
    
    NSMutableData *postBody = [NSMutableData data];
    NSString *param =[NSString stringWithFormat:@"param=%@",json];
    [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]];
    
    [[NetUtils shareNetworkHelper] requestDataFromURL:@"singinlocus/savesinginlous" withParams:postBody withHelperDelegate:self withSuccessRequestMethod:@"qdSaveSuccess:" withFaildRequestMethod:@"qdSaveFaild:" contentType:NO];
}

- (void)qdSaveSuccess:(NSObject*)result{
    NSDictionary *resultDict = (NSDictionary *)result;

    if([[resultDict objectForKey:@"result"]isEqualToString:@"success"]){
        PoiInfo *p = (PoiInfo *)[cellsDataArray objectAtIndex:currentPoi];
        p.slId=[[[resultDict objectForKey:@"data"]objectForKey:@"slId"]intValue];
        p.createTime=[Global getCurrentTime];
        p.endTime=@"";
        PoiInfoServices *poi=[PoiInfoServices getConnection];
        [poi insertPoiInfo:p];
        
        PoiHistory *history=[[PoiHistory alloc]init];
        history.spId=p.spId;
        history.poiType=p.poiType;
        history.poiAddress=p.poiAddress;
        history.poiName=p.poiName;
        history.poiImgUrl=p.poiImgUrl;
        history.slId=p.slId;
        history.OLng=p.OLng;
        history.OLat=p.OLat;
        history.createTime=[Global getCurrentTime];
        history.endTime=@"";
        history.isFinish=@"N";
 
        [[PoiHistoryServices getConnection]insertPoiInfo:history];
        
        if([p.poiType isEqualToString:@"KH"]){
            NSString *visitIds=[[resultDict objectForKey:@"data"]objectForKey:@"visitId"];
            NSLog(@"拜访客户id－－－－－－－－－－－－－－－%@",visitIds);
            NSArray *idsArray=[visitIds componentsSeparatedByString:@"|"];
            for(int i=0;i<[idsArray count];i++){
                [[NotifyPoiServices getConnection] updatePoiByStartTime:[[idsArray objectAtIndex:i]intValue] isFinish:@"N" startTime:[Global getCurrentTime]];
            }
        }
    }
    [table reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:[resultDict objectForKey:@"msg"]
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];

}

- (void)qdSaveFaild:(NSObject*)result
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


-(void)qtSaveClick:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"发送数据中.." animated:NO];
    UIButton *btn=(UIButton *)sender;
    PoiInfo *poi=[cellsDataArray objectAtIndex:btn.tag];
    currentPoi=btn.tag;

    PoiInfoServices *conn=[PoiInfoServices getConnection];
    PoiInfo *qtPoi=[conn findBySpId:poi.spId];
    
    NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    NSString *poiType;
    if([poi.poiType isEqualToString:@"KH"]){
        poiType=@"C";
    }else{
        poiType=@"P";
    }
    
    
    NSDictionary *dic=[
                       [NSDictionary alloc] 
                       initWithObjects:
                       [NSArray arrayWithObjects:[NSString stringWithFormat:@"%i",qtPoi.spId],[NSString stringWithFormat:@"%i",qtPoi.slId],[Global getKey],user.imei,poiType,nil]
                       forKeys:[NSArray arrayWithObjects:@"poiId",@"slId",@"key",@"imei",@"poiType",nil]
                       ];
     
    NSString *json=[dic JSONRepresentation];
    NSMutableData *postBody = [NSMutableData data];
    NSString *param =[NSString stringWithFormat:@"param=%@",json];
    [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]];
    
    [[NetUtils shareNetworkHelper] requestDataFromURL:@"singinlocus/savesinginlous" withParams:postBody withHelperDelegate:self withSuccessRequestMethod:@"qtSaveSuccess:" withFaildRequestMethod:@"qtSaveFaild:" contentType:NO];
}


- (void)qtSaveSuccess:(NSObject*)result{
    NSDictionary *resultDict = (NSDictionary *)result;
    if([[resultDict objectForKey:@"result"]isEqualToString:@"success"]){
        PoiInfo *p = (PoiInfo *)[cellsDataArray objectAtIndex:currentPoi];
        PoiInfoServices *poi=[PoiInfoServices getConnection];
        [poi deleteBySpId:p.spId];
      
        [[PoiHistoryServices getConnection]updatePoiInfo:p.spId endTime:[Global getCurrentTime] isFinish:@"Y"];
        
        if([p.poiType isEqualToString:@"KH"]){
            NSString *visitIds=[[resultDict objectForKey:@"data"]objectForKey:@"visitId"];
            NSArray *idsArray=[visitIds componentsSeparatedByString:@","];
            for(int i=0;i<[idsArray count];i++){
                [[NotifyPoiServices getConnection] updatePoiByEndTime:[[idsArray objectAtIndex:i]intValue] isFinish:@"Y" endTime:[Global getCurrentTime]];
            }
        }
    }
    [table reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:[resultDict objectForKey:@"msg"]
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)qtSaveFaild:(NSObject*)result
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==alertView.cancelButtonIndex){
        //[self.navigationController popViewControllerAnimated:YES];
    }
}
@end
