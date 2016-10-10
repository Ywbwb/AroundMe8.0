//
//  CoverDelegate.m
//  AroundMe
//
//  Created by mac13 on 16/9/13.
//  Copyright © 2016年 DaiDai. All rights reserved.
//

#import "CoverDelegate.h"
#import "PersonalWebView.h"
@implementation CoverDelegate


//http://www.aroundmeapp.com/privacy/en/ 隐私政策
//服务条款http://www.aroundmeapp.com/privacy/en/
//打开来源归属
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"weather"];
        //刷新table
        [table reloadData];
       
        //关闭天气预报
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        
    }else if (indexPath.section == 0 && indexPath.row == 1){
       
    }else if (indexPath.section == 1 && indexPath.row == 0){
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"weather"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"AroundeMe天气现在是启用的：是否禁用它?" delegate:self cancelButtonTitle:@"现在不" otherButtonTitles:@"禁用", nil];
            [alert show];
        }else{
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"weather"];
            [tableView reloadData];
        }
        
    }else if (indexPath.section == 2 && indexPath.row == 0){

        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"form"]isEqualToString:@"grid"]) {
            NSNotification *notice = [NSNotification notificationWithName:@"change" object:nil userInfo:@{@"animate":@"YES"}];
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hidden"];
            [[NSUserDefaults standardUserDefaults] setValue:@"list" forKey:@"form"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [tableView reloadData];
        }else{
            NSNotification *notice = [NSNotification notificationWithName:@"change" object:nil userInfo:@{@"animate":@"NO"}];
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        }
        
    }else if (indexPath.section == 2 && indexPath.row == 1){
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"form"]isEqualToString:@"list"]) {
            NSNotification *notice = [NSNotification notificationWithName:@"change" object:nil userInfo:@{@"animate":@"YES"}];
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hidden"];
            [[NSUserDefaults standardUserDefaults] setValue:@"grid" forKey:@"form"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [tableView reloadData];
        }else{
            NSNotification *notice = [NSNotification notificationWithName:@"change" object:nil userInfo:@{@"animate":@"NO"}];
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        }
        
    }else if (indexPath.section == 3 && indexPath.row == 0){
      
        [[NSUserDefaults standardUserDefaults] setValue:@"m" forKey:@"unit"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [tableView reloadData];
    }else if (indexPath.section == 3 && indexPath.row == 1){
    
        [[NSUserDefaults standardUserDefaults] setValue:@"yd" forKey:@"unit"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [tableView reloadData];
    }else if (indexPath.section == 3 && indexPath.row == 2){
        [[NSUserDefaults standardUserDefaults] setValue:@"celsius" forKey:@"TEM"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [tableView reloadData];
    }else if (indexPath.section == 3 && indexPath.row == 3){

        [[NSUserDefaults standardUserDefaults] setValue:@"Fahrenheit" forKey:@"TEM"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [tableView reloadData];
    }else if (indexPath.section == 4 && indexPath.row == 0){
        //服务条款
        
        
    }else if (indexPath.section == 4 && indexPath.row == 1){
        //隐私政策
        NSNotification *notice = [NSNotification notificationWithName:@"push" object:nil userInfo:@{@"privacy":@"http://www.aroundmeapp.com/privacy/en/"}];
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    }else if (indexPath.section == 4 && indexPath.row == 2){
        //打开来源归属
    }

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    table = tableView;
    return 6;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
     switch (section) {
        case 0:
            return @"高级";
            break;
        case 1:
            return @"AROUNDME天气";
            break;
        case 2:
            return @"主题";
            break;
        case 3:
            return @"单位";
            break;
        case 4:
            return @"条款和隐私权";
            break;
        case 5:
            return @"统计";
            break;
             
        default:
             return nil;
             break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 4;
            break;
        case 4:
            return 3;
            break;
        case 5:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"coverCell"];
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = @"升级到无广告的AroundMe";
    }else if (indexPath.section == 0 && indexPath.row == 1){
        cell.textLabel.text = @"恢复购买";
    }else if (indexPath.section == 1 && indexPath.row == 0){
        cell.textLabel.text = @"获得每日天气预报";
    }else if (indexPath.section == 2 && indexPath.row == 0){
        cell.textLabel.text = @"列表";
        cell.imageView.image = [UIImage imageNamed:@"SettingsThemeIconListActive"];
    }else if (indexPath.section == 2&& indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"SettingsThemeIconGridActive"];
        cell.textLabel.text = @"网格";
    }else if (indexPath.section == 3 && indexPath.row == 0){
        cell.textLabel.text = @"公里/米";
    }else if (indexPath.section == 3 && indexPath.row == 1){
        cell.textLabel.text = @"英里/码";
    }else if (indexPath.section == 3 && indexPath.row == 2){
        cell.textLabel.text = @"摄氏";
    }else if (indexPath.section == 3 && indexPath.row == 3){
        cell.textLabel.text = @"华氏";
    }else if (indexPath.section == 4 && indexPath.row == 0){
        cell.textLabel.text = @"服务条款";
    }else if (indexPath.section == 4 && indexPath.row == 1){
        cell.textLabel.text = @"隐私政策";
    }else if (indexPath.section == 4 && indexPath.row == 2){
        cell.textLabel.text = @"打开来源归属";
    }else if (indexPath.section == 5 && indexPath.row == 0){
        UISwitch *switchView = [[UISwitch alloc]initWithFrame:CGRectZero];
        [switchView addTarget:self action:@selector(switchEvent:) forControlEvents:UIControlEventValueChanged];
        ifOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"statistics"];
        [switchView setOn:ifOn animated:NO];
        cell.accessoryView = switchView;
        cell.textLabel.text = @"发送统计信息";
    }

    if (indexPath.section == 2 && indexPath.row == 0 && [[[NSUserDefaults standardUserDefaults]valueForKey:@"form"] isEqualToString:@"list"]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else if(indexPath.section == 2 && indexPath.row == 1 && [[[NSUserDefaults standardUserDefaults]valueForKey:@"form"] isEqualToString:@"grid"]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else if(indexPath.section == 3 && indexPath.row == 0 && [[[NSUserDefaults standardUserDefaults]valueForKey:@"unit"] isEqualToString:@"m"]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else if(indexPath.section == 3 && indexPath.row == 1 && [[[NSUserDefaults standardUserDefaults]valueForKey:@"unit"] isEqualToString:@"yd"]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else if(indexPath.section == 3 && indexPath.row == 2 && [[[NSUserDefaults standardUserDefaults]valueForKey:@"TEM"] isEqualToString:@"celsius"]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else if(indexPath.section == 3 && indexPath.row == 3 && [[[NSUserDefaults standardUserDefaults]valueForKey:@"TEM"] isEqualToString:@"Fahrenheit"]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else if(indexPath.section == 1 && [[NSUserDefaults standardUserDefaults]boolForKey:@"weather"] ){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else if(indexPath.section == 4){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
        else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
   
    
    
    return cell;
}
- (void)switchEvent:(BOOL)change{
    [[NSUserDefaults standardUserDefaults] setBool:!ifOn forKey:@"statistics"];
}
@end
