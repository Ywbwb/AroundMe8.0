//
//  WeatherCell.m
//  AroundMe
//
//  Created by mac13 on 16/9/21.
//  Copyright © 2016年 DaiDai. All rights reserved.
//

#import "WeatherCell.h"
#import "UIImageView+WebCache.h"
@implementation WeatherCell
-(void)setModel:(WeatherModel *)model{
    _model = model;
    _time.text = _model.time;
    _weather.text = _model.weather;
    _weatherTem.text = _model.currentTem;
    [_weatherImg sd_setImageWithURL:[NSURL URLWithString:_model.imgUrl]];
}
@end
