//
//  EditViewController.h
//  dataBase
//
//  Created by tech-Yang on 13-11-18.
//  Copyright (c) 2013年 智文通网络服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UITableViewController<UIAlertViewDelegate>

@property (strong,nonatomic) NSMutableArray *listDate;
@property(nonatomic)NSString *tcid;
@property(nonatomic)NSString *ttitle;
@property BOOL Delete;

@end
