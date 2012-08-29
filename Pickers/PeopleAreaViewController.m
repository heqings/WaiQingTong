
////  PeopleAreaViewController.m
//  Pickers
//
//  Created by  on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PeopleAreaViewController.h"
#import "People.h"
#import "PeopleServices.h"
#import "GeneralSettingService.h"
#import "Json.h"
@implementation PeopleAreaViewController
@synthesize areaData,mainData;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
         self.view.frame = CGRectMake(0, 0, 320, 460);
        areaData = nil;
        mainData = nil;
        // Custom initialization
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    if(areaData == nil)
    {
    GeneralSettingService  * gs = [GeneralSettingService getConnection];
    NSDictionary* dic =  [gs getGeneralSetting];
    NSString* area = [dic valueForKey:@"t_area_people"];
    NSDictionary* tt = [area JSONValue];
    NSArray* data  = [tt valueForKey:@"data"]; 
    self.mainData =data;
    }
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

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if(areaData == nil)
    return mainData.count;
    else
        return areaData.count;
}
-(UIImage*)getPeopleTopImage:(People*)p
{
    
    if(![p.topimg isEqualToString:@""])
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        //
        NSString* fileName= [p.topimg lastPathComponent];
        NSString *strPath = [documentsDirectory stringByAppendingPathComponent:fileName];
        
        UIImage* image = [UIImage imageWithContentsOfFile:strPath];
        //
        CGSize size;
        size.width =  36;
        size.height = 36;
        UIGraphicsBeginImageContext(size);  
        // 绘制改变大小的图片  
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];  
        
        // 从当前context中创建一个改变大小后的图片  
        UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();  
        
        // 使当前的context出堆栈  
        UIGraphicsEndImageContext(); 
        return scaledImage;
        
    }else
    {
        UIImage* image = [UIImage imageNamed:@"header36"];
        return image;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    NSDictionary* dic;
    if(areaData == nil)
        dic=[mainData objectAtIndex:indexPath.row];
    else
        dic=[areaData objectAtIndex:indexPath.row];

    cell.textLabel.text = [dic valueForKey:@"name"];
    NSString* type=[dic valueForKey:@"type"];
    if([type isEqualToString:@"Q"])
    {
        cell.imageView.image= [UIImage imageNamed:@"tree_icon"];
    }else
    {
        PeopleServices* ps = [PeopleServices getConnection];
        NSString* spid=[dic valueForKey:@"id"];
        People* p = [ps findBySpId:[spid intValue]];
        cell.imageView.image = [self getPeopleTopImage:p ];
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
    NSDictionary* dic;
    if(areaData == nil)
        dic=[mainData objectAtIndex:indexPath.row];
    else
        dic=[areaData objectAtIndex:indexPath.row];
    NSString* type=[dic valueForKey:@"type"];
    if([type isEqualToString:@"Q"])
    {
        PeopleAreaViewController* ps = [[PeopleAreaViewController alloc]initWithStyle:UITableViewStylePlain];
        ps.areaData = [dic valueForKey:@"childs"];
       
        [self.navigationController pushViewController:ps animated:true];
           
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectMessage" object:nil];
    }

}

@end
