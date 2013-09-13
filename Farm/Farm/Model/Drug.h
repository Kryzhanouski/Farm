//
//  Drug.h
//  Farm
//
//  Created by Mark Kryzhanouski on 9/13/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Treatment;

@interface Drug : NSManagedObject

@property (nonatomic, retain) NSNumber * dose;
@property (nonatomic, retain) NSString * drugDescription;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * validTill;
@property (nonatomic, retain) NSSet *treatments;
@end

@interface Drug (CoreDataGeneratedAccessors)

- (void)addTreatmentsObject:(Treatment *)value;
- (void)removeTreatmentsObject:(Treatment *)value;
- (void)addTreatments:(NSSet *)values;
- (void)removeTreatments:(NSSet *)values;

@end
