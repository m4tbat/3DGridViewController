//
//  MBT3DGridDelegate.m
//  metoo White Label
//
//  Created by Matteo Battaglio on 28/07/14.
//  Copyright (c) 2014 metoo. All rights reserved.
//

#import "MBT3DGridDelegate.h"
#import "MBTXYAnimator.h"
#import "MBTZAnimator.h"
#import "MBTBackgroundParallaxAnimator.h"
#import <AWPercentDrivenInteractiveTransition/AWPercentDrivenInteractiveTransition.h>

@interface MBT3DGridDelegate ()

@property (strong, nonatomic) id <UIViewControllerAnimatedTransitioning> xyAnimationController;
@property (strong, nonatomic) id <UIViewControllerAnimatedTransitioning> zAnimationController;
@property (strong, nonatomic) AWPercentDrivenInteractiveTransition *interactionController;

@property (assign, nonatomic) MBT3DGridTransitionDirection transitionDirection;
@property (weak, nonatomic) MBT3DGridViewController *gridController;

@end

@implementation MBT3DGridDelegate

#pragma mark - MBT3DGridViewControllerDelegate

- (instancetype)initWithGridController:(MBT3DGridViewController *)gridController {
    self = [super init];
    if (self) {
        _gridController = gridController;
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
        
        [_gridController.view addGestureRecognizer:panGestureRecognizer];
        [_gridController.view addGestureRecognizer:pinchGestureRecognizer];
    }
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForTransitionDirection:(MBT3DGridTransitionDirection)direction {
    switch (direction) {
        case MBT3DGridTransitionDirectionLeft:
        case MBT3DGridTransitionDirectionRight:
        case MBT3DGridTransitionDirectionTop:
        case MBT3DGridTransitionDirectionBottom:
            if (!self.xyAnimationController) {
                self.xyAnimationController = [[MBTXYAnimator alloc] init];
            }
            return self.xyAnimationController;
            
        case MBT3DGridTransitionDirectionNear:
        case MBT3DGridTransitionDirectionFar:
            if (!self.zAnimationController) {
                self.zAnimationController = [[MBTZAnimator alloc] init];
            }
            return self.zAnimationController;
    }
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForTransitionDirection:(MBT3DGridTransitionDirection)direction withAnimator:(id <UIViewControllerAnimatedTransitioning>)animator {
    self.interactionController = [[AWPercentDrivenInteractiveTransition alloc] initWithAnimator:animator];
    
    return self.interactionController;
}

#pragma mark - Private

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    //    UIPanGestureRecognizer *gestureRecognizer = sender;
    
    CGPoint translation = [gestureRecognizer translationInView:nil];
    CGPoint velocity = [gestureRecognizer velocityInView:nil];
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            if (fabs(translation.x) >= fabs(translation.y)) {
                self.transitionDirection = translation.x > 0 ? MBT3DGridTransitionDirectionLeft : MBT3DGridTransitionDirectionRight;
            }
            else {
                self.transitionDirection = translation.y > 0 ? MBT3DGridTransitionDirectionTop : MBT3DGridTransitionDirectionBottom;
            }
            
            BOOL started = [self.gridController moveAlongDirection:self.transitionDirection interactively:YES];
            
            if (started) {
                MBTBackgroundParallaxAnimator *parallaxAnimator = [[MBTBackgroundParallaxAnimator alloc] initWith3DGridViewController:self.gridController parallaxRatio:1.0/3.0];
                [parallaxAnimator performAnimationAlongsideTransition:self.transitionDirection];
            }
            else {
                gestureRecognizer.enabled = NO;
                gestureRecognizer.enabled = YES;
            }
            break;
            
        case UIGestureRecognizerStateChanged:
            [self.interactionController updateInteractiveTransition:[self percentFromTranslation:translation]];
            break;
            
        case UIGestureRecognizerStateEnded: {
            CGFloat percentComplete = [self percentFromTranslation:translation];
            CGFloat usefulVelocity = [self usefulVelocity:velocity];
            
            if ((percentComplete >= 0.5 && usefulVelocity >= -100) || usefulVelocity >= 100.0) {
                [self.interactionController finishInteractiveTransition];
            }
            else {
                [self.interactionController cancelInteractiveTransition];
            }
        } break;
            
        case UIGestureRecognizerStateCancelled:
            [self.interactionController cancelInteractiveTransition];
            break;
            
        default:
            break;
    }
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)gestureRecognizer {
    CGFloat scale = gestureRecognizer.scale;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.transitionDirection = scale > 1 ? MBT3DGridTransitionDirectionFar : MBT3DGridTransitionDirectionNear;
            
            BOOL started = [self.gridController moveAlongDirection:self.transitionDirection interactively:YES];
            
            if (started) {
                MBTBackgroundParallaxAnimator *parallaxAnimator = [[MBTBackgroundParallaxAnimator alloc] initWith3DGridViewController:self.gridController parallaxRatio:1.0/3.0];
                [parallaxAnimator performAnimationAlongsideTransition:self.transitionDirection];
            }
            else {
                gestureRecognizer.enabled = NO;
                gestureRecognizer.enabled = YES;
            }
            break;
            
        case UIGestureRecognizerStateChanged: {
            CGFloat percentComplete;
            if (self.transitionDirection == MBT3DGridTransitionDirectionFar) {
                percentComplete = -0.5 * (1 - scale);
            }
            else {
                percentComplete = 1.5 * (1 - scale);
            }
            if (percentComplete > 1) {
                percentComplete = 1;
            }
            else if (percentComplete < 0) {
                percentComplete = 0;
            }
            NSLog(@"Pinch percent complete: %.0f", percentComplete*100);
            [self.interactionController updateInteractiveTransition:percentComplete];
        } break;
            
        case UIGestureRecognizerStateEnded: {
            CGFloat percentComplete = (scale > 1 ? scale : (1.0/scale)) / 3.0;
            CGFloat usefulVelocity = gestureRecognizer.velocity;
            
            if ((percentComplete >= 0.5 && usefulVelocity >= -100) || usefulVelocity >= 100.0) {
                [self.interactionController finishInteractiveTransition];
            }
            else {
                [self.interactionController cancelInteractiveTransition];
            }
        } break;
            
        case UIGestureRecognizerStateCancelled:
            [self.interactionController cancelInteractiveTransition];
            break;
            
        default:
            break;
    }
}

