//
//  ClientListFromViewController.m
//  Pickers
//
//  Created by 张飞 on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ClientListFromViewController.h"

@implementation ClientListFromViewController
@synthesize workUtilsDelegate,mapView,search,myData,myTable;

-(void)viewWillDisappear:(BOOL)animated{
    if(!isSuccess){
        [timer invalidate];
    }    
    timer=nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"新增客户资料";
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" 
                                                                   style:UITabBarSystemItemContacts target:self action:@selector(saveBtnClick:)]; 
    self.navigationItem.rightBarButtonItem= saveButton;
    NSString *jsonString =@"{\"一\":[\"公司地址\"],\"二\":[\"公司名称\"],\"三\":[\"传真号码\"],\"四\":[\"联系电话\"],\"五\":[\"公司网址\"],\"六\":[\"电子邮箱\"]}";
    myData = [jsonString JSONValue];
    
    mapView= [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    mapView.delegate = self;
    mapView.showsUserLocation=YES;
    isSuccess=FALSE;
    timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(findPoint) userInfo:nil repeats:YES];	
    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"定位中..." animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    mapView=nil;
    search=nil;
    myTable=nil;
    myData=nil;
    address=nil;
}

-(void)dealloc
{
    mapView.delegate=nil;
    search.delegate=nil;
}

//保存事件
-(void)saveBtnClick:(id)sender{
   
    UIView *nameView=(UIView *)[myTable viewWithTag:1];
    UITextField *nameText=(UITextField *)[nameView viewWithTag:11];
    
    UIView *addressView=(UIView *)[myTable viewWithTag:2];
    UITextView *addressText=(UITextView *)[addressView viewWithTag:22];
    
    UIView *urlView=(UIView *)[myTable viewWithTag:3];
    UITextField *urlText=(UITextField *)[urlView viewWithTag:110];
    
    UIView *phoneView=(UIView *)[myTable viewWithTag:4];
    UITextField *phoneText=(UITextField *)[phoneView viewWithTag:180];
    
    UIView *faxView=(UIView *)[myTable viewWithTag:5];
    UITextField *faxText=(UITextField *)[faxView viewWithTag:220];
    
    UIView *emailView=(UIView *)[myTable viewWithTag:6];
    UITextField *emailText=(UITextField *)[emailView viewWithTag:50];
    
    NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if(nameText.text==nil){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"公司名称不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag=2;
        [alertView show];
        
        return ;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"提交中..." animated:YES ];
    
    NSDictionary *dic=[
                       [NSDictionary alloc] 
                       initWithObjects:
                       [NSArray arrayWithObjects:[Global getNullString:nameText.text],[Global getNullString:addressText.text],[Global getNullString:urlText.text],[Global getNullString:phoneText.text],[Global getNullString:faxText.text],[Global getNullString:emailText.text],[NSString stringWithFormat:@"%f",lng],[NSString stringWithFormat:@"%f",lat],[Global getKey],user.imei,nil]
                       forKeys:[NSArray arrayWithObjects:@"name",@"address",@"uri",@"telphone",@"faxphone",@"email",@"lng",@"lat",@"key",@"imei",nil]
                       ];
    
    NSString *json=[dic JSONRepresentation];
    NSMutableData *postBody = [NSMutableData data];
    NSString *param =[NSString stringWithFormat:@"param=%@",json];
    [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]]; 
    
    
    [[NetUtils shareNetworkHelper] requestDataFromURL:@"custom/saveCustom" withParams:postBody withHelperDelegate:self withSuccessRequestMethod:@"requestSuccess:" withFaildRequestMethod:@"requestFaild:" contentType:NO];
} 

