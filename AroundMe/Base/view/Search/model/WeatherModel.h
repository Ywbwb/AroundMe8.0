//
//  WeatherModel.h
//  AroundMe
//
//  Created by mac13 on 16/9/21.
//  Copyright © 2016年 DaiDai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *weather;
@property (copy, nonatomic) NSString *currentTem;
@property (copy, nonatomic) NSString *minTem;
@property (copy, nonatomic) NSString *maxTem;
@property (copy, nonatomic) NSString *imgUrl;
@end
