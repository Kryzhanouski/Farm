//
//  Illness.h
//  Farm
//
//  Created by Mark Kryzhanouski on 9/13/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Illness : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *treatments;
@end

@interface Illness (CoreDataGeneratedAccessors)

- (void)addTreatmentsObject:(NSManagedObject *)value;
- (void)removeTreatmentsObject:(NSManagedObject *)value;
- (void)addTreatments:(NSSet *)values;
- (void)removeTreatments:(NSSet *)values;

@end
