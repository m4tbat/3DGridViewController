//
//  MBTXYAnimator.m
//  3DGridViewController
//
//  Created by Matteo Battaglio on 11/07/14.
//  Copyright (c) 2014 Matteo Battaglio. All rights reserved.
//

#import "MBTXYAnimator.h"

@interface MBTXYAnimator ()

@end

@implementation MBTXYAnimator

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    
    CGRect initialFromFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect initialToFrame = [transitionContext initialFrameForViewController:toViewController];
    
    CGRect finalFromFrame = [transitionContext finalFrameForViewController:fromViewController];
    CGRect finalToFrame = [transitionContext finalFrameForViewController:toViewController];
    
    fromView.frame = initialFromFrame;
    toView.frame = initialToFrame;
    
    [containerView addSubview:toView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
//         usingSpringWithDamping:0.5
//          initialSpringVelocity:7
                        options:0
                     animations:^{
                         fromView.frame = finalFromFrame;
                         toView.frame = finalToFrame;
                     }
                     completion:^(BOOL finished) {
                         if (!finished) {
                             fromView.frame = initialFromFrame;
                             toView.frame = initialToFrame;
                         }
                         
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];                         
                     }];
}

@end
