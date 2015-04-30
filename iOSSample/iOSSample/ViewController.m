//
//  ViewController.m
//  iOSSample
//
//  Created by Daniel Albert Sánchez on 30/4/15.
//  Copyright (c) 2015 Zyncro Tech. All rights reserved.
//

#import "ViewController.h"
#import "OauthManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    if ([self.usernameTextField.text length] == 0 || [self.passwordTextField.text length] == 0) {
        self.resultLabel.text = @"Username and/or password cannot be empty";
        return;
    }
    
    [self.view endEditing:YES];
    
    OauthManager *manager = [OauthManager sharedManager];
    [manager oauthLogin:self.usernameTextField.text password:self.passwordTextField.text success:^(NSString *token) {
        self.resultLabel.text = [NSString stringWithFormat:@"Logged with token: %@",token];
    } failure:^(NSError *error) {
        self.resultLabel.text = [NSString stringWithFormat:@"Login error: %@",error.description];
    }];
}


@end
