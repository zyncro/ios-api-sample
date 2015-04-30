//
//  ViewController.h
//  iOSSample
//
//  Created by Daniel Albert Sánchez on 30/4/15.
//  Copyright (c) 2015 Zyncro Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

- (IBAction)loginAction:(id)sender;

@end

