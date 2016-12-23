//
//  ViewController.h
//  GPIO
//
//  Created by Lyman.j on 2016. 12. 19..
//  Copyright © 2016년 kakao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnOpen;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
- (IBAction)onOpenDoor:(id)sender;

@end

