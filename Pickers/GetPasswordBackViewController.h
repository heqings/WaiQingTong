//
//  GetPasswordBackViewController.h
//  Pickers
//
//  Created by HeQing on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetPasswordBackViewController : UIViewController
{
    UITextField* mailText;
    UITextField* passwordText;
}
-(IBAction)onBackRegister:(id)sender;
-(IBAction)onGetPasswordBack:(id)sender;
@end
