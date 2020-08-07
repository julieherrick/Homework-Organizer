//
//  LoginViewController.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/13/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "LoginViewController.h"
@import Parse;
#import "Assignment.h"

@interface LoginViewController ()
@property (strong, nonatomic) FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *hwOrganizerLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self addLoginButton];
    self.loginButton = [[FBSDKLoginButton alloc] init];
        self.loginButton.delegate = self;

        self.loginButton.permissions = @[@"public_profile", @"email"];

        self.loginButton.center = self.view.center;
    //    loginButton.size
        self.loginButton.center = CGPointMake(self.view.center.x,  self.hwOrganizerLabel.center.y+20);
        [self.view addSubview:self.loginButton];
//    [self facebookLogin];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        self.loginButton.alpha = 0;
    } else {
        self.loginButton.alpha = 1;
    }
}

-(void)facebookLogin {
    [PFFacebookUtils logInInBackgroundWithReadPermissions:@[@"public_profile", @"email"] block:^(PFUser *user, NSError *error) {
      if (!user) {
        NSLog(@"Uh oh. The user cancelled the Facebook login.");
      } else if (user.isNew) {
        NSLog(@"User signed up and logged in through Facebook!");
      } else {
        NSLog(@"User logged in through Facebook!");
      }
    }];
}

- (void)addLoginButton {
    self.loginButton = [[FBSDKLoginButton alloc] init];
    self.loginButton.delegate = self;

    self.loginButton.permissions = @[@"public_profile", @"email"];

    self.loginButton.center = self.view.center;
//    loginButton.size
    self.loginButton.center = CGPointMake(self.view.center.x,  self.hwOrganizerLabel.center.y+20);
    [self.view addSubview:self.loginButton];
}

- (void)loginButton:(nonnull FBSDKLoginButton *)loginButton didCompleteWithResult:(nullable FBSDKLoginManagerLoginResult *)result error:(nullable NSError *)error {
    
    NSAssert(error || result, @"Must have a result or an error");
    
    if (error) {
        return NSLog(@"An Error occurred: %@", error.localizedDescription);
    }
    
    if (result.isCancelled) {
        return NSLog(@"Login was cancelled");
    }
    [PFFacebookUtils logInInBackgroundWithAccessToken:[FBSDKAccessToken currentAccessToken] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. There was an error logging in.");
        } else {
            NSLog(@"User logged in through Facebook!");
            NSLog(@"Success. Granted permissions: %@", result.grantedPermissions);
            self.loginButton.alpha = 0;
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
    }];
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
