//
//  ViewController.m
//  GPIO
//
//  Created by Lyman.j on 2016. 12. 19..
//  Copyright © 2016년 kakao. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <QuartzCore/QuartzCore.h>


NSString const * baseUrl = @"http://14.35.210.32:10";
typedef NS_ENUM(NSUInteger, eState) {
    eStateClose = 0,
    eStateOpen,
};

@interface ViewController ()
@property (nonatomic, strong) AFHTTPSessionManager *afManager;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    self.afManager = [AFHTTPSessionManager manager];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    self.afManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
//    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectZero];
//    loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    loadingView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:loadingView];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loadingView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
//                                                            toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loadingView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loadingView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loadingView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
////    loadingView.hidden = YES;
 
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:self.indicator];
    self.indicator.center = CGPointMake(self.view.center.x, self.btnOpen.center.y - (self.btnOpen.frame.size.height/2));
   
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onOpenDoor:(id)sender {
    NSString *url = [baseUrl stringByAppendingString:@"/door/open"];
    [self.indicator startAnimating];
    [self.afManager POST:url
              parameters:nil
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      [self.indicator stopAnimating];
                     NSLog(@"responseObject = %@",responseObject);
                     NSString *result = [NSString stringWithFormat:@"어서오세요 ^-^"];
                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"문이 열렸어!" message:result preferredStyle:UIAlertControllerStyleAlert];
                     [alert addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil]];
                     [self showViewController:alert sender:nil];
                     [self successOpenDoor:sender];
                     
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      [self.indicator stopAnimating];
                     NSLog(@"error = %@",error);
                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"어엇!문이 안열려!!" message:@"네트워크 오류야.." preferredStyle:UIAlertControllerStyleAlert];
                     [alert addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil]];
                     [self showViewController:alert sender:nil];
//                     [self successOpenDoor:sender];
                 }];
    
}

- (void)successOpenDoor:(id)sender {
//    self.btnOpen.enabled = NO;
//    self.btnOpen.selected = YES;
    [self changeState:eStateOpen];
    [self performSelector:@selector(changeState:) withObject:eStateClose afterDelay:3.0];
}

- (void)changeState:(eState)state {
    
    if (state == eStateClose) {
        self.backgroundImageView.image = [UIImage imageNamed:@"background_close"];
        [self.btnOpen setImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
        self.btnOpen.userInteractionEnabled = YES;
    } else if (state == eStateOpen) {
        self.backgroundImageView.image = [UIImage imageNamed:@"background_open"];
        [self.btnOpen setImage:[UIImage imageNamed:@"btn_open"] forState:UIControlStateNormal];
        self.btnOpen.userInteractionEnabled = NO;
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.backgroundImageView.layer addAnimation:transition forKey:nil];
    
    
    CATransition *transition2 = [CATransition animation];
    transition2.duration = 0.1;
    transition2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition2.type = kCATransitionFade;
    [self.btnOpen.layer addAnimation:transition2 forKey:nil];
}


- (void)showLoadingAnimation {
    
}

- (void)hideLoadingAnimation {
    
}

@end
