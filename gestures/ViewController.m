//
//  ViewController.m
//  gestures
//
//  Created by William Thai on 2/1/17.
//  Copyright © 2017 Y.CORP.YAHOO.COM\willthai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *trayView;
@property (nonatomic, assign) CGPoint trayOrigCenter;
@property (nonatomic, assign) CGPoint trayCenterWhenClose;
@end

static const CGPoint TRAY_OPEN = {207, 543};

@implementation ViewController
- (IBAction)onTrayPanGesture:(UIPanGestureRecognizer *)sender {
    // Absolute (x,y) coordinates in parentView
    CGPoint location = [sender locationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(location));
        self.trayOrigCenter = [self.trayView center];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Gesture changed at: %@", NSStringFromCGPoint(location));
        CGPoint translation = [sender translationInView:self.trayView];

        self.trayView.center = CGPointMake(self.trayOrigCenter.x, self.trayOrigCenter.y + translation.y);
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended at: %@", NSStringFromCGPoint(location));

        CGPoint velocity = [sender velocityInView:self.trayView];
        CGFloat velocityY = velocity.y;
        
        if (velocityY > 0) {
            [UIView animateWithDuration:0.3
                             delay: 0.0
                             options:(UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                             animations:^{
                                 [UIView setAnimationDelegate:self];
                                 self.trayView.center = self.trayCenterWhenClose;
                             }
                             completion: ^(BOOL finished) {
                                 
                             }];
        } else if (velocityY <= 0) {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 [UIView setAnimationDelegate:self];
                                 self.trayView.center = TRAY_OPEN;
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
            
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.trayCenterWhenClose = [self.trayView center];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
