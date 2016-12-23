//
//  ViewController.h
//  GPIO
//
//  Created by Lyman.j on 2016. 12. 19..
//  Copyright © 2016년 kakao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) NSString *baseUrl;
@property (weak, nonatomic) IBOutlet UIButton *btnOpen;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (IBAction)onOpenDoor:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onSetting:(id)sender;


@end

