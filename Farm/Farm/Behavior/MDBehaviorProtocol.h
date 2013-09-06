//
//  TRBehaviorProtocol.h
//  
//
//  Created by Mark Kryzhanouski on 12/5/12.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * Every strategy must conform to TRBehaviorProtocol protocol.
 */
@protocol MDBehaviorProtocol <NSObject>

///**
// * Implement this method to provide specific setup of a view.
// */
@optional
- (void)decorateView:(UIView *)view;

/**
 * Attaches the receiver to a view controller, and provides specific setup of the view controller.
 */
@required
@property (nonatomic, assign) IBOutlet UIViewController* attachedViewController;

/**
 * Detaches the receiver from the view controller.
 */
@required
- (void)detachFromViewController;

@end
