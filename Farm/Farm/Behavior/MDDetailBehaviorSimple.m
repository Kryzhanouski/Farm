//
//  TRDetailBehaviorSimple.m
//  
//
//  Created by Mark Kryzhanouski on 12/5/12.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import "MDDetailBehaviorSimple.h"
#import "MDDetailProtocol.h"
#import "UIViewController+Decoration.h"



@implementation MDDetailBehaviorSimple
@synthesize attachedViewController = _viewController;

- (void)dealloc {
    [self detachFromViewController];
}


#pragma mark TRStrategyDecoratorProtocol

- (void)setAttachedViewController:(UIViewController *)attachedViewController {
    if (_viewController) {
        [self detachFromViewController];
        [_viewController setBehavior:nil];
    }
    _viewController = (UIViewController<MDDetailProtocol> *)attachedViewController;
    [_viewController setBehavior:self];
}

- (void)detachFromViewController {
    _viewController = nil;
}

@end
