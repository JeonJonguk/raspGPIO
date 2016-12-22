//
//  ViewController.m
//  GPIO
//
//  Created by Lyman.j on 2016. 12. 19..
//  Copyright © 2016년 kakao. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>

NSString const * baseUrl = @"http://14.35.210.32:10";

@interface ViewController ()
@property (nonatomic, strong) AFHTTPSessionManager *afManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    self.afManager = [AFHTTPSessionManager manager];
    self.afManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectZero];
    loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:loadingView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loadingView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loadingView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loadingView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loadingView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
 
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onOpenDoor:(id)sender {
    NSString *url = [baseUrl stringByAppendingString:@"/door/open"];
    
    [self.afManager POST:url
              parameters:nil
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     NSLog(@"responseObject = %@",responseObject);
                     NSString *result = [NSString stringWithFormat:@"어서오세요 ^-^"];
                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"문이 열렸어!" message:result preferredStyle:UIAlertControllerStyleAlert];
                     [alert addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil]];
                     [self showViewController:alert sender:nil];
                     
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     NSLog(@"error = %@",error);
                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"어엇!문이 안열려!!" message:@"네트워크 오류야.." preferredStyle:UIAlertControllerStyleAlert];
                     [alert addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil]];
                     [self showViewController:alert sender:nil];
                     
                 }];
    
}


- (void)showLoadingAnimation {
    
}

- (void)hideLoadingAnimation {
    
}

@end
