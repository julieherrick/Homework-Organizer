//
//  LoginViewController.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/13/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addLoginButton];
}

- (void)addLoginButton {
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = self;

    loginButton.permissions = @[@"public_profile", @"email"];

    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
}

- (void)loginButton:(nonnull FBSDKLoginButton *)loginButton didCompleteWithResult:(nullable FBSDKLoginManagerLoginResult *)result error:(nullable NSError *)error {
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
    NSAssert(error || result, @"Must have a result or an error");

    if (error) {
        return NSLog(@"An Error occurred: %@", error.localizedDescription);
    }

    if (result.isCancelled) {
        return NSLog(@"Login was cancelled");
    }

    NSLog(@"Success. Granted permissions: %@", result.grantedPermissions);

    [self performSegueWithIdentifier:@"loginSegue" sender:self];
}

- (void)loginButtonDidLogOut:(nonnull FBSDKLoginButton *)loginButton {
    [[FBSDKLoginManager new] logOut ];
    NSLog(@"Logged out");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