- (CGFloat)percentFromTranslation:(CGPoint)translation {
    CGFloat percentComplete = 0.0;
    UIView *containerView = self.gridController.view;
    switch (self.transitionDirection) {
        case MBT3DGridTransitionDirectionLeft:
            percentComplete = translation.x / containerView.frame.size.width;
            break;
        case MBT3DGridTransitionDirectionRight:
            percentComplete = -(translation.x / containerView.frame.size.width);
            break;
        case MBT3DGridTransitionDirectionTop:
            percentComplete = translation.y / containerView.frame.size.height;
            break;
        case MBT3DGridTransitionDirectionBottom:
            percentComplete = -(translation.y / containerView.frame.size.height);
            break;
        case MBT3DGridTransitionDirectionNear:
            break;
        case MBT3DGridTransitionDirectionFar:
            break;
    }
    if (percentComplete < 0.0) {
        percentComplete = 0.0;
    }
    return percentComplete;
}

- (CGFloat)usefulVelocity:(CGPoint)velocity {
    CGFloat usefulVelocity = 0.0;
    switch (self.transitionDirection) {
        case MBT3DGridTransitionDirectionLeft:
            usefulVelocity = velocity.x;
            break;
        case MBT3DGridTransitionDirectionRight:
            usefulVelocity = -velocity.x;
            break;
        case MBT3DGridTransitionDirectionTop:
            usefulVelocity = velocity.y;
            break;
        case MBT3DGridTransitionDirectionBottom:
            usefulVelocity = -velocity.y;
            break;
        case MBT3DGridTransitionDirectionNear:
            break;
        case MBT3DGridTransitionDirectionFar:
            break;
    }
    return usefulVelocity;
}

@end
