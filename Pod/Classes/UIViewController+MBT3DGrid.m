//
//  UIViewController+MBT3DGrid.m
//  3DGridViewController
//
//  Created Stefano Zanetti on 16/12/14.
//  Copyright (c) 2014 Stefano Zanetti. All rights reserved.
//

#import "UIViewController+MBT3DGrid.h"
#import <objc/runtime.h>

static char MBT3DGridViewControllerKey;

@implementation UIViewController (MBT3DGrid)

- (UIViewController *)gridViewController {
    return objc_getAssociatedObject(self, &MBT3DGridViewControllerKey);
}

- (void)setGridViewController:(UIViewController *)gridViewController {
    objc_setAssociatedObject(self, &MBT3DGridViewControllerKey, gridViewController, OBJC_ASSOCIATION_ASSIGN);
}

@end
