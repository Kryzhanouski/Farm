//
//  UIViewController+Decoration.h
//  
//
//  Created by Mark Kryzhanouski on 12/5/12.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MDBehaviorProtocol;

@interface UIViewController (Decoration)

- (id<MDBehaviorProtocol>)behavior;
- (void)setBehavior:(id<MDBehaviorProtocol>)behavior;

@end
