//
//  Animal.h
//  Farm
//
//  Created by Mark Kryzhanouski on 9/13/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Treatment;

typedef NS_ENUM(NSInteger, AnimalType) {
    AnimalTypeCow   = 0,
    AnimalTypeCalf  = 1,
};


@interface Animal : NSManagedObject

@property (nonatomic, retain) NSString * collar;
@property (nonatomic, retain) NSDate * dateOfBirdth;
@property (nonatomic, retain) NSNumber * group;
@property (nonatomic, retain) NSNumber * isIll;
@property (nonatomic, retain) NSNumber * tag;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSSet *treatments;

@property (nonatomic, readonly) AnimalType animalType;
@end

@interface Animal (CoreDataGeneratedAccessors)

- (void)addTreatmentsObject:(Treatment *)value;
- (void)removeTreatmentsObject:(Treatment *)value;
- (void)addTreatments:(NSSet *)values;
- (void)removeTreatments:(NSSet *)values;

@end
