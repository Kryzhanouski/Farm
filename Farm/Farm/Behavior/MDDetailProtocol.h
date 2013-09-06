//
//  TRDetailProtocol.h
//  
//
//  Created by Mark Kryzhanouski on 12/5/12.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import <Foundation/Foundation.h>


enum {
    MDDetailStateNormal                 = 0, // detail shows some content
    MDDetailStateWorking                = 1, // detail performs some actions, possible it loads content
    MDDetailStateEmpty                  = 2, // there is no content to show
};
typedef NSUInteger MDDetailState;


/**
 * Basic set of rules for any Detail. Every Detail must conform to TRDetailProtocol protocol.
 */
@protocol MDDetailProtocol <NSObject>

/**
 * Data required by Detail to load its content.
 * Must be KVO-compliant.
 */
@required
@property(strong, nonatomic) id data; //TODO: think about atomicity

/**
 * State of the receiver, see TRDetailState.
 */
@required
@property(assign, nonatomic) MDDetailState state; //TODO: think about atomicity


@end
