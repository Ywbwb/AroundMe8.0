//
//  WeatherCell.h
//  AroundMe
//
//  Created by mac13 on 16/9/21.
//  Copyright © 2016年 DaiDai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherModel.h"
@interface WeatherCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *weatherImg;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *weather;
@property (weak, nonatomic) IBOutlet UILabel *weatherTem;
@property (nonatomic, strong)WeatherModel *model;
@end
