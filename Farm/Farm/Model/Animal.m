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

- (AnimalType)animalType
{
    return (AnimalType)[self.type integerValue];
}

- (GroupType)groupType
{
    return (GroupType)[self.group integerValue];
}

- (NSString*)groupName
{
    NSString* name = nil;
    switch (self.groupType) {
        case GroupTypeDeadwood:
            name = @"Сухостой";
            break;
        case GroupTypeLowProductivity:
            name = @"Низко продуктивная";
            break;
        case GroupTypeNormalProductivity:
            name = @"Средне продуктивная";
            break;
        case GroupTypeHighlyProductivity:
            name = @"Высоко продуктивная";
            break;
        default:
            break;
    }
    return name;
}
@end
