//
//  LXDChess.h
//  GOBANG
//
//  Created by 李兴东 on 17/3/2.
//  Copyright © 2017年 xingshao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

//#define minScore (LXDScoreFiveLess * -10)
#define minScore -1

typedef NS_ENUM(NSInteger, OccupyType) {
    OccupyTypeEmpty = 0,
    OccupyTypeHuman,
    OccupyTypeAI,
    OccupyBorder = -1,
};
typedef NS_ENUM(NSUInteger, LXDScoreType) {
    LXDScoreUnknown = 0,
    LXDScoreOne = 10,
    LXDScoreTwo = 100,
    LXDScoreThree = 1000,
    LXDScoreFour = 100000,
    LXDScoreBlockedOne = 1,
    LXDScoreBlockedTwo = 10,
    LXDScoreBlockedThree = 100,
    LXDScoreBlockedFour = 10000,
    LXDScoreFiveLess = 1000000
};
@interface LXDChess : NSObject
@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, assign) OccupyType type;
@property (nonatomic, assign) CGFloat myScore;
@property (nonatomic, assign) CGFloat humanScore;
- (instancetype)initPointWith:(NSInteger)x y:(NSInteger)y;
- (instancetype)initBorderChess;

@end
