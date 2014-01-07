//
//  EditViewController.m
//  dataBase
//
//  Created by tech-Yang on 13-11-18.
//  Copyright (c) 2013年 智文通网络服务有限公司. All rights reserved.
//

#import "EditViewController.h"
#import "sqlite3.h"
#import "CustomCell.h"

@interface EditViewController ()

@end

@implementation EditViewController
{
    sqlite3 *db;
    UIBarButtonItem *btnAdd;
    UIBarButtonItem *btnEdit;
}

-(BOOL)openDatabase{
    NSString *DBFilePath = [NSString stringWithFormat:@"%@/Documents/dbDemo",NSHomeDirectory()];
    NSLog(@"%@",DBFilePath);
    if(sqlite3_open([DBFilePath UTF8String], &db) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSLog(@"数据库db打开失败");
        return NO;
    }
    return YES;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self selectDate];
    btnAdd = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:(UIBarButtonItemStylePlain) target:self action:@selector(btnaddClick:)];
    
//    btnEdit = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(btneditClick:)];
    
    self.navigationItem.rightBarButtonItem = btnAdd;
    //系统中自定义的一个button
    self.editButtonItem.title = @"编辑";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

//这个自定义的button通过一下方法操作
-(void) setEditing:(BOOL)editing animated:(BOOL)animated{
    NSLog(@"ok");
    //父级也要执行一次该方法，才能开启编辑模式，但是delete按钮不能执行
    //self.editButtonItem.title = @"完成";
    if(self.navigationItem.rightBarButtonItem.title != nil){
        self.navigationItem.rightBarButtonItem = nil;
        //self.editButtonItem.title=@"完成";
    }else{
        self.navigationItem.rightBarButtonItem = btnAdd;
        //self.editButtonItem.title = @"编辑";
    }
    [super setEditing:editing animated:animated];
    
}
//通过该方法实现是否可以删除功能
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return YES;
    }
    return NO;
}
//确认编辑状态
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return UITableViewCellEditingStyleDelete;
    }
    else{
        return UITableViewCellEditingStyleInsert;
    }
}
//删除数据并重新加载数据
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        if([self openDatabase])
        {
            NSDictionary *dict = [self.listDate objectAtIndex:indexPath.row];
            NSString *cid = [dict objectForKey:@"cid"];
            
            NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM Classification where CID=%@",cid];
            
            sqlite3_stmt *statement;
            if(sqlite3_prepare_v2(db, [sqlstr UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                if(sqlite3_step(statement) !=SQLITE_DONE)
                {
                    NSAssert(NO, @"删除数据失败！");
                }
            }
            sqlite3_finalize(statement);
            
            sqlite3_close(db);
            NSLog(@"success!!!");
            //数组中删除对应的数据
            [self.listDate removeObjectAtIndex:indexPath.row];
            //NSLog(@"%@",[self.listDate description]);
            
            //删除表视图上的当前行
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
        }

    }
    else {
        
    }
}

//数据的移动
//首先询问是否可以移动
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return  YES;
}
//决定cell可以移动的位置
-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    //表示可以移动
    //在同一个组里可以移动
    if(sourceIndexPath.section == proposedDestinationIndexPath.section){
        return proposedDestinationIndexPath;
    }
    return sourceIndexPath;
}
//实现移动的方法，刚方法由系统实现，我们要做的就是重新绑定数据源
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSDictionary *dict = [self.listDate objectAtIndex:sourceIndexPath.row];
    [self.listDate insertObject:dict atIndex:destinationIndexPath.row];
    [self.listDate removeObjectAtIndex:sourceIndexPath.row];
    
}

