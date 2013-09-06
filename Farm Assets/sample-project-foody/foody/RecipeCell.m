//
//  RecipeCell.m
//  foody
//
//  Created by Tope on 01/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RecipeCell.h"

@implementation RecipeCell
@synthesize dishImageView;
@synthesize dishTitle;
@synthesize twitterCount;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDetailsWithRecipe:(Recipe*)recipe
{
    dishTitle.text = recipe.name;
    twitterCount.text = [NSString stringWithFormat:@"%d", recipe.twitterShareCount];
    
    
    if(recipe.imageData)
    {
        UIImage *image = [UIImage imageWithData:recipe.imageData];
        dishImageView.image = image;
    }
    else
    {
        [recipe loadData];
        UIImage *image = [UIImage imageWithData:recipe.imageData];
        
        dishImageView.image = image;
    }
}

@end
