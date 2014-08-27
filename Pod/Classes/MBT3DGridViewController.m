//
//  MBT3DGridViewController.m
//  3DGridViewController
//
//  Created by Matteo Battaglio on 26/06/14.
//  Copyright (c) 2014 Matteo Battaglio. All rights reserved.
//

#import "MBT3DGridViewController.h"
#import <AWPercentDrivenInteractiveTransition.h>
#import "MBTAdditionalAnimator.h"

@interface MBT3DGridViewController () <UIViewControllerContextTransitioning>

@property (assign, nonatomic, readwrite) MBT3DGridTransitionDirection transitionDirection;

@property (strong, nonatomic) UIViewController *currentContentViewController;
@property (strong, nonatomic) UIViewController *nextContentViewController;

@property (assign, nonatomic) BOOL transitionCanceled;
@property (assign, nonatomic) BOOL transitionInteractive;

@property (strong, nonatomic) id<UIViewControllerAnimatedTransitioning> animator;
@property (strong, nonatomic) id<UIViewControllerInteractiveTransitioning> interactionController;

@property (assign, nonatomic) CGFloat percentComplete;

@property (strong, nonatomic, readwrite) id<UIViewControllerContextTransitioning> transitionContext;

@property (strong, nonatomic) MBT3DGridTransitionCoordinator *coordinator;

@property (assign, nonatomic) CGRect initialFromFrame;
@property (assign, nonatomic) CGRect initialToFrame;
@property (assign, nonatomic) CGRect finalFromFrame;
@property (assign, nonatomic) CGRect finalToFrame;

@end

@implementation MBT3DGridViewController

#pragma mark - Inherited

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentContentViewController = [self.dataSource initialViewController];
    [self addChildViewController:self.currentContentViewController];
    [self.currentContentViewController beginAppearanceTransition:YES animated:NO];
    [self.view addSubview:self.currentContentViewController.view];
    [self.currentContentViewController didMoveToParentViewController:self];
    [self.currentContentViewController endAppearanceTransition];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (id<UIViewControllerTransitionCoordinator>)transitionCoordinator {
    return self.coordinator;
}

#pragma mark - Public

- (BOOL)moveAlongDirection:(MBT3DGridTransitionDirection)direction interactively:(BOOL)interactively {
    self.nextContentViewController = [self.dataSource viewControllerForTransitionDirection:direction fromViewController:self.currentContentViewController];
    
    if (self.nextContentViewController) {
        self.transitionDirection = direction;
        
        [self.currentContentViewController willMoveToParentViewController:nil];
        [self addChildViewController:self.nextContentViewController];
        [self.currentContentViewController beginAppearanceTransition:NO animated:[self isAnimated]];
        [self.nextContentViewController beginAppearanceTransition:YES animated:[self isAnimated]];
        
        self.animator = [self.delegate animationControllerForTransitionDirection:direction];
        self.interactionController = interactively ? [self.delegate interactionControllerForTransitionDirection:direction withAnimator:self.animator] : nil;
        
        self.transitionContext = self;
        self.coordinator = [[MBT3DGridTransitionCoordinator alloc] initWith3DGridViewController:self];
        
        if (self.interactionController) {
            self.transitionInteractive = YES;
            [self.interactionController startInteractiveTransition:self];
        }
        else {
            self.transitionInteractive = NO;
            [self.animator animateTransition:self];
        }
        
        return YES;
    }
    else {
        return NO;
    }
    
    return self.nextContentViewController != nil;
}

#pragma mark - Private

- (void)hideContentViewController:(UIViewController *)controller {
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
    [controller endAppearanceTransition];
}

#pragma mark - UIViewControllerContextTransitioning

- (UIView *)containerView {
    return self.view;
}

- (BOOL)isAnimated {
    return YES;
}

- (BOOL)isInteractive {
    return self.transitionInteractive;
}

- (BOOL)transitionWasCancelled {
    return self.transitionCanceled;
}

- (UIModalPresentationStyle)presentationStyle {
    return UIModalPresentationNone;
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    self.percentComplete = percentComplete;
}

- (void)finishInteractiveTransition {
    self.transitionCanceled = NO;
    self.transitionInteractive = NO;
    
    [self.coordinator interactionDidFinish];
    
    NSLog(@"Interactive transition finished");
}

- (void)cancelInteractiveTransition {
    self.transitionCanceled = YES;
    self.transitionInteractive = NO;
    NSLog(@"Interactive transition canceled");
}

- (void)completeTransition:(BOOL)didComplete {
    if (didComplete && ![self transitionWasCancelled]) {
        [self hideContentViewController:self.currentContentViewController];
        [self.nextContentViewController didMoveToParentViewController:self];
        [self.nextContentViewController endAppearanceTransition];
        
        self.currentContentViewController = self.nextContentViewController;
    }
    else {
        [self.nextContentViewController beginAppearanceTransition:NO animated:[self isAnimated]];
        [self hideContentViewController:self.nextContentViewController];
    }
    
    [self.coordinator transitionDidComplete];
    self.coordinator = nil;
    self.transitionContext = nil;
    self.initialFromFrame = CGRectZero;
    self.initialToFrame = CGRectZero;
    self.finalFromFrame = CGRectZero;
    self.finalToFrame = CGRectZero;
}

