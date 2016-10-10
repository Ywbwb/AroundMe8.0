//
//  CoverDelegate.h
//  AroundMe
//
//  Created by mac13 on 16/9/13.
//  Copyright © 2016年 DaiDai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CoverDelegate : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

{
    UITableView *table;
    BOOL ifOn;
}

@end