-(void)selectDate{
    
    if([self openDatabase])
    {
        NSString *query =@"SELECT CID,Title, IsShow FROM Classification ORDER BY CID";
        sqlite3_stmt *statement;
        
        if(sqlite3_prepare(db, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
        {
            self.listDate = [NSMutableArray new];
            int cid,isshow;
            NSMutableString *title;
            
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSMutableDictionary *dicts = [NSMutableDictionary new];
                cid = sqlite3_column_int(statement, 0);
                title = [[NSMutableString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                isshow = sqlite3_column_int(statement, 2);
                
                [dicts setObject:[NSString stringWithFormat:@"%d",cid] forKey:@"cid"];
                [dicts setObject:title forKey:@"title"];
                [dicts setObject:[NSString stringWithFormat:@"%d",isshow] forKey:@"isshow"];
                
                //将ID放入可变字典中
                [self.listDate addObject:dicts];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(db);
    }
}

-(void)btnaddClick:(UIBarButtonItem *)buttons{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加新消费类目" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] ;
    alert.tag = 999999999;
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

//-(void) btneditClick:(UIBarButtonItem *)buttons{
//    if(self.Delete)
//    {
//        self.Delete = NO;
//        [self viewDidLoad];
//    }
//    else
//    {
//        self.Delete = YES;
//        self.navigationItem.rightBarButtonItem.title = nil;
//        self.navigationItem.leftBarButtonItem.title = @"完成";
//    }
//    [self.tableView reloadData];
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIAlertView *alt = (UIAlertView *)alertView;
    if(alt.tag ==999999999)
    {
        NSLog(@"%@",[alertView textFieldAtIndex:0]);
        if(buttonIndex == 1)
        {
            NSString *title =[alertView textFieldAtIndex:0].text;
            if(title.length >0)
            {
                if([self openDatabase])
                {
                    NSString *sqlstr = @"INSERT OR REPLACE INTO Classification (Title,IsShow) VALUES (?,?)";
                    
                    sqlite3_stmt *statement;
                    if(sqlite3_prepare_v2(db, [sqlstr UTF8String], -1, &statement, NULL) == SQLITE_OK)
                    {
                        sqlite3_bind_text(statement, 1, [title UTF8String], -1, NULL);
                        sqlite3_bind_text(statement, 2, 0, -1, NULL);
                        
                        if(sqlite3_step(statement) !=SQLITE_DONE)
                        {
                            NSAssert(NO, @"插入数据失败！");
                        }
                    }
                    sqlite3_finalize(statement);
                    
                    sqlite3_close(db);
                    NSLog(@"success!!!");
                    [self selectDate];
                    [self.tableView reloadData];
                }
            }
        }
    }
    else
    {
        if(buttonIndex == 1)
        {
            if([self openDatabase])
            {
                NSString *title = [alertView textFieldAtIndex:0].text;
                if(title.length >0){
                    NSString *sqlstr = [NSString stringWithFormat:@"UPDATE Classification SET title='%@' where CID=%@",title,self.tcid];
                    sqlite3_stmt *statement;
                    if(sqlite3_prepare_v2(db, [sqlstr UTF8String], -1, &statement, NULL) == SQLITE_OK)
                    {
                        if(sqlite3_step(statement) !=SQLITE_DONE)
                        {
                            NSAssert(NO, @"数据修改失败！");
                        }
                    }
                    sqlite3_finalize(statement);
                    
                    sqlite3_close(db);
                    NSLog(@"success!!!");
                    [self selectDate];
                    [self.tableView reloadData];
                }
            }
        }

    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    NSLog(@"the count is  %d",self.listDate.count);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"the numeber is new");
    return self.listDate.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //重用标识
    static NSString *CellIdentifier = @"Cell";
    NSUInteger row = [indexPath row];
    NSLog(@"the index is %d",row);
    NSDictionary *dict = [self.listDate objectAtIndex:row];
    NSLog(@"my dictionary is %@",[dict description]);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == Nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [dict objectForKey:@"title"];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    //自定义cell
//    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if(cell==nil)
//    {
//        cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    cell.title.text = [dict objectForKey:@"title"];
//    if(self.Delete)
//    {
//        cell.title.frame = CGRectMake(45, 0, 200, 44);
//        [cell.btn setHidden:NO];
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        [cell.deletes setHidden:YES];
//        cell.tag = cell.btn.tag = indexPath.row;
//        [cell.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    else
//    {
//        cell.title.frame = CGRectMake(25, 0, 200, 44);
//        [cell.btn setHidden:YES];
//        cell.accessoryType = UITableViewCellAccessoryDetailButton;
//        [cell.deletes setHidden:YES];
//        cell.detailTextLabel.text = nil;
//    }
    return cell;
}

//-(void)btnClick:(UIButton *)sender{
//    UIButton *btn = (UIButton *)sender;
//    
//    [btn setImage:[UIImage imageNamed:@"orderButton.png"] forState:UIControlStateNormal];
//}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    if(self.navigationItem.rightBarButtonItem !=nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改类目" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] ;
        alert.tag = indexPath.row;
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        NSDictionary *dict = [self.listDate objectAtIndex:indexPath.row];
        self.tcid = [dict objectForKey:@"cid"];
        self.ttitle = [dict objectForKey:@"title"];
        [alert textFieldAtIndex:0].text = self.ttitle;
        [alert show];
    }
}


@end
