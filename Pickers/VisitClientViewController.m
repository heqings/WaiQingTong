//
//  VisitClientViewController.m
//  Pickers
//
//  Created by 张飞 on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VisitClientViewController.h"

@implementation VisitClientViewController
@synthesize startTime,endTime,remark,myData,table;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"拜访客户";
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" 
                                                                   style:UITabBarSystemItemContacts target:self action:@selector(saveBtnClick:)]; 
    self.navigationItem.rightBarButtonItem= saveButton;
    
    chatArray = [[NSMutableArray alloc] init];
    checked = [UIImage imageNamed:@"checked"];
    checkno = [UIImage imageNamed:@"check_no"];
    NSMutableArray *mArray=[[ClientServices getConnection] findAll];
    
    myData = [[NSMutableDictionary alloc] init]; 
    for(Client *c in mArray){
        if([myData objectForKey:c.groupPy]){
            NSMutableArray *getArry = [myData objectForKey:c.groupPy];
            [getArry addObject:c];
            
        }else{
            NSMutableArray *newArry = [[NSMutableArray alloc] init];
            [newArry addObject:c];
            [myData setObject:newArry forKey:c.groupPy];
        }
    }
}

-(void)saveBtnClick:(id)sender{
    if([chatArray count]>0){
       [MBProgressHUD showHUDAddedTo:self.view withLabel:@"提交中..." animated:YES ];
        
        NSArray* arr=[[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        
        ids=[[NSString alloc]init];
        for(int i=0;i<[chatArray count];i++){
            NSIndexPath *indexPath=[chatArray objectAtIndex:i]; 
            Client *c =(Client *)[[myData valueForKey:[arr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]; 
            ids=[ids stringByAppendingString:[NSString stringWithFormat:@"%i",c.customId]];
            if(i!=[chatArray count]-1){
                ids=[ids stringByAppendingString:@","];
            } 
        }
        
        NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
        startTime=[startTime stringByAppendingString:@" 00:00:00"];
        endTime=[endTime stringByAppendingString:@" 00:00:00"];
        
        NSDictionary *dic=[
                           [NSDictionary alloc] 
                           initWithObjects:
                           [NSArray arrayWithObjects:startTime,endTime,ids,remark,[Global getKey],user.imei,nil]
                           forKeys:[NSArray arrayWithObjects:@"starttime",@"endtime",@"customIds",@"remark",@"key",@"imei",nil]
                           ];
        
        NSString *json=[dic JSONRepresentation];
        NSMutableData *postBody = [NSMutableData data];
        NSString *param =[NSString stringWithFormat:@"param=%@",json];
        [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]]; 
        
        [[NetUtils shareNetworkHelper] requestDataFromURL:@"visit/submitvisit" withParams:postBody withHelperDelegate:self withSuccessRequestMethod:@"requestSuccess:" withFaildRequestMethod:@"requestFaild:" contentType:NO];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"请选择拜访客户" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag=2;
        [alertView show];
    }
}

- (void)requestSuccess:(NSObject*)result{
    NSDictionary *resultDict = (NSDictionary *)result;
    if([[resultDict objectForKey:@"result"]isEqualToString:@"success"]){

        NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
        NotifyPlanE *plan=[[NotifyPlanE alloc]init];
        plan.createUser=user.name;
        plan.spId=[[[resultDict objectForKey:@"data"] objectForKey:@"id"]intValue];
        plan.createDate=[[resultDict objectForKey:@"data"] objectForKey:@"createtime"];
        plan.startTime=startTime;
        plan.endTime=endTime;
        plan.npContent=remark;
        plan.handlerId=[[[resultDict objectForKey:@"data"] objectForKey:@"handlerId"]intValue];
        plan.handlerName=[[resultDict objectForKey:@"data"] objectForKey:@"handlerName"];
        
        NotifyPlanServices *conn=[NotifyPlanServices getConnection];
        [conn insertNotifyPlan:plan];
        NotifyPlanE *newPlan=[conn findBySpId:[[[resultDict objectForKey:@"data"] objectForKey:@"id"]intValue]];
   
        NSArray* arr=[[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        
        for(int i=0;i<[chatArray count];i++){
            NSIndexPath *indexPath=[chatArray objectAtIndex:i]; 
            Client *c =(Client *)[[myData valueForKey:[arr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]; 
            NotifyPoi *poi=[[NotifyPoi alloc]init];
            poi.npId=newPlan.npId;
            poi.spId=c.customId;
            poi.poiAddress=c.address;
            poi.poiName=c.name;
            poi.startTime=@"";
            poi.endTime=@"";
            poi.isFinish=@"N";
            
            [[NotifyPoiServices getConnection]insertNotify:poi];
        }
        
        NotifyServices *notifyConn=[NotifyServices getConnection];
        Notify *notify=[notifyConn findByParam:@"nt_type" param:[Global getNOTIFY_BF]];

        NSString *title=[NSString stringWithString:remark];
        NSString *msgTitle;
        if(title.length>10){
            msgTitle=[title substringToIndex:10];
            msgTitle=[msgTitle stringByAppendingString:@"..."];
        }else{
            msgTitle=title;
        }
        
        if(notify.ntType==nil){
            [notifyConn insertNotify:@"拜访信息" isRead:@"N" readCount:0 ntDate:[Global getCurrentTime] toUser:@"" groupId:@"" ntType:[Global getNOTIFY_BF] detailText:msgTitle];
        }

        int count=(int)notify.readCount;
        count++;
        [notifyConn updateById:notify.ntId readCount:count detailText:msgTitle ntDate:[Global getCurrentTime]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"visitPageForward" object:nil];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self alertWithMassage:[resultDict objectForKey:@"msg"]];
}

- (void)requestFaild:(NSObject*)result{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)alertWithMassage:(NSString *)tMessage
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:tMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alertView.tag=1;
    [alertView show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==alertView.cancelButtonIndex){
        if(alertView.tag<2){
            int index=[[self.navigationController viewControllers]indexOfObject:self];
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
        }
    }
}  

- (void)viewDidUnload
{
    [super viewDidUnload];
    startTime=nil;
    endTime=nil;
    remark=nil;
    myData=nil;
    table=nil;
    chatArray=nil;
    checked=nil;
    checkno=nil;
    ids=nil;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[myData allKeys] count];  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* arr=[[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    return [[myData valueForKey:[arr objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    UIImage *image = [UIImage imageNamed:@"check_no"];  
    cell.imageView.image = image;
    
	NSArray* arr=[[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    Client *c=(Client *)[[myData valueForKey:[arr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    UIFont *font = [UIFont systemFontOfSize:17];
    cell.textLabel.font=font;
    cell.textLabel.text =c.name;
    
	//特定section里面找到对应的array，
	//然后在array中找到indexPath.row所在的内容
    return cell;
}

//分组标头
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if([myData count]==0){
        return @"";
    }
    NSArray *sortedKeys = [[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    return [sortedKeys objectAtIndex:section];
}

//索引筛选
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    for(NSString *character in [[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]){
        
        if([character isEqualToString:title]){            
            return count;
        }        
        count ++;        
    }
    return 0;
}

//右边索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

//点击表格行方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isExist=YES;
    for(int i=0;i<[chatArray count];i++){
        if([indexPath isEqual:[chatArray objectAtIndex:i]]){
            [chatArray removeObjectAtIndex:i];
            isExist=NO;
        }
    }
    if(isExist){
        [chatArray addObject:indexPath];
    }
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];  
    if([cell.imageView.image isEqual:checkno]){
        cell.imageView.image = checked;
    }else{
        cell.imageView.image = checkno;
    } 

    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中行的颜色
} 

//设置table行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

//当滚动条滚动时，从新绘制图片
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView=(UITableView *)scrollView;
        for(int i=0;i<[chatArray count];i++){
            UITableViewCell *cell=[tableView cellForRowAtIndexPath:[chatArray objectAtIndex:i]]; 
            cell.imageView.image = checked;
        }
    }
}
@end
