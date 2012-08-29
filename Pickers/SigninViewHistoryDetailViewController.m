//
// Created by HeQing on 12-5-15.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SigninViewHistoryDetailViewController.h"
@interface SigninViewHistoryDetailViewController (private)
-(NSString *)signinType:(NSString *)type;
-(NSString *)getImgUrl:(NSMutableArray *)picDataArray;
@end

@implementation SigninViewHistoryDetailViewController
@synthesize  table,myData,address,picDataArray,latitude,longitude,nameText,remarkText,sqLabel;
static NSString * const BOUNDRY = @"--------------------------7d71a819230404";

- (void)alertWithMassage:(NSString *)tMessage
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:tMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (void)viewDidLoad{
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" 
                                                                   style:UITabBarSystemItemContacts target:self action:@selector(saveBtnClick:)]; 
    self.navigationItem.rightBarButtonItem= saveButton;
    
    self.navigationItem.title=@"标注列表";
    NSString *jsonString =@"{\"一\":[\"照片附件\",\"照片显示\"],\"四\":[\"标注描述\"],\"三\":[\"标注地址\"],\"五\":[\"标注名称\"],\"二\":[\"标注类型\"]}";

    myData = [jsonString JSONValue];
    //语音识别初始化
    speechHelper = [SpeechHelper alloc];
    [speechHelper inita:self];
    picDataArray=[[NSMutableArray alloc]init];
    
    nameText=[[UITextField alloc]init];
    remarkText=[[UITextView alloc]init];
    sqLabel=[[UILabel alloc]init];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    table=nil;
    myData=nil;
    address=nil;
    picDataArray=nil;
    nameText=nil;
    remarkText=nil;
    speechHelper=nil;
    sqLabel=nil;
    [super viewDidUnload];
}



