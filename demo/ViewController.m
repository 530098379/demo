//
//  ViewController.m
//  demo
//
//  Created by 王欢 on 16/4/10.
//  Copyright (c) 2016年 王欢. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
#import "FMDB.h"

@interface ViewController ()<MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
    FMDatabase *db;
    long long expectedLength;
    long long currentLength;
}

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *passWordText;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *userTable = @"M_USER";
    NSString *userId = @"ID";
    NSString *userName = @"NAME";
    
    // 创建DB
    db = [FMDatabase databaseWithPath:@"/tmp/demeDB.db"];
    if ([db open]) {
        // 创建用户表
        if ([db tableExists:userTable]) {
            [db executeUpdate:[NSString stringWithFormat:@"create table %@(%@ text,%@ text)",
                               userTable,userId,userName]];
        }
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@') VALUES ('%@', '%@')",
                               userTable, userId, userName, @"admin", @"123456"];
        [db executeUpdate:insertSql1];
        [db close];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneSubmit:(UIButton *)sender {
    /*//NSString *userTable = @"M_USER";
    //NSString *userId = @"ID";
    //NSString *userName = @"NAME";

    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@",userTable];
        FMResultSet * rs = [db executeQuery:sql];
        while (![rs next]) {
            //int Id = [rs intForColumn:userId];
            //NSString * name = [rs stringForColumn:userName];
            UIAlertController *controller =
            [UIAlertController alertControllerWithTitle:@"登陆失败"
                                                message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIPopoverPresentationController *ppc = controller.popoverPresentationController;
            if (ppc != nil) {
                ppc.sourceView = sender;
                ppc.sourceRect = sender.bounds;
            }
            [self presentViewController:controller animated:YES completion:nil];
        }
        [db close];
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.tabBarController.view];
    [tabBarViewController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    */
    if (true) {
        UIAlertController *controller =
        [UIAlertController alertControllerWithTitle:@"帐号或密码错误，请重新填写。"
                                            message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
        [controller addAction:yesAction];
        
        UIPopoverPresentationController *ppc = controller.popoverPresentationController;
        if (ppc != nil) {
            ppc.sourceView = sender;
            ppc.sourceRect = sender.bounds;
        }
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        
    }
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.nameText resignFirstResponder];
    [self.passWordText resignFirstResponder];
}

- (IBAction)passwordChanged:(id)sender{
    if (self.passWordText.text.length > 0) {
        self.doneButton.enabled = YES;
        self.doneButton.backgroundColor = [UIColor colorWithRed:(144.0f/255.0f) green:(245.0f/255.0f) blue:(154.0f/255.0f)alpha:1.0];
        self.doneButton.titleLabel.textColor = [UIColor blackColor];
    }else{
        self.doneButton.enabled = NO;
        self.doneButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.doneButton.titleLabel.textColor = [UIColor lightGrayColor];
    }
}
@end
