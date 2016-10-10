//
//  HomeCollectionViewCell.m
//  AroundMe
//
//  Created by DaiDai on 16/8/26.
//  Copyright © 2016年 DaiDai. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell

- (void)awakeFromNib {
    
    
}
- (void)setHomeModel:(HomeModel *)homeModel{
    _homeModel = homeModel;
    _imageView.image = [UIImage imageNamed:_homeModel.pic];
    _label.text = _homeModel.name;

}
@end
