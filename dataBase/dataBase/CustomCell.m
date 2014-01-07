//
//  CustomCell.m
//  dataBase
//
//  Created by Mac3 on 13-11-22.
//  Copyright (c) 2013年 智文通网络服务有限公司. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = CGRectMake(5, 5, 44, 30);
        [self.btn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
        //[self.btn setImage:[UIImage imageNamed:@"orderButton.png"] forState:UIControlStateNormal];
        
        self.title = [[UILabel alloc]init];
        self.title.frame = CGRectMake(45, 0, 200, 44);
        
        self.deletes = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deletes.frame = CGRectMake(270, 5, 44, 30);
        [self.deletes setImage:[UIImage imageNamed:@"answer.png"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:self.btn];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.deletes];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
