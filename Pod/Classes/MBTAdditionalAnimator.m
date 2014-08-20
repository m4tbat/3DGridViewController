//
//  MBTAdditionalAnimator.m
//  Pods
//
//  Created by Matteo Battaglio on 16/08/14.
//
//

#import "MBTAdditionalAnimator.h"

@interface MBTAdditionalAnimator ()

@property (weak, nonatomic) MBT3DGridViewController *gridController;

@end

@implementation MBTAdditionalAnimator

- (instancetype)initWith3DGridViewController:(MBT3DGridViewController *)gridController {
    self = [super init];
    if (self) {
        _gridController = gridController;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
}

@end