- (void)requestSuccess:(NSObject*)result{
    NSDictionary *resultDict = (NSDictionary *)result;
    if([[resultDict objectForKey:@"result"]isEqualToString:@"success"]){

        UIView *nameView=(UIView *)[myTable viewWithTag:1];
        UITextField *nameText=(UITextField *)[nameView viewWithTag:11];
        
        UIView *addressView=(UIView *)[myTable viewWithTag:2];
        UITextView *addressText=(UITextView *)[addressView viewWithTag:22];
        
        UIView *urlView=(UIView *)[myTable viewWithTag:3];
        UITextField *urlText=(UITextField *)[urlView viewWithTag:110];
        
        UIView *phoneView=(UIView *)[myTable viewWithTag:4];
        UITextField *phoneText=(UITextField *)[phoneView viewWithTag:180];
        
        UIView *faxView=(UIView *)[myTable viewWithTag:5];
        UITextField *faxText=(UITextField *)[faxView viewWithTag:220];
        
        UIView *emailView=(UIView *)[myTable viewWithTag:6];
        UITextField *emailText=(UITextField *)[emailView viewWithTag:50];
        
        Client *c=[[Client alloc]init];
        c.customId=[[[resultDict objectForKey:@"data"] objectForKey:@"customId"]intValue];
        c.name=[Global getNullString:nameText.text];
        c.address=[Global getNullString:addressText.text];
        c.uri=[Global getNullString:urlText.text];
        c.telphone=[Global getNullString:phoneText.text];
        c.faxphone=[Global getNullString:faxText.text];
        c.email=[Global getNullString:emailText.text];
        c.createtime=[Global getCurrentTime];
        c.namePinyin=[[resultDict objectForKey:@"data"] objectForKey:@"namePinyin"];
        NSRange idsRange = NSMakeRange(0,1);
        c.groupPy=[[NSString stringWithFormat:@"%@",[[resultDict objectForKey:@"data"] objectForKey:@"namePinyin"]] substringWithRange:idsRange];
        
        [[ClientServices getConnection]insertClient:c];
        
        [workUtilsDelegate reloadTableView];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self alertWithMassage:[resultDict objectForKey:@"msg"]];
}

- (void)requestFaild:(NSObject*)result{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==alertView.cancelButtonIndex){
        if(alertView.tag<2)
            [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertWithMassage:(NSString *)tMessage
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:tMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alertView.tag=1;
    [alertView show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)findPoint{
    if(mapView.userLocation.location.coordinate.latitude>0.0f&&mapView.userLocation.location.coordinate.longitude>0.0f){
        isSuccess=true;
        [timer invalidate];  
         
        search = [[BMKSearch alloc]init];
        search.delegate = self;
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){mapView.userLocation.location.coordinate.latitude,mapView.userLocation.location.coordinate.longitude};    
        [search reverseGeocode:pt];
        
        lat=mapView.userLocation.location.coordinate.latitude;                 
        lng=mapView.userLocation.location.coordinate.longitude; 
        [mapView setShowsUserLocation:NO];
    }
}


//根据经纬度获取地址
-(void)onGetAddrResult:(BMKAddrInfo *)result errorCode:(int)error{
	if (error == 0) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        address=result.strAddr;
        [myTable reloadData];
	}
}


