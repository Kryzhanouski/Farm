//
//  Treatment.h
//  Farm
//
//  Created by Mark Kryzhanouski on 9/13/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Illness;
@class Drug;

@interface Treatment : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * result;
@property (nonatomic, retain) NSManagedObject *animal;
@property (nonatomic, retain) Drug *drug;
@property (nonatomic, retain) Illness *illness;

@end
