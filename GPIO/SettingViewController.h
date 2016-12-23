//
//  SettingViewController.h
//  GPIO
//
//  Created by Lyman.j on 2016. 12. 23..
//  Copyright © 2016년 kakao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *baseUrlTextField;
@property (weak, nonatomic) IBOutlet UITextField *apiTextField;
- (IBAction)onDismiss:(id)sender;

@end
