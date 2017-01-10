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
#import <AudioToolbox/AudioToolbox.h>


//NSString const * baseUrl = @"http://14.35.210.32:10";
static NSString * kBaseUrlKey = @"base_url";
static NSString * kApiKey = @"api_url";
typedef NS_ENUM(NSUInteger, eState) {
    eStateClose = 0,
    eStateOpen,
};

@interface ViewController ()
@property (nonatomic, strong) AFHTTPSessionManager *afManager;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, assign) BOOL isNetworking;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.afManager = [AFHTTPSessionManager manager];
    _isNetworking = NO;
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    self.afManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.afManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.afManager.requestSerializer.timeoutInterval = 5.0;
    
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicator.center = CGPointMake(self.view.center.x, self.btnOpen.center.y - (self.btnOpen.frame.size.height/2) );
    [self.view addSubview:self.indicator];
    
    
    //SHAKE
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    //Swipe
    UISwipeGestureRecognizer *upSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwipeGestureEvent:)];
    upSwipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:upSwipeGesture];
    
    //buttons options
    self.btnBack.alpha = 0.0;
    
}


-(void)viewDidDisappear {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onOpenDoor:(id)sender {
    self.baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kBaseUrlKey];
    if (self.baseUrl.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"URL이 없어!" message:@"설정에서 IP주소를 입력해!" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil]];
        [self showViewController:alert sender:nil];
        return;
    }
    
    NSString *api = [[NSUserDefaults standardUserDefaults] objectForKey:kApiKey];
    if (api.length == 0) {
        api = @"/door/open";
        [[NSUserDefaults standardUserDefaults] setObject:api forKey:kApiKey];
    }
    NSString *url = [self.baseUrl stringByAppendingString:api];
    [self.indicator startAnimating];
    if (_isNetworking == NO) {
        _isNetworking = YES;
        [self.afManager POST:url
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         [self.indicator stopAnimating];
                         NSLog(@"responseObject = %@",responseObject);
                         //                     NSString *result = [NSString stringWithFormat:@"어서오세요 ^-^"];
                         //                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"문이 열렸어!" message:result preferredStyle:UIAlertControllerStyleAlert];
                         //                     [alert addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil]];
                         //                     [self showViewController:alert sender:nil];
                         [self successOpenDoor:sender];
                         _isNetworking = NO;
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         [self.indicator stopAnimating];
                         NSLog(@"error = %@",error);
                         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"어엇!문이 안열려!!" message:@"네트워크 오류야.." preferredStyle:UIAlertControllerStyleAlert];
                         [alert addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil]];
                         [self showViewController:alert sender:nil];
                         _isNetworking = NO;
                     }];
    }
    
}

- (IBAction)onBack:(id)sender {
    [self changeState:eStateClose];
}

- (IBAction)onSetting:(id)sender {
    
}

- (void)successOpenDoor:(id)sender {

    [self changeState:eStateOpen];
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"open" ofType:@"mp3"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundPath], &soundID);
    AudioServicesPlaySystemSound(soundID);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)changeState:(eState)state {
    float fromAlpha = 0.0;
    float endAlpha = 0.0;
    float bgDuration = 0.5;
    float btnDuration = 0.1;
    
    if (state == eStateClose) {
        self.backgroundImageView.image = [UIImage imageNamed:@"background_close"];
        [self.btnOpen setImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
        self.btnOpen.userInteractionEnabled = YES;
        fromAlpha = 1.0;
        endAlpha = 0.0;
        bgDuration = 0.2;
        btnDuration = 0.1;
        
    } else if (state == eStateOpen) {
        self.backgroundImageView.image = [UIImage imageNamed:@"background_open"];
        [self.btnOpen setImage:[UIImage imageNamed:@"btn_open"] forState:UIControlStateNormal];
        self.btnOpen.userInteractionEnabled = NO;
        fromAlpha = 0.0;
        endAlpha = 1.0;
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = bgDuration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.backgroundImageView.layer addAnimation:transition forKey:nil];
    
    
    CATransition *transition2 = [CATransition animation];
    transition2.duration = btnDuration;
    transition2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition2.type = kCATransitionFade;
    [self.btnOpen.layer addAnimation:transition2 forKey:nil];
    
    
    [UIView animateWithDuration:bgDuration animations:^{
        self.btnBack.alpha = fromAlpha;
    } completion:^(BOOL finished) {
        self.btnBack.alpha = endAlpha;
    }];
    //가
    //나
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
    {
        [self changeState:eStateClose];
    }
}

- (void)upSwipeGestureEvent:(id)sender {
    
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewControllerID"] animated:YES completion:nil];
}

@end
