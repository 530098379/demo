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
    NSString *userTable;
    NSString *userId ;
    NSString *userName;
}

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *passWordText;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userTable = @"M_USER";
    userId = @"ID";
    userName = @"PASSWORD";
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"demeDB.sqlite"];
    // 创建DB
    db = [FMDatabase databaseWithPath:fileName];
    if ([db open]) {
        // 创建用户表
        if (![db tableExists:userTable]) {
            [db executeUpdate:[NSString stringWithFormat:@"create table %@(%@ text,%@ text)",
                               userTable,userId,userName]];
            NSString *insertSql1= [NSString stringWithFormat:
                                   @"INSERT INTO '%@' ('%@', '%@') VALUES ('%@', '%@')",
                                   userTable, userId, userName, @"admin", @"123456"];
            [db executeUpdate:insertSql1];

        }
        [db close];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneSubmit:(UIButton *)sender {

    BOOL extis = NO;
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@ WHERE ID = '%@' and PASSWORD = '%@'",userTable,_nameText.text, _passWordText.text];
        FMResultSet * rs = [db executeQuery:sql];

        if ([rs next]) {
            extis = YES;
        }
        [db close];
    }
  
    if (!extis) {
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
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"Test";
        [HUD showAnimated:YES whileExecutingBlock:^{
            [self doTask];
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
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

-(void) doTask{
    //你要进行的一些逻辑操作
    sleep(10000);
}
@end
