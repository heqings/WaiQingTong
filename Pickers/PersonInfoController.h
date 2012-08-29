//
//  PersonInfoController.h
//  Pickers
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "User.h"
#import "InfoSelectController.h"
@interface PersonInfoController : UITableViewController<UINavigationControllerDelegate,
UIImagePickerControllerDelegate,UITextFieldDelegate,InfoSelectProtocl>
{
       NSDictionary *myData;
      NSArray *sexData;
      NSArray *regionData;
        BOOL isCamera;
       
    UIImageView* imagePerson;
    UITextField* textRegion;
    UITextField* textSex;
    // 
}
@property (strong,atomic) NSArray* sexData;
@property (strong,atomic) NSArray* regionData;
-(void)downloadTopimage:(id)data;
-(void)uploadTopimage:(id)temp;
-(void)updateTable;
-(void)updateUserInfo:(User*)user;

@end