- (UIViewController *)viewControllerForKey:(NSString *)key {
    if ([key isEqualToString:UITransitionContextToViewControllerKey]) {
        return self.nextContentViewController;
    }
    else if ([key isEqualToString:UITransitionContextFromViewControllerKey]) {
        return self.currentContentViewController;
    }
    else {
        return nil;
    }
}

- (CGRect)initialFrameForViewController:(UIViewController *)vc {
    if (vc == self.currentContentViewController) {
        if (CGRectEqualToRect(self.initialFromFrame, CGRectZero)) {
            self.initialFromFrame = vc.view.frame;
        }
        return self.initialFromFrame;
    }
    else {
        if (CGRectEqualToRect(self.initialToFrame, CGRectZero)) {
            CGRect containerViewFrame = self.view.frame;
            CGPoint offset = CGPointZero;
            CGFloat scale = 1;
            switch (self.transitionDirection) {
                case MBT3DGridTransitionDirectionLeft:
                    offset.x = containerViewFrame.origin.x - containerViewFrame.size.width;
                    break;
                case MBT3DGridTransitionDirectionRight:
                    offset.x = containerViewFrame.origin.x + containerViewFrame.size.width;
                    break;
                case MBT3DGridTransitionDirectionTop:
                    offset.y = containerViewFrame.origin.y - containerViewFrame.size.height;
                    break;
                case MBT3DGridTransitionDirectionBottom:
                    offset.y = containerViewFrame.origin.y + containerViewFrame.size.height;
                    break;
                case MBT3DGridTransitionDirectionNear:
                    scale = 2;
                    break;
                case MBT3DGridTransitionDirectionFar:
                    scale = 0.5;
                    break;
            }
            CGSize size = CGSizeMake(containerViewFrame.size.width * scale, containerViewFrame.size.height * scale);
            self.initialToFrame = CGRectMake(offset.x, offset.y, size.width, size.height);
        }
        return self.initialToFrame;
    }
}

- (CGRect)finalFrameForViewController:(UIViewController *)vc {
    if (vc == self.nextContentViewController) {
        if (CGRectEqualToRect(self.finalToFrame, CGRectZero)) {
            self.finalToFrame = self.view.frame;
        }
        return self.finalToFrame;
    }
    else {
        if (CGRectEqualToRect(self.finalFromFrame, CGRectZero)) {
            CGRect containerViewFrame = self.view.frame;
            CGPoint offset = CGPointZero;
            CGFloat scale = 1;
            switch (self.transitionDirection) {
                case MBT3DGridTransitionDirectionLeft:
                    offset.x = containerViewFrame.origin.x + containerViewFrame.size.width;
                    break;
                case MBT3DGridTransitionDirectionRight:
                    offset.x = containerViewFrame.origin.x - containerViewFrame.size.width;
                    break;
                case MBT3DGridTransitionDirectionTop:
                    offset.y = containerViewFrame.origin.y + containerViewFrame.size.height;
                    break;
                case MBT3DGridTransitionDirectionBottom:
                    offset.y = containerViewFrame.origin.y - containerViewFrame.size.height;
                    break;
                case MBT3DGridTransitionDirectionNear:
                    scale = 0.5;
                    offset.x -= (scale*containerViewFrame.size.width - containerViewFrame.size.width)/2.0;
                    offset.y -= (scale*containerViewFrame.size.height - containerViewFrame.size.height)/2.0;
                    break;
                case MBT3DGridTransitionDirectionFar:
                    scale = 2;
                    offset.x -= (scale*containerViewFrame.size.width - containerViewFrame.size.width)/2.0;
                    offset.y -= (scale*containerViewFrame.size.height - containerViewFrame.size.height)/2.0;
                    break;
            }
            CGSize size = CGSizeMake(containerViewFrame.size.width * scale, containerViewFrame.size.height * scale);
            self.finalFromFrame = CGRectMake(offset.x, offset.y, size.width, size.height);
        }
        return self.finalFromFrame;
    }
}

@end



#pragma mark -

@interface MBT3DGridTransitionCoordinator ()

@property (weak, nonatomic) MBT3DGridViewController *gridController;
@property (assign, nonatomic) BOOL initiatedInteractively;

@property (copy, nonatomic) void (^interactionFinishedHandler)(id<UIViewControllerTransitionCoordinatorContext> context);
@property (copy, nonatomic) void (^transitionCompletedHandler)(id<UIViewControllerTransitionCoordinatorContext> context);

@property (strong, nonatomic) AWPercentDrivenInteractiveTransition *interactionController;

@end

@implementation MBT3DGridTransitionCoordinator

- (instancetype)initWith3DGridViewController:(MBT3DGridViewController *)gridController {
    self = [super init];
    if (self) {
        _gridController = gridController;
        _initiatedInteractively = [gridController isInteractive];
    }
    return self;
}

