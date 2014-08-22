//
//  MBTParallaxAnimator.m
//  3DGridViewController
//
//  Created by Matteo Battaglio on 12/08/14.
//  Copyright (c) 2014 Matteo Battaglio. All rights reserved.
//

#import "MBTBackgroundParallaxAnimator.h"

@interface MBTBackgroundParallaxAnimator ()

@property (strong, nonatomic) MBT3DGridViewController *gridController;
@property (assign, nonatomic) CGFloat parallaxRatio;

@end

@implementation MBTBackgroundParallaxAnimator

- (instancetype)initWith3DGridViewController:(MBT3DGridViewController *)gridController parallaxRatio:(CGFloat)parallaxRatio {
    self = [super init];
    if (self) {
        _gridController = gridController;
        _parallaxRatio = parallaxRatio;
        
    }
    return self;
}

- (BOOL)performAnimationAlongsideTransition:(MBT3DGridTransitionDirection)transitionDirection {
    UIView *backgroundView = self.gridController.backgroundView;
    __block CGAffineTransform transform;
    return [[self.gridController transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        switch (transitionDirection) {
            case MBT3DGridTransitionDirectionLeft:
            case MBT3DGridTransitionDirectionRight:
            case MBT3DGridTransitionDirectionTop:
            case MBT3DGridTransitionDirectionBottom:
                transform = [self translationTransformForFrame:backgroundView.frame alongDirection:transitionDirection];
                break;
            case MBT3DGridTransitionDirectionNear:
            case MBT3DGridTransitionDirectionFar:
                transform = [self scaleTransformForFrame:backgroundView.frame alongDirection:transitionDirection];
                break;
        }
        backgroundView.transform = CGAffineTransformConcat(backgroundView.transform, transform);
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if ([context isCancelled]) {
            backgroundView.transform = CGAffineTransformConcat(backgroundView.transform, CGAffineTransformInvert(transform));
        }
    }];
}

- (CGAffineTransform)translationTransformForFrame:(CGRect)frame alongDirection:(MBT3DGridTransitionDirection)transitionDirection {
    CGFloat translation = frame.size.width * self.parallaxRatio;
    CGFloat tx = 0, ty = 0;
    switch (transitionDirection) {
        case MBT3DGridTransitionDirectionLeft:
            tx = translation;
            break;
        case MBT3DGridTransitionDirectionRight:
            tx = -translation;
            break;
        case MBT3DGridTransitionDirectionTop:
            ty = translation;
            break;
        case MBT3DGridTransitionDirectionBottom:
            ty = -translation;
            break;
        default:
            break;
    }
    return CGAffineTransformMakeTranslation(tx, ty);
}

- (CGAffineTransform)scaleTransformForFrame:(CGRect)frame alongDirection:(MBT3DGridTransitionDirection)transitionDirection {
    id<UIViewControllerContextTransitioning> transitionContext = self.gridController.transitionContext;
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect initialFromFrame = [transitionContext initialFrameForViewController:fromViewController];
    
    CGRect finalFromFrame = [transitionContext finalFrameForViewController:fromViewController];
    
    CGFloat scaleFromX = finalFromFrame.size.width / initialFromFrame.size.width;
    CGFloat scaleFromY = finalFromFrame.size.height / initialFromFrame.size.height;
    CGFloat scaleContainerX = 1.0 - (1.0 - scaleFromX) / 3.0;
    CGFloat scaleContainerY = 1.0 - (1.0 - scaleFromY) / 3.0;
    
    return CGAffineTransformMakeScale(scaleContainerX, scaleContainerY);
}

@end
