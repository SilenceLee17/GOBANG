//
//  LXDBoard.h
//  GOBANG
//
//  Created by 李兴东 on 17/3/2.
//  Copyright © 2017年 xingshao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXDChess.h"

@interface LXDBoard : NSObject
@property (nonatomic, copy)NSMutableArray *boardArray;

- (instancetype)initWithBoardSize:(NSInteger )boardSize;
- (void)put:(LXDChess *)chess;
- (void)remove:(LXDChess *)chess;
- (LXDChess *)fight;
- (void)des;

@end
