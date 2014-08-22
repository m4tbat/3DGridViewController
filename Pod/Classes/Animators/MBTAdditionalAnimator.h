//
//  MBTAdditionalAnimator.h
//  Pods
//
//  Created by Matteo Battaglio on 16/08/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBT3DGridViewController.h"

@interface MBTAdditionalAnimator : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype)initWith3DGridViewController:(MBT3DGridViewController *)gridController;

@end
