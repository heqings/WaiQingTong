//
//  ClientInfoViewController.m
//  Pickers
//
//  Created by 张飞 on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ClientInfoViewController.h"


@implementation ClientInfoViewController
@synthesize  table,cellsDataArray,name,address,email,url,telphone,faxphone,bodyView;


- (void)viewDidLoad{
    [super viewDidLoad];
    NSInteger customId=[[NSUserDefaults standardUserDefaults] integerForKey:@"chooseClientCustomId"];
    
    Client *c=[[ClientServices getConnection]findByCustomId:customId];
    name.text=c.name;
    address.text=c.address;
    email.text=[Global getNullString:c.email];
    url.text=[Global getNullString:c.uri];
    telphone.text=[Global getNullString:c.telphone];
    faxphone.text=[Global getNullString:c.faxphone];
    
    cellsDataArray=[[NSMutableArray alloc]init];
    cellsDataArray=[[ClientInfoServices getConnection]findByCId:customId];
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background"]];
  
    self.navigationItem.title=@"客户资料详情";
    
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"新增" 
                                                                    style:UITabBarSystemItemContacts target:self action:@selector(newBtnClick:)]; 
    self.navigationItem.rightBarButtonItem= newButton;
    self.bodyView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"client_body_info_bg"]];
    self.bodyView.opaque = NO;
}

//新增按钮事件
-(void)newBtnClick:(id)sender{
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem= backbutton;  
    
    ClientFromViewController *from=[[ClientFromViewController alloc]init];
    from.workUtilsDelegate=self;
    [self.navigationController pushViewController:from animated:YES];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    table=nil;
    cellsDataArray=nil;
    [super viewDidUnload];
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cellsDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    double height = 105;
    static NSString *CellIdentifier = @"ClientTableCell";
    ClientTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ClientTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    ClientInfo *info=(ClientInfo *)[cellsDataArray objectAtIndex:[indexPath row]];
    
    cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    cell.tag=[indexPath row];
    cell.linkname.text =info.linkname;
    cell.remark.text=info.remark;
    
    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"header36" ofType:@"png"]];
    
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[img stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    
    imageView.frame=CGRectMake(20, 20, 40, 40);
    
    cell.img=imageView;
    
    [cell.remark sizeToFit];
    cell.linkmobile.text=info.linkmobile;
    cell.email.text=info.email;
    cell.officetel.text=info.officetel;
   
    height += cell.remark.frame.size.height;
    
    cell.bottom.frame = CGRectMake(0, 0, 320, height+40);
    cell.bottom.image = [[UIImage imageNamed:@"block_foot_background"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    cell.frame = CGRectMake(0, 0, 320, height+35);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

//刷新表格
-(void)reloadTableView{
    NSInteger customId=[[NSUserDefaults standardUserDefaults] integerForKey:@"chooseClientCustomId"];
    cellsDataArray=[[ClientInfoServices getConnection]findByCId:customId];
    [table reloadData];
}
@end
