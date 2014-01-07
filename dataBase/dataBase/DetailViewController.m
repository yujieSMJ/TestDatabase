//
//  DetailViewController.m
//  dataBase
//
//  Created by tech-Yang on 13-11-15.
//  Copyright (c) 2013年 智文通网络服务有限公司. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=[NSString stringWithFormat:@"section=%d,row=%d",_indexPath.section,_indexPath.row];
    
    self.lbName.text=[NSString stringWithFormat:@"section=%d,row=%d",_indexPath.section,_indexPath.row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
