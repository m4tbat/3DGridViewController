//
//  MEViewController.h
//  metoo White Label
//
//  Created by Matteo Battaglio on 26/06/14.
//  Copyright (c) 2014 metoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MBT3DGridTransitionDirection) {
    MBT3DGridTransitionDirectionLeft = 1 << 0,
    MBT3DGridTransitionDirectionRight = -MBT3DGridTransitionDirectionLeft,
    MBT3DGridTransitionDirectionTop = 1 << 1,
    MBT3DGridTransitionDirectionBottom = -MBT3DGridTransitionDirectionTop,
    MBT3DGridTransitionDirectionNear = 1 << 2,
    MBT3DGridTransitionDirectionFar = -MBT3DGridTransitionDirectionNear
};

@protocol MBT3DGridViewControllerDataSource <NSObject>

- (UIViewController *)initialViewController;

- (UIViewController *)viewControllerForTransitionDirection:(MBT3DGridTransitionDirection)direction fromViewController:(UIViewController *)currentViewController;

@end



@protocol MBT3DGridViewControllerDelegate <NSObject>

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForTransitionDirection:(MBT3DGridTransitionDirection)direction;

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForTransitionDirection:(MBT3DGridTransitionDirection)direction withAnimator:(id <UIViewControllerAnimatedTransitioning>)animator;

@end

#pragma mark -

@interface MBT3DGridViewController : UIViewController

@property (weak, nonatomic) id <MBT3DGridViewControllerDataSource> dataSource;

@property (weak, nonatomic) id <MBT3DGridViewControllerDelegate> delegate;

@property (assign, nonatomic, readonly) MBT3DGridTransitionDirection transitionDirection;

@property (strong, nonatomic, readonly) id<UIViewControllerContextTransitioning> transitionContext;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

/**
 *  <#Description#>
 *
 *  @param direction <#direction description#>
 */
- (BOOL)moveAlongDirection:(MBT3DGridTransitionDirection)direction interactively:(BOOL)interactively;

@end

#pragma mark -

@interface MBT3DGridTransitionCoordinator : NSObject<UIViewControllerTransitionCoordinator>

- (instancetype)initWith3DGridViewController:(MBT3DGridViewController *)gridController;

- (void)transitionDidComplete;

- (void)interactionDidFinish;

@end