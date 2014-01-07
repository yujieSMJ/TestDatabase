//
//  AppDelegate.m
//  dataBase
//
//  Created by tech-Yang on 13-11-15.
//  Copyright (c) 2013年 智文通网络服务有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "sqlite3.h"

@implementation AppDelegate
{
    sqlite3 *db;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [[NSBundle mainBundle]loadNibNamed:@"Root" owner:self options:nil];
    self.window.rootViewController=self.RootViewController;
    [self createOrSelectDateBase];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) createOrSelectDateBase{
    NSString *DBFilePath = [NSString stringWithFormat:@"%@/Documents/dbDemo",NSHomeDirectory()];
    NSLog(@"%@",DBFilePath);
    
    
    if(sqlite3_open([DBFilePath UTF8String], &db) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSLog(@"数据库db打开失败");
    }
    else
    {
        char *err;
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS Classification (CID INTEGER PRIMARY KEY AUTOINCREMENT,Title TEXT , IsShow INTEGER);"];
        //NSString *createSQL = [NSString stringWithFormat:@"DROP TABLE Classification;"];
        if(sqlite3_exec(db, [createSQL UTF8String], nil, nil, &err) !=SQLITE_OK)
        {
            sqlite3_close(db);
            NSAssert1(NO, @"建表失败！,%s", err);
        }
        sqlite3_close(db);
    }
}

@end
