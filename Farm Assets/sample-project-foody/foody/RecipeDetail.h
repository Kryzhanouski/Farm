//
//  RecipeDetail.h
//  foody
//
//  Created by Tope on 01/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface RecipeDetail : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *dishTitle;
@property (weak, nonatomic) IBOutlet UIImageView *dishImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) Recipe *recipe;

@end
