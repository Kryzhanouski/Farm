//
//  MDEditTreatmentViewController.h
//  Farm
//
//  Created by Mark Kryzhanouski on 7/8/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDEditTreatmentViewController : UITableViewController
@property (nonatomic, strong) NSManagedObjectID* cowID;
@property (nonatomic, strong) NSManagedObjectID* treatmentID;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) void(^didAddTreatment)(void);
@property (nonatomic, strong) void(^didCancelAddTreatment)(void);

@end
