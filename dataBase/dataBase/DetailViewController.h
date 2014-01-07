//
//  DetailViewController.h
//  dataBase
//
//  Created by tech-Yang on 13-11-15.
//  Copyright (c) 2013年 智文通网络服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property(nonatomic,retain)NSIndexPath *indexPath;
@end
