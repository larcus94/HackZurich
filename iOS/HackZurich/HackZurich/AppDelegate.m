//
//  AppDelegate.m
//  HackZurich
//
//  Created by Laurin Brandner on 10/10/14.
//  Copyright (c) 2014 Laurin Brandner. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "FeedsViewController.h"
#import "WebService.h"

@interface AppDelegate ()

@property (nonatomic, strong) UITextField* usernameTextField;
@property (nonatomic, strong) UITextField* passwordTextField;
@property (nonatomic, strong) NSArray* actions;

-(void)showLoginViewController;

-(void)loginTextFieldDidChangeValue:(UITextField*)sender;

@end
@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //[application registerForRemoteNotifications];
    
    UITabBarController* controller = [UITabBarController new];
    
    UINavigationController* firstViewController = [[UINavigationController alloc] initWithRootViewController:[FirstViewController new]];
    firstViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"First" image:nil selectedImage:nil];
    UINavigationController* secondViewController = [[UINavigationController alloc] initWithRootViewController:[FeedsViewController new]];
    secondViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Second" image:nil selectedImage:nil];
    
    controller.viewControllers = @[firstViewController, secondViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    
    [[WebService sharedService] getListFeedWithCompletion:nil];
    [self showLoginViewController];
    
    return YES;
}

-(void)showLoginViewController {
    return;
    if (![WebService sharedService].currentUser) {
        UIAlertController* controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Login", nil) message:NSLocalizedString(@"Please login to your GENAU account", nil) preferredStyle:UIAlertControllerStyleAlert];
        [controller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = NSLocalizedString(@"Username", nil);
            [textField addTarget:self action:@selector(loginTextFieldDidChangeValue:) forControlEvents:UIControlEventEditingChanged];
            self.usernameTextField = textField;
        }];
        [controller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = NSLocalizedString(@"Password", nil);
            textField.secureTextEntry = YES;
            [textField addTarget:self action:@selector(loginTextFieldDidChangeValue:) forControlEvents:UIControlEventEditingChanged];
            self.passwordTextField = textField;
        }];
        
        UIAlertAction* signupAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Sign Up", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [[WebService sharedService] registerUser:self.usernameTextField.text withPassword:self.passwordTextField.text withCompletion:^(User* user, NSString* error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                UIAlertController* controller = nil;
                if (user) {
                    controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Success", nil) message:NSLocalizedString(@"You've successfully signed up", nil) preferredStyle:UIAlertControllerStyleAlert];
                    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil]];
                }
                else {
                    controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil) message:error preferredStyle:UIAlertControllerStyleAlert];
                    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [self showLoginViewController];
                    }]];
                }
                [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
            }];
        }];
        signupAction.enabled = NO;
        [controller addAction:signupAction];
        
        UIAlertAction* loginAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Login", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [[WebService sharedService] login:self.usernameTextField.text withPassword:self.passwordTextField.text withCompletion:^(User* user, NSString* error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                UIAlertController* controller = nil;
                if (user) {
                    controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Success", nil) message:NSLocalizedString(@"You've successfully logged in", nil) preferredStyle:UIAlertControllerStyleAlert];
                    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil]];
                }
                else {
                    controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil) message:error preferredStyle:UIAlertControllerStyleAlert];
                    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [self showLoginViewController];
                    }]];
                }
                [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
            }];
        }];
        loginAction.enabled = NO;
        [controller addAction:loginAction];
        
        self.actions = @[loginAction, signupAction];
        
        [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
    }
}

-(void)loginTextFieldDidChangeValue:(UITextField *)sender {
    BOOL enabled = (self.usernameTextField.hasText && self.passwordTextField.hasText);
    for (UIAlertAction* action in self.actions) {
        action.enabled = enabled;
    }
}

- (void) application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [WebService sharedService].deviceToken =[[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
    
   }

- (void) application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [WebService sharedService].deviceToken = nil;
    NSLog(@"Registering device failed: %@", error);
}


- (void) application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    }

@end
