//
//  GeneralSettingController.m
//  Pickers
//
//  Created by  on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GeneralSettingController.h"
#import "InfoSelectController.h"
#import "PushNotifySwitchController.h"
#import "GeneralSettingService.h"
#import "JSON.h"
#import "UserServices.h"
@implementation GeneralSettingController
@synthesize imageQualityData;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) { 
        // Custom initialization
        NSString * jsonString =@"{\"一\":[\"上传图片质量\"]}";
        
        myData = [jsonString JSONValue];
        self.imageQualityData  = [NSArray arrayWithObjects:@"高",@"中",@"低", nil];

        NSString*  jsonField=@"{\"上传图片质量\":\"t_image_quality\",\"接收新通知\":\"t_accept_notify\"}";
      
        field = [jsonField JSONValue];

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

}


- (void)viewDidUnload
{
    [super viewDidUnload];

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [[myData valueForKey:[[myData allKeys] objectAtIndex:section]] count];   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    NSInteger count=[indexPath row];
    
    NSString *text=[[myData valueForKey:[[myData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:count];
    //
    cell.textLabel.text=text;
    GeneralSettingService* gs = [GeneralSettingService getConnection];
    NSDictionary* setting = [gs getGeneralSetting];
    
    if([text isEqualToString:@"上传图片质量"])
    {

        labelImageQuality = [[UILabel alloc]init];
        labelImageQuality.frame = CGRectMake(150, 13, 100, 20 );
        labelImageQuality.textAlignment= UITextAlignmentCenter;
        labelImageQuality.backgroundColor=[UIColor clearColor];
        labelImageQuality.opaque=true;

        NSString* select = [setting valueForKey:@"t_image_quality"];
        int  currentSelectImageQualityIndex = [select intValue];
        NSString *text=[self.imageQualityData  objectAtIndex:currentSelectImageQualityIndex];
        labelImageQuality.text=text;

        [cell addSubview:labelImageQuality];
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;

    }
    if([text isEqualToString:@"推送通知"])
    {

        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;

    }

    
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
- (void)onSelectItem:(NSDictionary*)data Tag:(int)tag
{

    GeneralSettingService* us= [GeneralSettingService getConnection];
    NSDictionary* setting = [us getGeneralSetting];
    if(tag == 1)
    {
       NSNumber* number = [data valueForKey:@"currentIndex"];
        
        NSString *text=[self.imageQualityData  objectAtIndex:[number intValue]];
       labelImageQuality.text=text;

        [setting setValue:[number stringValue] forKey:@"t_image_quality"];
     
        [us updateGeneralSetting:setting];
    }
    
    
}
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

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    GeneralSettingService* us= [GeneralSettingService getConnection];
    NSDictionary* setting = [us getGeneralSetting];

    NSInteger count=[indexPath row];
    
    NSString *text=[[myData valueForKey:[[myData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:count];

    if([text isEqualToString:@"上传图片质量"])
    {

        InfoSelectController* is = [[InfoSelectController alloc]initWithStyle:UITableViewStyleGrouped];
        is.myData = self.imageQualityData;
        is.myDelegate=self;
        is.tag=1;
        NSString* select = [setting valueForKey:@"t_image_quality"];
        int  currentSelectImageQualityIndex = [select intValue];
        is.currentIndex=currentSelectImageQualityIndex ;
       [ self.navigationController pushViewController:is animated:YES];

    }
    if([text isEqualToString:@"推送通知"])
    {
        PushNotifySwitchController* is = [[PushNotifySwitchController alloc]initWithStyle:UITableViewStyleGrouped];
      
        [ self.navigationController pushViewController:is animated:YES];

    }
}

@end
