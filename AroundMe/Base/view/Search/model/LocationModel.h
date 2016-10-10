//
//  LocationModel.h
//  AroundMe
//
//  Created by DaiDai on 16/9/5.
//  Copyright © 2016年 DaiDai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationModel : NSObject
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *subArea;
@property (copy, nonatomic) NSString *area;
@property (copy, nonatomic) NSString *distance;
@end
