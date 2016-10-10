//
//  LocationCell.h
//  AroundMe
//
//  Created by DaiDai on 16/9/5.
//  Copyright © 2016年 DaiDai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationModel.h"
@interface LocationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *subAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@property (weak, nonatomic) IBOutlet UIImageView *directionImg;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (strong, nonatomic)LocationModel *locationModel;
@end