#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [myData count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[myData valueForKey:[[myData allKeys] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    NSInteger count=[indexPath row];
    NSString *text=[[myData valueForKey:[[myData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:count];
    
    UITableViewCell *startTimeCell=[[UITableViewCell alloc]init];
    
    UIFont *font = [UIFont systemFontOfSize:16];
    
    if([text isEqualToString:@"公司名称"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
        view.tag=1;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        label.text=@"公司名称";
        label.font=font;
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 7.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UITextField *nameText=[[UITextField alloc]initWithFrame:CGRectMake(110, 4, 165, 30)];
        [nameText setFont:[UIFont fontWithName:@"Arial" size:16]];
        nameText.tag=11;
        nameText.font=font;
        nameText.backgroundColor=[UIColor clearColor];
        [view addSubview:nameText];
        
        [startTimeCell addSubview:view];
    }else if([text isEqualToString:@"公司地址"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 0.0f, 280.0f, 40.0f);
        view.tag=2;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 17.0f, 80.0f, 30.0f);
        label.text=@"公司地址";
        label.font=font;
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 23.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UITextView *addressText=[[UITextView alloc]init];
        addressText.frame=CGRectMake(110.0f, 3.0f, 165.0f, 50.0f);
        [addressText setFont:[UIFont fontWithName:@"Arial" size:16]];
        addressText.tag=22;
        addressText.text=address;
        addressText.userInteractionEnabled = NO;
        addressText.backgroundColor=[UIColor clearColor];
        [view addSubview:addressText];
        
        
        [startTimeCell addSubview:view];
    }else if([text isEqualToString:@"公司网址"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
        view.tag=3;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        label.text=@"公司网址";
        label.font=font;
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 7.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UITextField *urlText=[[UITextField alloc]initWithFrame:CGRectMake(110, 2, 165, 30)];
        [urlText setFont:[UIFont fontWithName:@"Arial" size:16]];
        urlText.tag=110;
        urlText.font=font;
        urlText.backgroundColor=[UIColor clearColor];
        [urlText addTarget:self action:@selector(textFieldDidEndEditing:)forControlEvents:UIControlEventEditingDidEndOnExit];
        [urlText addTarget:self action:@selector(textFieldDidStartEditing:)forControlEvents:UIControlEventEditingDidBegin];
        
        [view addSubview:urlText];
        
        [startTimeCell addSubview:view];
    }else if([text isEqualToString:@"联系电话"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
        view.tag=4;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        label.text=@"联系电话";
        label.font=font;
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 7.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UITextField *phoneText=[[UITextField alloc]initWithFrame:CGRectMake(110, 4, 165, 30)];
        [phoneText setFont:[UIFont fontWithName:@"Arial" size:16]];
        phoneText.tag=180;
        phoneText.font=font;
        phoneText.delegate=self;
        phoneText.backgroundColor=[UIColor clearColor];
        [phoneText addTarget:self action:@selector(textFieldDidEndEditing:)forControlEvents:UIControlEventEditingDidEndOnExit];
        [phoneText addTarget:self action:@selector(textFieldDidStartEditing:)forControlEvents:UIControlEventEditingDidBegin];
        [view addSubview:phoneText];
        
        [startTimeCell addSubview:view];
    }else if([text isEqualToString:@"传真号码"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
        view.tag=5;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        label.text=@"传真号码";
        label.font=font;
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 7.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UITextField *faxText=[[UITextField alloc]initWithFrame:CGRectMake(110, 4, 165, 30)];
        [faxText setFont:[UIFont fontWithName:@"Arial" size:16]];
        faxText.tag=220;
        faxText.font=font;
        faxText.delegate=self;
        faxText.backgroundColor=[UIColor clearColor];
        [faxText addTarget:self action:@selector(textFieldDidEndEditing:)forControlEvents:UIControlEventEditingDidEndOnExit];
        [faxText addTarget:self action:@selector(textFieldDidStartEditing:)forControlEvents:UIControlEventEditingDidBegin];
        [view addSubview:faxText];
        
        [startTimeCell addSubview:view];
    }else if([text isEqualToString:@"电子邮箱"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
        view.tag=6;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        label.text=@"电子邮箱";
        label.font=font;
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 7.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UITextField *emailText=[[UITextField alloc]initWithFrame:CGRectMake(110, 4, 165, 30)];
        [emailText setFont:[UIFont fontWithName:@"Arial" size:16]];
        emailText.tag=50;
        emailText.font=font;
        emailText.backgroundColor=[UIColor clearColor];
        [emailText addTarget:self action:@selector(textFieldDidEndEditing:)forControlEvents:UIControlEventEditingDidEndOnExit];
        [emailText addTarget:self action:@selector(textFieldDidStartEditing:)forControlEvents:UIControlEventEditingDidBegin];
        [view addSubview:emailText];
        
        [startTimeCell addSubview:view];
    }
    
    cell = startTimeCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


//设置table行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count=[indexPath row];
    NSString *text=[[myData valueForKey:[[myData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:count];
    if([text isEqualToString:@"公司地址"]){
        return 60.0f;
    }else{
        return 40.0f;
    }
}

//输入文本结束后，关闭键盘，并恢复视图位置
- (void)textFieldDidEndEditing:(id)sender {
	[sender resignFirstResponder];	
	[UIView beginAnimations:@"move" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4f];
	CGRect newFrame = CGRectMake(0.0, 0.0, 320.0, 480.0);
	self.view.frame = newFrame;
	[UIView commitAnimations];
}

//开始输入文本时，将当前视图向上移动，以显示键盘
- (void)textFieldDidStartEditing:(id)sender	 {
    UITextField *text=(UITextField*)sender;
	[UIView beginAnimations:@"move" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4f];
	CGRect newFrame = CGRectMake(0.0, -text.tag, 320.0, 480.0);
	self.view.frame = newFrame;
	[UIView commitAnimations];
	
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField.tag==180){
        if (range.location>10)return NO;
    }else if(textField.tag==220){
        if (range.location>11)return NO;
    }
    
    return YES;
}
@end
