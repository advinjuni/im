//
//  IMTableViewCell.m
//  IMJabber
//
//  Created by wangjian on 10/24/14.
//  Copyright (c) 2014 Advin. All rights reserved.
//

#import "IMTableViewCell.h"

@implementation IMTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
