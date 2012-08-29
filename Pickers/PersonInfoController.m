//
//  PersonInfoController.m
//  Pickers
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PersonInfoController.h"
#import "UserServices.h"
#import "NetUtils.h"
#import "Global.h"
#import "JsonServer.h"
#import "MBProgressHUD.h"
@implementation PersonInfoController
@synthesize sexData,regionData;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
  
    [super didReceiveMemoryWarning];
 
}
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    NSString *jsonString =@"{\"一\":[\"设置头像\"],\"二\":[\"名字\",\"昵称\",\"性别\",\"地区\"]}";
    
    myData = [jsonString JSONValue];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section == 0)
        return 60;
    else 
        return 50;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return [myData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [[myData valueForKey:[[myData allKeys] objectAtIndex:section]] count];   
}

-(void)updateUserInfo:(User*)user
{
    UserServices * service = [UserServices getConnection];
    [service updateUser:user];
    @try{
          [JsonServer updateUserInfoToServer:user];
         
    }@catch(NSException* e)
    {
        if([e.name isEqualToString:@"NetError"])
        {
            [MBProgressHUD hideHUDForView:self.view animated:TRUE];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误，无法更改昵称"
                                                            message:e.reason
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    [MBProgressHUD hideHUDForView:self.view animated:TRUE];
    

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
   
   
    [textField resignFirstResponder];
    user.nicke = textField.text;

    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"上传信息..." animated:TRUE];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{ 
        
        dispatch_async(dispatch_get_main_queue(), ^{  
            [self updateUserInfo:user];
            
        });  
    });  

    NSData *temp = [NSKeyedArchiver archivedDataWithRootObject:user]; 
    [[NSUserDefaults standardUserDefaults] setObject:temp forKey:@"User"];   

    return YES;
}
-(void)uploadTopimage:(id)temp
{
    UIImage* scaledImage=(UIImage*)temp;
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:user.topimage];
    NSData* imageData = UIImagePNGRepresentation(scaledImage);
    [imageData writeToFile:imagePath atomically:NO];
   
    @try{
    
        [JsonServer uploadUserTopImage:user];
    }@catch(NSException* e)
    {
        
        [MBProgressHUD hideHUDForView:self.view  animated:TRUE];
        if([e.name isEqualToString:@"NetError"])
        {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误,无法设置头像"
                                                        message:e.reason
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        }

    }
    [MBProgressHUD hideHUDForView:self.view  animated:TRUE];

     NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:user]; 
    [[NSUserDefaults standardUserDefaults] setObject:data1 forKey:@"User"];   

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     
 
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
 
    NSInteger count=[indexPath row];
    
    NSString *text=[[myData valueForKey:[[myData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:count];
  
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
 
    if([text isEqualToString:@"设置头像"]){
        
        if([user.topimage isEqualToString:@""])
        {
            imagePerson= [[UIImageView  alloc]initWithImage:[UIImage imageNamed:@"assistant.png"]];
        }else
        {
           
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            NSString* fileName= [user.topimage lastPathComponent];
            NSString *strPath = [documentsDirectory stringByAppendingPathComponent:fileName];
            
            UIImage* image = [UIImage imageWithContentsOfFile:strPath];
            imagePerson = [[UIImageView alloc]initWithImage:image];
        }
           
        imagePerson.frame=CGRectMake(5, 5, 50, 50);
        [cell.contentView addSubview:imagePerson];

        UITextField* label = [[UITextField alloc]init];
        label.frame = CGRectMake(100, 20, 120, 40);
        label.backgroundColor =[UIColor clearColor];
        label.opaque = true;
        label.text= text;
        label.enabled = false;
        label.font= [UIFont boldSystemFontOfSize: 17];
        [cell.contentView addSubview:label];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }else{
        cell.textLabel.text = text;        
        if([text isEqualToString:@"名字"])
        {
        UITextField* uf= [[UITextField alloc]init];
        uf.frame=CGRectMake(150, 15 , 200, 80);
        uf.opaque=true;
            uf.tag=1;
        uf.backgroundColor=[UIColor clearColor];
            uf.enabled=false;
            uf.text= user.name;
            uf.delegate =self;
                    [cell addSubview:uf];
            	[cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        if([text isEqualToString:@"昵称"])
        {
            UITextField* uf= [[UITextField alloc]init];
            uf.frame=CGRectMake(150, 15 , 200, 80);
            uf.opaque=true;
            uf.tag=2;
            uf.backgroundColor=[UIColor clearColor];
            uf.enabled=true;
            uf.text=  user.nicke;
            uf.delegate =self;
            [cell addSubview:uf];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }

        if([text isEqualToString:@"地区"])
        {
             textRegion = [[UITextField alloc]init];
            textRegion.frame=CGRectMake(150, 15 , 200, 80);
            textRegion.opaque=true;
            textRegion.backgroundColor=[UIColor clearColor];
            int selectRegion = [user.area intValue];
            textRegion.text=[self.regionData objectAtIndex:selectRegion];
            textRegion.enabled = false;
            
            [cell addSubview:textRegion];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        if([text isEqualToString:@"性别"])
        {
            textSex = [[UITextField alloc]init];
            textSex.frame=CGRectMake(150, 15 , 200, 80);
            textSex.opaque=true;
            textSex.backgroundColor=[UIColor clearColor];
            int selectSex =[user.sex intValue];
            textSex.text=[self.sexData  objectAtIndex:selectSex]  ;
        
            textSex.enabled = false;

            [cell addSubview:textSex];
             [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
             
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}

#pragma mark - Table view delegate
- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count=[indexPath row];
    
    NSString *text=[[myData valueForKey:[[myData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:count];
    if( [text isEqualToString:@"名字"])
    {
        return nil;       
    }else
        return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger count=[indexPath row];
    
    NSString *text=[[myData valueForKey:[[myData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:count];
   
    if([text isEqualToString:@"设置头像"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"拍摄", @"从相册选择", nil];
        alert.tag = 1;
        [alert show];
    }
    /*
    else 
    {
        if([text isEqualToString:@"地区"])
        {
            InfoSelectController *detailViewController = [[InfoSelectController alloc] initWithStyle:UITableViewStyleGrouped];
            // ...
            // Pass the selected object to the new view controller.
            detailViewController.myData = self.regionData;
            detailViewController.currentIndex= [user.area intValue];
            detailViewController.tag=2;
            detailViewController.myDelegate = self;
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
        if([text isEqualToString:@"性别"])
        {
            InfoSelectController *detailViewController = [[InfoSelectController alloc] initWithStyle:UITableViewStyleGrouped];
            detailViewController.myData = self.sexData;
            detailViewController.currentIndex=[user.sex intValue];
            detailViewController.tag=1;
             detailViewController.myDelegate = self;
            // ...
            // Pass the selected object to the new view controller.
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
    }*/
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    	if (alertView.tag == 1 || alertView.tag == 2) {
        if (buttonIndex == 0) {
            return;
        }
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
	}
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	NSString *strType = [info valueForKey:UIImagePickerControllerMediaType];
  
    UIImage* image;
	if ([strType hasSuffix:@"image"]) {
		 image = [info valueForKey:UIImagePickerControllerOriginalImage];
        
	}else {
		NSString *mediaUrl = [[info valueForKey:UIImagePickerControllerMediaURL] path];
        if (mediaUrl != nil) {
            image= [UIImage imageWithContentsOfFile :mediaUrl];
        }
	}
    //将取出的图片设成70*70
    CGSize size;
    size.width =  70;
    size.height = 70;
    UIGraphicsBeginImageContext(size);  
    // 绘制改变大小的图片  
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];  
    
    // 从当前context中创建一个改变大小后的图片  
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();  
    
    // 使当前的context出堆栈  
    UIGraphicsEndImageContext(); 
    
  
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //更新数据库
    NSString* fileName=   [NSString stringWithString:  user.imei];
    user.modified =2;
    user.topimage=   [fileName stringByAppendingFormat:@".png"];;
    NSData *temp = [NSKeyedArchiver archivedDataWithRootObject:user]; 
    [[NSUserDefaults standardUserDefaults] setObject:temp forKey:@"User"];   
    
    //异步保存
    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"上传头像..." animated:TRUE];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{ 
        
        dispatch_async(dispatch_get_main_queue(), ^{  
            [self uploadTopimage:scaledImage];
            
        });  
    });  
        
    //上传图像文件到服务器

    imagePerson.image = image; 
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:YES];
}

@end
