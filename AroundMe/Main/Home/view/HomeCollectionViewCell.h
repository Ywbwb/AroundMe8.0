//
//  HomeCollectionViewCell.h
//  AroundMe
//
//  Created by DaiDai on 16/8/26.
//  Copyright © 2016年 DaiDai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@interface HomeCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) HomeModel *homeModel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *label;

@end
