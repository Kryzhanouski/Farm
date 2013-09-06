//
//  MDEditDrugViewController.h
//  Farm
//
//  Created by Mark Kryzhanouski on 6/30/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDEditDrugViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectID *objectID;

@end
