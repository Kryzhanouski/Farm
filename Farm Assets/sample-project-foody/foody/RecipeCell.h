//
//  RecipeCell.h
//  foody
//
//  Created by Tope on 01/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface RecipeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *dishImageView;
@property (weak, nonatomic) IBOutlet UILabel *dishTitle;
@property (weak, nonatomic) IBOutlet UILabel *twitterCount;

-(void)setDetailsWithRecipe:(Recipe*)recipe;

@end
