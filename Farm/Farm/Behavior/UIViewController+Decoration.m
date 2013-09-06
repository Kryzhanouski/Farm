//
//  UIViewController+Decoration.m
//  
//
//  Created by Mark Kryzhanouski on 12/5/12.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#if ! __has_feature(objc_arc)
    #error this file needs arc (-fobjc-arc)
#endif


#import <objc/runtime.h>
#import "UIViewController+Decoration.h"
#import "MDBehaviorProtocol.h"

static char const * const BehaviorKey;

@implementation UIViewController (Decoration)

- (id<MDBehaviorProtocol>)behavior {
    return objc_getAssociatedObject(self, &BehaviorKey);
}

- (void)setBehavior:(id<MDBehaviorProtocol>)behavior {
    id<MDBehaviorProtocol> __weak current = self.behavior;
    if (current != behavior) {
        // store new behavior
        objc_setAssociatedObject(self, &BehaviorKey, behavior, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
