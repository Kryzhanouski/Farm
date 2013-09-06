//
//  TRDetailBehaviorSimple.h
//  
//
//  Created by Mark Kryzhanouski on 12/5/12.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDBehaviorProtocol.h"


@protocol MDDetailProtocol;

/**
 * Detail simple strategy.
 * Provides basic behavior of Detail, does nothing.
 */
@interface MDDetailBehaviorSimple : NSObject <MDBehaviorProtocol>
{
@protected
    __unsafe_unretained UIViewController<MDDetailProtocol>* _viewController;
}
@end
