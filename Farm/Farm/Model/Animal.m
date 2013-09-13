//
//  Animal.m
//  Farm
//
//  Created by Mark Kryzhanouski on 9/13/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import "Animal.h"
#import "Treatment.h"


@implementation Animal

@dynamic collar;
@dynamic dateOfBirdth;
@dynamic group;
@dynamic isIll;
@dynamic tag;
@dynamic type;
@dynamic treatments;

- (AnimalType)animalType {
    return (AnimalType)[self.type integerValue];
}

@end
