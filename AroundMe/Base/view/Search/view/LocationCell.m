//
//  LocationCell.m
//  AroundMe
//
//  Created by DaiDai on 16/9/5.
//  Copyright © 2016年 DaiDai. All rights reserved.
//

#import "LocationCell.h"

@implementation LocationCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setLocationModel:(LocationModel *)locationModel{
    _locationModel = locationModel;
    _addressLabel.text = _locationModel.address;
    _subAreaLabel.text = _locationModel.subArea;
    _areaLabel.text = _locationModel.area;
    _distanceLabel.text = [NSString stringWithFormat:@"%@",_locationModel.distance] ;
    
}
@end
