//
//  PushNotifySwitchController.m
//  Pickers
//
//  Created by  on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PushNotifySwitchController.h"
#import "JSON.h"
#import "GeneralSettingService.h"
@implementation PushNotifySwitchController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization、
        NSString * jsonString =@"{\"一\":[\"工作日志\",\"系统通知\",\"申请信息\",\"拜访信息\"]}";
        myData = [jsonString JSONValue];
        NSString*  fieldString = @"{\"工作日志\":\"t_notify_workplan\",\"系统通知\":\"t_notify_system\",\"申请信息\":\"t_notify_apply\",\"拜访信息\":\"t_notify_visit\"}";
        field = [fieldString JSONValue];
      
    }

 
    return self;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    //
    
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
-(void)switchAction:(id)control
{
    //
   GeneralSettingService * gs = [GeneralSettingService getConnection];
    NSMutableDictionary* setting = [gs getGeneralSetting];
    UISwitch* s=(UISwitch*)control;
    NSString* k=[field.allKeys objectAtIndex:s.tag];
    NSString* v=[field valueForKey:k];
    if(s.on)
        [setting setValue:@"Y" forKey:v];
    else
        [setting setValue:@"N" forKey:v];
    //更新服务器
    [gs updateGeneralSetting:setting];
    //
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    int i = [myData count];
    return i;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    int i= [[myData valueForKey:[[myData allKeys] objectAtIndex:section]] count];
    return i;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //
    
    // Configure the cell...
    NSInteger count=[indexPath row];
    NSString *text=[[myData valueForKey:[[myData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:count];
    
    cell.textLabel.text=text;
    
    UISwitch* s=[[UISwitch alloc]init ];
    s.tag=count;
    //
    GeneralSettingService* gs = [GeneralSettingService getConnection];
    NSMutableDictionary* setting = [gs getGeneralSetting];

    //
    NSString* f=[field valueForKey:text];
    [s addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    if([[setting valueForKey:f] isEqualToString:@"Y"])
            [s setOn:TRUE];
    else
            [s setOn:FALSE];

    s.frame=CGRectMake( 210,10,60,20);
    [cell addSubview:s];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
