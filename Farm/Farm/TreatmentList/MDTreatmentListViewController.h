//
//  MDTreatmentListViewController.h
//  Farm
//
//  Created by Mark Kryzhanouski on 7/9/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDTreatmentListViewController : UITableViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectID* cowID;

// Actions
@property (nonatomic, strong) void(^didSelectTreatmentAction)(NSManagedObject* treatment);

@end
