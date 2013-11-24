//
//  Treatment.h
//  Farm
//
//  Created by Mark on 11/24/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Animal, Drug, Illness;

@interface Treatment : NSManagedObject

@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * result;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) Animal *animal;
@property (nonatomic, retain) Drug *drug;
@property (nonatomic, retain) Illness *illness;

@end
