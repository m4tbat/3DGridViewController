//
//  MBTZAnimator.m
//  3DGridViewController
//
//  Created by Matteo Battaglio on 08/08/14.
//  Copyright (c) 2014 Matteo Battaglio. All rights reserved.
//

#import "MBTZAnimator.h"

@implementation MBTZAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    
    CGRect initialFromFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect initialToFrame = [transitionContext initialFrameForViewController:toViewController];
    
    CGRect finalFromFrame = [transitionContext finalFrameForViewController:fromViewController];
    CGRect finalToFrame = [transitionContext finalFrameForViewController:toViewController];
    
    CGFloat scaleFromX = finalFromFrame.size.width / initialFromFrame.size.width;
    CGFloat scaleFromY = finalFromFrame.size.height / initialFromFrame.size.height;
    CGFloat scaleToX = initialToFrame.size.width / finalToFrame.size.width;
    CGFloat scaleToY = initialToFrame.size.height / finalToFrame.size.height;
    
    toView.transform = CGAffineTransformMakeScale(scaleToX, scaleToY);
    toView.alpha = 0;
    
    [containerView addSubview:toView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
     //         usingSpringWithDamping:0.5
     //          initialSpringVelocity:7
                        options:0
                     animations:^{
                         fromView.transform = CGAffineTransformMakeScale(scaleFromX, scaleFromY);
                         fromView.alpha = 0;
                         toView.transform = CGAffineTransformIdentity;
                         toView.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         if (!finished) {
                             fromView.transform = CGAffineTransformIdentity;
                             fromView.alpha = 1;
                         }
                         
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end
