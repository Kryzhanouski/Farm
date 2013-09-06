//
//  Recipe.h
//  foody
//
//  Created by Tope on 04/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recipe : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *thumbNail;
@property (nonatomic, assign) int twitterShareCount;
@property (nonatomic, retain) NSData* imageData;

-(void)loadData;
@end
