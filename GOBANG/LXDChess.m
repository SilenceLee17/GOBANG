//
//  LXDChess.m
//  GOBANG
//
//  Created by 李兴东 on 17/3/2.
//  Copyright © 2017年 xingshao. All rights reserved.
//

#import "LXDChess.h"


@implementation LXDChess
- (instancetype)initBorderChess{
    self = [self initPointWith:-1 y:-1];
    if (self) {
        _type = OccupyBorder;
    }
    return self;
};


- (instancetype)initPointWith:(NSInteger)x y:(NSInteger)y
{
    self = [self init];
    if (self) {
        _x = x;
        _y = y;
        _type = OccupyTypeEmpty;
        _myScore = minScore;
        _humanScore = minScore;
    }
    return self;
}
@end
