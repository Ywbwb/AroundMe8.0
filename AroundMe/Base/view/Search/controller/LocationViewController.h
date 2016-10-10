//
//  LocationViewController.h
//  AroundMe
//
//  Created by DaiDai on 16/9/5.
//  Copyright © 2016年 DaiDai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

typedef void(^SelectedBlock)(NSDictionary *result);
@interface LocationViewController : UIViewController
@property (nonatomic, copy)SelectedBlock block;
@property (nonatomic, strong)HomeModel *model;



@end
