//
//  MBTParallaxAnimator.h
//  3DGridViewController
//
//  Created by Matteo Battaglio on 12/08/14.
//  Copyright (c) 2014 Matteo Battaglio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBT3DGridViewController.h>

@interface MBTBackgroundParallaxAnimator : NSObject

- (instancetype)initWith3DGridViewController:(MBT3DGridViewController *)gridController parallaxRatio:(CGFloat)parallaxRatio;

- (BOOL)performAnimationAlongsideTransition:(MBT3DGridTransitionDirection)transitionDirection;

@end
