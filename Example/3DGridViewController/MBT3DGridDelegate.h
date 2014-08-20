//
//  MBT3DGridDelegate.h
//  metoo White Label
//
//  Created by Matteo Battaglio on 28/07/14.
//  Copyright (c) 2014 metoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBT3DGridViewController.h"

@interface MBT3DGridDelegate : NSObject <MBT3DGridViewControllerDelegate>

- (instancetype)initWithGridController:(MBT3DGridViewController *)gridController;

@end