- (void)transitionDidComplete {
    if (self.transitionCompletedHandler) {
        self.transitionCompletedHandler(self);
    }
}

- (void)interactionDidFinish {
    if (self.interactionFinishedHandler) {
        self.interactionFinishedHandler(self);
    }
}

// Any animations specified will be run in the same animation context as the
// transition. If the animations are occurring in a view that is a not
// descendent of the containerView, then an ancestor view in which all of the
// animations are occuring should be specified.  The completionBlock is invoked
// after the transition completes. (Note that this may not be after all the
// animations specified by to call complete if the duration is not inherited.)
// It is perfectly legitimate to only specify a completion block. This method
// returns YES if the animations are successfully queued to run. The completions
// may be run even if the animations are not. Note that for transitioning
// animators that are not implemented with UIView animations, the alongside
// animations will be run just after their animateTransition: method returns.
//
- (BOOL)animateAlongsideTransition:(void (^)(id <UIViewControllerTransitionCoordinatorContext>context))animation
                        completion:(void (^)(id <UIViewControllerTransitionCoordinatorContext>context))completion {
    self.transitionCompletedHandler = completion;
    
    [UIView animateWithDuration:[self.gridController.animator transitionDuration:self.gridController] animations:^{
        if (animation) {
            animation(self);
        }
    }];
    
    return YES;
}

// This alternative API is needed if the view is not a descendent of the container view AND you require this animation
// to be driven by a UIPercentDrivenInteractiveTransition interaction controller.
- (BOOL)animateAlongsideTransitionInView:(UIView *)view
                               animation:(void (^)(id <UIViewControllerTransitionCoordinatorContext>context))animation
                              completion:(void (^)(id <UIViewControllerTransitionCoordinatorContext>context))completion {
    self.transitionCompletedHandler = completion;
    
    self.interactionController = [[AWPercentDrivenInteractiveTransition alloc] initWithAnimator:[[MBTAdditionalAnimator alloc] initWith3DGridViewController:self.gridController]];

    if (animation) {
        animation(self);
        return YES;
    }
    return YES;
}

// When a transition changes from interactive to non-interactive then handler is
// invoked. The handler will typically then do something depending on whether or
// not the transition isCancelled. Note that only interactive transitions can
// be cancelled and all interactive transitions complete as non-interactive
// ones. In general, when a transition is cancelled the view controller that was
// appearing will receive a viewWillDisappear: call, and the view controller
// that was disappearing will receive a viewWillAppear: call.  This handler is
// invoked BEFORE the "will" method calls are made.
- (void)notifyWhenInteractionEndsUsingBlock: (void (^)(id <UIViewControllerTransitionCoordinatorContext>context))handler {
    self.interactionFinishedHandler = handler;
}

// Most of the time isAnimated will be YES. For custom transitions that use the
// new UIModalPresentationCustom presentation type we invoke the
// animateTransition: even though the transition is not animated. (This allows
// the custom transition to add or remove subviews to the container view.)
- (BOOL)isAnimated {
    return [self.gridController isAnimated];
}

// A modal presentation style whose transition is being customized or UIModaPresentationNone if this is not a modal presentation
// or dismissal.
- (UIModalPresentationStyle)presentationStyle {
    return UIModalPresentationNone;
}

// initiallyInteractive can only be YES if isAnimated is YES. It never changes during the course of a transition. This indicates whether the transition
// was initiated as an interactive transition. If this is no, isInteractive can not be YES.
- (BOOL)initiallyInteractive {
    return self.initiatedInteractively;
}

// Interactive transitions have non-interactive segments. For example, they all complete non-interactively. Some interactive transitions may have
// intermediate segments that are not interactive.
- (BOOL)isInteractive {
    return [self.gridController isInteractive];
}

// isCancelled is usually NO. It is only set to YES for an interactive transition that was cancelled.
- (BOOL)isCancelled {
    return [self.gridController transitionWasCancelled];
}

// The full expected duration of the transition if it is run non-interactively.
- (NSTimeInterval)transitionDuration {
    return [self.gridController.animator transitionDuration:self.gridController];
}

// These three methods are potentially meaningful for interactive transitions that are
// completing. It reports the percent complete of the transition when it moves
// to the non-interactive completion phase of the transition.
- (CGFloat)percentComplete {
    return self.gridController.percentComplete;
}

- (CGFloat)completionVelocity {
    if ([self.gridController.interactionController respondsToSelector:@selector(completionSpeed)]) {
        return [self.gridController.interactionController completionSpeed];
    }
    else {
        return 1;
    }
}

- (UIViewAnimationCurve)completionCurve {
    if ([self.gridController.interactionController respondsToSelector:@selector(completionCurve)]) {
        return [self.gridController.interactionController completionCurve];
    }
    else {
        return UIViewAnimationCurveEaseInOut;
    }
}

- (UIViewController *)viewControllerForKey:(NSString *)key {
    return [self.gridController viewControllerForKey:key];
}

- (UIView *)containerView {
    return [self.gridController containerView];
}

@end