-(void)saveBtnClick:(id)sender{

    UIView *addressView=(UIView *)[table viewWithTag:4];
    UITextView *addressText=(UITextView *)[addressView viewWithTag:44];
    
    NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];

    if(nameText.text==nil){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"标注名称不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag=2;
        [alertView show];
        
        return ;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"提交中..." animated:YES ];
    NSDictionary *dic=[
                       [NSDictionary alloc] 
                       initWithObjects:
                       [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f",latitude],[NSString stringWithFormat:@"%f",longitude],[self signinType:sqLabel.text],[Global getNullString:nameText.text],[Global getNullString:remarkText.text],[Global getNullString:addressText.text],[Global getKey],user.imei,nil]
                       forKeys:[NSArray arrayWithObjects:@"OLat",@"OLng",@"type",@"name",@"remark",@"address",@"key",@"imei",nil]
                       ];
    NSString *json=[dic JSONRepresentation];
    
    int len=512;
    NSMutableData  * postBody =[NSMutableData dataWithCapacity:len];
    
    [postBody  appendData: [[NSString  stringWithFormat:@"\r\n--%@\r\n",BOUNDRY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody  appendData: [[NSString  stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"param" ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody  appendData:[[NSString   stringWithFormat:@"%@",json] dataUsingEncoding:NSUTF8StringEncoding]];
    
    if([picDataArray count]>0){
        for(int i=0;i<[picDataArray count];i++){
            NSString *path=[picDataArray objectAtIndex:i];
            NSData* imgData = [NSData dataWithContentsOfFile:path];

            len = imgData.length + 512;
                
            [postBody  appendData:[[NSString   stringWithFormat:@"\r\n--%@\r\n",BOUNDRY] dataUsingEncoding:NSUTF8StringEncoding]];
            NSString* fileName = [path lastPathComponent];
            [postBody  appendData: [[NSString  stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\nContent-Type: image/png\r\n\r\n",@"imageFile",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody  appendData:imgData];

        }
    }
    [postBody  appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",BOUNDRY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[NetUtils shareNetworkHelper] requestDataFromURL:@"poi/savepoi" withParams:postBody withHelperDelegate:self withSuccessRequestMethod:@"biaozhuSuccess:" withFaildRequestMethod:@"biaozhuFaild:" contentType:YES];
    
}

- (void)biaozhuSuccess:(NSObject*)result{
    NSDictionary *resultDict = (NSDictionary *)result;
    if([[resultDict objectForKey:@"result"]isEqualToString:@"success"]){
        UIView *addressView=(UIView *)[table viewWithTag:4];
        UITextView *addressText=(UITextView *)[addressView viewWithTag:44];
        
        SignIn *signIn=[[SignIn alloc]init];
        signIn.signInName=[Global getNullString:nameText.text];
        signIn.signInType=[self signinType:sqLabel.text];
        signIn.signInAddress=[Global getNullString:addressText.text];
        //signIn.signInImgUrl=[self getImgUrl:picDataArray];
        signIn.OLat=[NSString stringWithFormat:@"%f",latitude];
        signIn.OLng=[NSString stringWithFormat:@"%f",longitude];
        signIn.signInRemark=[Global getNullString:remarkText.text];
        signIn.createTime=[Global getCurrentTime];

        NSString *temp=[[NSString alloc]init];
        if([picDataArray count]>0){
            for(int i=0;i<[picDataArray count];i++){
                temp =[temp stringByAppendingString:[picDataArray objectAtIndex:i]];
                if(i!=([picDataArray count]-1)){
                   temp = [temp stringByAppendingString:@","]; 
                }
            }
        }

        signIn.signInImgUrl=temp;
        SignInService *conn=[SignInService getConnection];
        [conn insertSignIn:signIn];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:[resultDict objectForKey:@"msg"]
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    alert.tag =99;
    [alert show];
}

- (void)biaozhuFaild:(NSObject*)result
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    
    if([text isEqualToString:@"标注类型"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
        view.tag=1;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        label.text=@"标注类型";
        label.font=font;
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 7.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        sqLabel.frame=CGRectMake(80.0f, 0.0f, 200.0f, 30.0f);
        sqLabel.text=@"门店";
        sqLabel.textAlignment=UITextAlignmentCenter;
        sqLabel.backgroundColor=[UIColor clearColor];
        sqLabel.tag=11;
        [view addSubview:sqLabel];
        
        [startTimeCell addSubview:view];
    }else if([text isEqualToString:@"标注名称"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
        view.tag=2;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        label.text=@"标注名称";
        label.font=font;
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 7.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        nameText.frame=CGRectMake(110, 4, 165, 30);
        [nameText setFont:[UIFont fontWithName:@"Arial" size:16]];
        nameText.tag=70;
        nameText.font=font;
        nameText.backgroundColor=[UIColor clearColor];
        [nameText addTarget:self action:@selector(textFieldDidEndEditing:)forControlEvents:UIControlEventEditingDidEndOnExit];
        [nameText addTarget:self action:@selector(textFieldDidStartEditing:)forControlEvents:UIControlEventEditingDidBegin];
        [view addSubview:nameText];
        
        
        [startTimeCell addSubview:view];
    }else if([text isEqualToString:@"标注描述"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
        view.tag=3;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 40.0f, 80.0f, 30.0f);
        label.text=@"标注描述";
        label.font=font;
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 47.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        remarkText.frame=CGRectMake(110.0f, 3.0f, 165.0f, 92.0f);
        [remarkText setFont:[UIFont fontWithName:@"Arial" size:16]];
        remarkText.tag=33;
        remarkText.contentOffset = CGPointMake(0,15);
        remarkText.backgroundColor=[UIColor clearColor];
        remarkText.delegate=self;
        UIEdgeInsets offset = UIEdgeInsetsMake(1, 0, 0, 0);
        [remarkText setContentSize:remarkText.frame.size];
        [remarkText setContentInset:offset];
        
        
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 35)];  
        topView.barStyle = UIBarStyleBlackTranslucent;  
        
        //语音输入按钮
        UIBarButtonItem * speechButton = [[UIBarButtonItem alloc]initWithTitle:@"语音" style:UIBarButtonItemStyleDone target:self action:@selector(onButtonRecognize)]; 
        //语音识别绑定输入文本和触发按钮
        [speechHelper setSource:remarkText speechTrigger:speechButton];
        
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];  
        
        NSArray * buttonsArray = [NSArray arrayWithObjects:speechButton,btnSpace,doneButton,nil];  
        [topView setItems:buttonsArray];          
        [remarkText setInputAccessoryView:topView]; 
        
        [view addSubview:remarkText];
        
        [startTimeCell addSubview:view];
    }else if([text isEqualToString:@"标注地址"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 0.0f, 280.0f, 40.0f);
        view.tag=4;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 17.0f, 80.0f, 30.0f);
        label.text=@"标注地址";
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
        addressText.tag=44;
        addressText.text=address;
        addressText.userInteractionEnabled = NO;
        addressText.backgroundColor=[UIColor clearColor];
        [view addSubview:addressText];
        
        [startTimeCell addSubview:view];
    }else if([text isEqualToString:@"照片附件"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 0.0f, 280.0f, 40.0f);
        view.tag=5;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 15.0f, 80.0f, 30.0f);
        label.text=@"照片附件";
        label.font=font;
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 22.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UILabel *picLabel=[[UILabel alloc]init];
        picLabel.frame=CGRectMake(80.0f, 15.0f, 200.0f, 30.0f);
        picLabel.text=@"点击添加图片";
        picLabel.textAlignment=UITextAlignmentCenter;
        picLabel.backgroundColor=[UIColor clearColor];
        picLabel.tag=55;
        picLabel.font=font;
        [view addSubview:picLabel];
        
        [startTimeCell addSubview:view];
    }else if([text isEqualToString:@"照片显示"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(15.0f, 0.0f, 290.0f, 105.0f);
        view.backgroundColor=[UIColor clearColor];
        
        if([picDataArray count]>0){
            for(int i=0;i<[picDataArray count];i++){
                NSString *path=[picDataArray objectAtIndex:i];
                UIImage *img = [UIImage imageWithContentsOfFile:path];
                
                UIImageView *imageView = [[UIImageView alloc]initWithImage:img];
                imageView.frame=CGRectMake(73*i, 9, 70, 70);
                
                [view addSubview:imageView];
            }
        }
        [startTimeCell addSubview:view];
    }
    
    cell = startTimeCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//点击表格行方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count=[indexPath row];
    NSString *text=[[myData valueForKey:[[myData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:count];

    if([text isEqualToString:@"标注类型"]){
        UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
        backbutton.title=@"返回";
        self.navigationItem.backBarButtonItem= backbutton;
        
        SigninTypeViewController *type=[[SigninTypeViewController alloc]init];
        type.workUtilsDelegate=self;
        [self.navigationController pushViewController:type animated:YES];
    }else if([text isEqualToString:@"照片附件"]){
        if([picDataArray count]>=4){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"最多只能上传四张图片"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"拍摄", @"从相册选择", nil];
            alert.tag = 1;
            [alert show];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中行的颜色
}

//设置table行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count=[indexPath row];
    NSString *text=[[myData valueForKey:[[myData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:count];
    if([text isEqualToString:@"标注描述"]){
        return 120.0f;
    }else if([text isEqualToString:@"标注地址"]){
        return 60.0f;
    }else if([text isEqualToString:@"照片显示"]){
        return 90.0f;
    }else if([text isEqualToString:@"照片附件"]){
        return 55.0f;
    }else{
        return 40.0f;
    }
}

//点击弹出框选择拍照或选择照片
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex !=alertView.cancelButtonIndex) {
       
		UIImagePickerController *Videopicker = [[UIImagePickerController alloc] init];
		Videopicker.delegate = self;
		[Videopicker setEditing:NO];
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES
			&& buttonIndex == 1) {
			Videopicker.sourceType = UIImagePickerControllerSourceTypeCamera;
			isCamera = YES;
		}
		else {
			Videopicker.sourceType =UIImagePickerControllerSourceTypeSavedPhotosAlbum;
			Videopicker.allowsEditing = YES;
			isCamera = NO;
		}
		[self.navigationController presentModalViewController:Videopicker animated:YES];
	}else{
        if(alertView.tag==99){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//拍照或录像
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    NSString *strType = [info valueForKey:UIImagePickerControllerMediaType];
    
    UIImage* image;
	if ([strType hasSuffix:@"image"]) {
        image = [info valueForKey:UIImagePickerControllerOriginalImage];
 
	}else {
		NSString *mediaUrl =  [NSMutableString stringWithString:[[info valueForKey:@"UIImagePickerControllerMediaURL"] path]];
        if (mediaUrl != nil) {
            
            image= [UIImage imageWithContentsOfFile:mediaUrl];
        }
	}
	
    
    CGSize size;
    size.width =  320;
    size.height = 480;
    
    UIGraphicsBeginImageContext(size);  
    // 绘制改变大小的图片  
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];  
    // 从当前context中创建一个改变大小后的图片  
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();  
    // 使当前的context出堆栈  
    UIGraphicsEndImageContext();
    image=nil;
    
    NSString *strPath = [Global saveImageAsPng:scaledImage];
    
    //NSString *strName = [strPath lastPathComponent];
    
    ///var/mobile/Applications/8274C62C-E645-4CC9-BAAA-3592877C9209/Documents/img/20120712165820.png---------20120712165820.png
    [picDataArray addObject:strPath];
    
    [self performSelectorOnMainThread:@selector(flush) withObject:nil waitUntilDone:true];
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:YES];
}

-(void)flush{
    [table reloadData];
}

//隐藏键盘
-(IBAction)dismissKeyBoard{  
    UIView *view=(UIView *)[table viewWithTag:3];
    UITextField *text=(UITextField *)[view viewWithTag:33];
    [text resignFirstResponder];  
    [UIView beginAnimations:@"move" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4f];
	CGRect newFrame = CGRectMake(0.0, 0.0, 320.0, 420.0);
	self.view.frame = newFrame;
	[UIView commitAnimations];
}

//标注类型选择
-(void)chooseTypeName:(NSString *)name{
    UIView *view=(UIView *)[table viewWithTag:1];
    UILabel *text=(UILabel *)[view viewWithTag:11];
    text.text=name;
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{ 
	[UIView beginAnimations:@"move" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4f];
	CGRect newFrame = CGRectMake(0.0, -130, 320.0, 480.0);
	self.view.frame = newFrame;
	[UIView commitAnimations];
    return YES;
}  

// 语音识别触发按钮，启动语音输入
- (void)onButtonRecognize
{

    [speechHelper speechStart];
}

-(NSString *)signinType:(NSString *)type{
    if([type isEqualToString:@"门店"]){
        return @"MD";
    }else if([type isEqualToString:@"渠道"]){
        return @"QD";
    }else if([type isEqualToString:@"其他"]){
        return @"QT";
    }
    return @"MD";
}

-(NSString *)getImgUrl:(NSMutableArray *)array{
    NSString *temp =[[NSString alloc]init];
    if([array count]>0){
        for(int i=0;i<[array count];i++){
            temp =[temp stringByAppendingString:[array objectAtIndex:i]];
            temp = [temp stringByAppendingString:@","];
        }
    }
    return temp;
}
@end