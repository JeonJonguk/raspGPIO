//
//  SettingViewController.m
//  GPIO
//
//  Created by Lyman.j on 2016. 12. 23..
//  Copyright © 2016년 kakao. All rights reserved.
//

#import "SettingViewController.h"

NSString * kBaseUrlKey = @"base_url";
NSString * kApiKey = @"api_url";

@interface SettingViewController () <UITextFieldDelegate>

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString* baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kBaseUrlKey];
    if (baseUrl.length > 0) {
        self.baseUrlTextField.text = baseUrl;
    }

    NSString* apiUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kApiKey];
    if (apiUrl.length > 0) {
        self.apiTextField.text = apiUrl;
    }
    
    
    UISwipeGestureRecognizer *downSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipeGestureEvent:)];
    downSwipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:downSwipeGesture];
    
    //다다다
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString* string = textField.text;
    if (textField == self.baseUrlTextField) {
        if (string.length == 0) {
            [self showAlert:@"무엇인가가 잘못되었다!" text:@"url이 없잖아!"];
            return NO;
//        } else if(![string hasPrefix:@"http"]) {
//            [self showAlert:@"무엇인가가 잘못되었다!" text:@"주소가 잘못되었어!"];
//            return NO;
        }
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:kBaseUrlKey];
    } else if(textField == self.apiTextField) {
        if (string.length == 0) {
            [self showAlert:@"무엇인가가 잘못되었다!" text:@"url이 없잖아!"];
            return NO;
        }
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:kApiKey];
    }
    
    [textField resignFirstResponder];
    return YES;
}


- (void)showAlert:(NSString*)title text:(NSString*)text {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil]];
    [self showViewController:alert sender:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)downSwipeGestureEvent:(id)sender {
    [self onDismiss:nil];
}

@end
