//
//  MBT3DGridDataSource.m
//  3DGridViewController
//
//  Created by Matteo Battaglio on 28/07/14.
//  Copyright (c) 2014 Matteo Battaglio. All rights reserved.
//

#import "MBT3DGridDataSource.h"
#import <UIViewController+MBT3DGrid.h>

typedef struct {
    CGFloat x, y, z;
} MBT3DPoint;

@interface MBT3DGridDataSource ()

@property (strong, nonatomic) NSMutableDictionary *contentViewControllers;
@property (assign, nonatomic) MBT3DPoint currentPosition;
@property (assign, nonatomic) MBT3DPoint oldPosition;

@end



@implementation MBT3DGridDataSource

- (id)init {
    self = [super init];
    if (self) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        
        self.contentViewControllers = [NSMutableDictionary dictionary];
        self.contentViewControllers[@"1-0-1"] = [mainStoryboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
        self.contentViewControllers[@"1-1-1"] = [mainStoryboard instantiateViewControllerWithIdentifier:@"CentralViewController"];
        self.contentViewControllers[@"0-1-1"] = [mainStoryboard instantiateViewControllerWithIdentifier:@"TopViewController"];
        self.contentViewControllers[@"1-2-1"] = [mainStoryboard instantiateViewControllerWithIdentifier:@"RightViewController"];
        self.contentViewControllers[@"2-1-1"] = [mainStoryboard instantiateViewControllerWithIdentifier:@"BottomViewController"];
        self.contentViewControllers[@"1-1-2"] = [mainStoryboard instantiateViewControllerWithIdentifier:@"NearViewController"];
        self.contentViewControllers[@"1-1-0"] = [mainStoryboard instantiateViewControllerWithIdentifier:@"FarViewController"];
        
        self.currentPosition = (MBT3DPoint){ 1, 1, 1 };
    }
    return self;
}

#pragma mark - Private

- (UIViewController *)currentViewController {
    return [self viewControllerAtPosition:self.currentPosition];
}

- (UIViewController *)viewControllerAtPosition:(MBT3DPoint)position {
    NSString *positionString = [self keyFromPosition:position];
    return self.contentViewControllers[positionString];
}

- (NSString *)keyFromPosition:(MBT3DPoint)position {
    return [NSString stringWithFormat:@"%.0f-%.0f-%.0f", position.y, position.x, position.z];
}

#pragma mark - MBT3DGridViewControllerDataSource

- (UIViewController *)initialViewController {
    return [self currentViewController];
}

- (UIViewController *)viewControllerForTransitionDirection:(MBT3DGridTransitionDirection)direction
                                        fromViewController:(UIViewController *)currentViewController {
    if (currentViewController != [self currentViewController]) {
        self.currentPosition = self.oldPosition;
    }
    
    MBT3DPoint newPosition = { 0, 0, 0 };
    
    switch (direction) {
        case MBT3DGridTransitionDirectionLeft:
            newPosition = (MBT3DPoint){ self.currentPosition.x - 1, self.currentPosition.y, self.currentPosition.z };
            break;
        case MBT3DGridTransitionDirectionRight:
            newPosition = (MBT3DPoint){ self.currentPosition.x + 1, self.currentPosition.y, self.currentPosition.z };
            break;
        case MBT3DGridTransitionDirectionTop:
            newPosition = (MBT3DPoint){ self.currentPosition.x, self.currentPosition.y - 1, self.currentPosition.z };
            break;
        case MBT3DGridTransitionDirectionBottom:
            newPosition = (MBT3DPoint){ self.currentPosition.x, self.currentPosition.y + 1, self.currentPosition.z };
            break;
        case MBT3DGridTransitionDirectionNear:
            newPosition = (MBT3DPoint){ self.currentPosition.x, self.currentPosition.y, self.currentPosition.z + 1};
            break;
        case MBT3DGridTransitionDirectionFar:
            newPosition = (MBT3DPoint){ self.currentPosition.x, self.currentPosition.y, self.currentPosition.z - 1 };
            break;
    }
    
    if ([self viewControllerAtPosition:newPosition]) {
        self.oldPosition = self.currentPosition;
        self.currentPosition = newPosition;
        return [self currentViewController];
    }
    else {
        return nil;
    }
}

@end
