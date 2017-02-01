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
@property (nonatomic, assign) CGPoint faceOrigCenter;
@property (nonatomic, assign) CGPoint trayCenterWhenClose;
@property (nonatomic, strong) UIImageView *newlyCreatedFace;
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
- (IBAction)onSmileyGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        // Gesture recognizers know the view they are attached to
        UIImageView *imageView = (UIImageView *)sender.view;
        
        // Create a new image view that has the same image as the one currently panning
        self.newlyCreatedFace = [[UIImageView alloc] initWithImage:imageView.image];
        
        // Add the new face to the tray's parent view.
        [self.view addSubview:self.newlyCreatedFace];
        
        // Initialize the position of the new face.
        self.newlyCreatedFace.center = imageView.center;
        self.newlyCreatedFace.frame = sender.view.frame; // make them the same size
        self.newlyCreatedFace.contentMode = UIViewContentModeScaleAspectFit;
        self.newlyCreatedFace.userInteractionEnabled = YES;
        
        UIPinchGestureRecognizer * recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        recognizer.delegate = self;
        [self.newlyCreatedFace addGestureRecognizer:recognizer];
        
        // Since the original face is in the tray, but the new face is in the
        // main view, you have to offset the coordinates
        CGPoint faceCenter = self.newlyCreatedFace.center;
        self.newlyCreatedFace.center = CGPointMake(faceCenter.x + self.trayView.frame.origin.x,
                                                   faceCenter.y + self.trayView.frame.origin.y);
        self.faceOrigCenter = self.newlyCreatedFace.center;
        NSLog(@"new face center:%@", NSStringFromCGPoint(self.newlyCreatedFace.center));

    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self.newlyCreatedFace];
        
        self.newlyCreatedFace.center = CGPointMake(self.faceOrigCenter.x + translation.x, self.faceOrigCenter.y + translation.y);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.trayView.layer.cornerRadius = 3;
    self.trayCenterWhenClose = [self.trayView center];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
