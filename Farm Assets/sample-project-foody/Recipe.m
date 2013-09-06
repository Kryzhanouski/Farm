//
//  Recipe.m
//  foody
//
//  Created by Tope on 04/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Recipe.h"

@implementation Recipe

@synthesize name;
@synthesize thumbNail;
@synthesize twitterShareCount;
@synthesize imageData;


-(void)loadData
{
    NSURL* url = [NSURL URLWithString:self.thumbNail];
    self.imageData = [NSData dataWithContentsOfURL:url];
    
}

@end
