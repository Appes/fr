//
//  SeznamCell.m
//  Freeride Parks Info
//
//  Created by David Kratochvíl on 01.12.13.
//  Copyright (c) 2013 Appes developers s.r.o. All rights reserved.
//

#import "SeznamCell.h"

@implementation SeznamCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.37];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
