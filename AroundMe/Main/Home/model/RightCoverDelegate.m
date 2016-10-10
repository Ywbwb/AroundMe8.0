//
//  RightCoverDelegate.m
//  AroundMe
//
//  Created by DaiDai on 16/9/15.
//  Copyright © 2016年 DaiDai. All rights reserved.
//

#import "RightCoverDelegate.h"
#import "LocationViewController.h"
@interface RightCoverDelegate ()
{
    NSDictionary *_dic;
}
@end

@implementation RightCoverDelegate

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rightCell"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"当前位置";
        cell.textLabel.textColor = myColor;
    }else{
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userLoc"]) {
            
            _dic = [NSMutableDictionary new];
            _dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"userLoc"];;
            cell.textLabel.text = _dic[@"locName"];
            cell.textLabel.textColor = [UIColor grayColor];
            
        }
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
            if (indexPath.row == 0) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"currentLoc"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                NSNotification *notice = [NSNotification notificationWithName:@"rightChange" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter]postNotification:notice];
            }else{
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"currentLoc"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                NSNotification *notice = [NSNotification notificationWithName:@"rightChange" object:nil userInfo:_dic];
                [[NSNotificationCenter defaultCenter]postNotification:notice];
                
            }

    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
