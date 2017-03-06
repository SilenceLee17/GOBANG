//
//  LXDBoard.m
//  GOBANG
//
//  Created by 李兴东 on 17/3/2.
//  Copyright © 2017年 xingshao. All rights reserved.
//

#import "LXDBoard.h"

static const NSInteger defaultBoardSize = 9;

@interface LXDBoard()

@property (nonatomic, assign) NSInteger boardSize;

@end
@implementation LXDBoard

#pragma mark Lifecycle

- (instancetype)init{
    return [self initWithBoardSize:defaultBoardSize];
}
- (instancetype)initWithBoardSize:(NSInteger )boardSize {
    self = [super init];
    if (self) {
        _boardSize = boardSize;
        _boardArray = [NSMutableArray array];
        [self initScore];
    }
    return self;
}

#pragma mark Public

- (void)put:(LXDChess *)chess{
    NSInteger x = chess.x;
    NSInteger y = chess.y;
//    NSLog(@"put on (%ld,%ld)",(long)x,(long)y);
    _boardArray[x][y] = chess;
    [self updateScore:chess];
}


- (void)remove:(LXDChess *)chess{
    NSInteger x = chess.x;
    NSInteger y = chess.y;
    chess.type = OccupyTypeEmpty;
//    NSLog(@"remove on (%ld,%ld)",(long)x,(long)y);
    _boardArray[x][y] = chess;
    [self updateScore:chess];
}

- (void)des{
    NSLog(@"----------------------------------------------------");
    
    for (int i = 0; i<_boardSize; i++) {
        for (int j = 0; j <_boardSize; j++) {
            LXDChess *curChess = _boardArray[i][j];
            NSLog(@"(%ld,%ld)->[%f | %f]",(long)curChess.x,(long)curChess.y,curChess.myScore,curChess.humanScore);
        }
    }
    NSLog(@"----------------------------------------------------");

}

- (NSArray <LXDChess *>*)gen{
    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray *fives = [NSMutableArray array];
    NSMutableArray *fours = [NSMutableArray array];
    NSMutableArray *blockedFours = [NSMutableArray array];
    NSMutableArray *doubleThrees = [NSMutableArray array];
    NSMutableArray *threes = [NSMutableArray array];
    NSMutableArray *twos = [NSMutableArray array];
    NSMutableArray *others = [NSMutableArray array];
    
    NSLog(@"gen------------");
    [self des];
    NSLog(@"gen------------");
    
    for (int i = 0; i< _boardSize; i++) {
        for (int j = 0; j < _boardSize; j++) {
            LXDChess *curChess = _boardArray[i][j];
            if (curChess.type == OccupyTypeEmpty) {
                
                CGFloat myScore = curChess.myScore;
                CGFloat humanScore = curChess.humanScore;
                
                if (myScore >= LXDScoreFiveLess) {
                    return @[curChess];
                }else if (humanScore >= LXDScoreFiveLess){
                    [fives addObject:curChess];
                }else if (myScore >= LXDScoreFour){
                    [fours insertObject:curChess atIndex:0];
                }else if (humanScore >= LXDScoreFour){
                    [fours addObject:curChess];
                }else if (myScore >= LXDScoreBlockedFour){
                    [blockedFours insertObject:curChess atIndex:0];
                }else if (humanScore >= LXDScoreBlockedFour){
                    [blockedFours addObject:curChess];
                }else if (myScore >= LXDScoreThree * 2){
                    [doubleThrees insertObject:curChess atIndex:0];
                }else if (humanScore >= LXDScoreThree * 2){
                    [doubleThrees addObject:curChess];
                }else if (myScore >= LXDScoreThree){
                    [threes insertObject:curChess atIndex:0];
                }else if (humanScore >= LXDScoreThree){
                    [threes addObject:curChess];
                }else{
                    if ([self hasNeighbor:curChess radius:2 count:2]) {
                        if (myScore >= LXDScoreTwo){
                            [twos insertObject:curChess atIndex:0];
                        }else if (humanScore >= LXDScoreTwo){
                            [twos addObject:curChess];
                        }else{
                            [others addObject:curChess];
                            
                        }
                    }
                }
            }
        }
    }
    if (fives.count > 0) {
        return @[[fives firstObject]];
    }
    if (fours.count > 0) {
        return fours;
    }
    if (blockedFours.count > 0) {
        return @[[blockedFours firstObject]];
    }
    if (doubleThrees.count > 0) {
        [result addObjectsFromArray:doubleThrees];
        [result addObjectsFromArray:threes];
        return result;
    }
    [result addObjectsFromArray:threes];
    [result addObjectsFromArray:twos];
    [result addObjectsFromArray:others];
    [result subarrayWithRange:NSMakeRange(0,MIN(8, result.count))];
    return result;
}

- (LXDChess *)fight{
    LXDChess *resultChess = nil;
#warning todo deep == 6
    for (int i = 2; i <= 3; i+=2) {
        LXDChess *curChess = [self maxmin:i];
        resultChess = _boardArray[curChess.x][curChess.y];
        if (resultChess.myScore >= LXDScoreFour) {
            return resultChess;
        }
    }
    return resultChess;
}

#pragma mark Private
/**
 *  是否拥有指定邻子
 *
 *  @param chess  当前棋子
 *  @param radius 搜索半径
 *  @param count  至少存在邻子数
 *
 *  @return BOOL
 */
- (BOOL)hasNeighbor:(LXDChess *)chess radius:(NSUInteger)radius count:(NSUInteger)count{
    NSInteger startX = chess.x < radius ? 0 :  chess.x - radius;
    NSInteger endX = MIN((chess.x + radius), (_boardSize - 1));
    NSInteger startY = chess.y < radius ? 0 :  chess.y - radius;
    NSInteger endY = MIN((chess.y + radius), (_boardSize - 1));
    for (NSInteger i = startX; i < endX; i++) {
        for (NSInteger j = startY; j < endY; j++) {
            LXDChess *chess = _boardArray[i][j];
            if (chess.type == OccupyTypeAI || chess.type == OccupyTypeHuman) {
                count --;
            }
            if (count <= 0) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)initScore{
    for (int i = 0; i< _boardSize; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 0; j < _boardSize; j++) {
            LXDChess *chess = [[LXDChess alloc] initPointWith:i y:j];
            [array addObject:chess];
        }
        [_boardArray addObject:array];
    }
}

- (void)updateScore:(LXDChess *)chess{
    if (!chess) {
        return;
    }
    NSInteger radius = 4;
    NSInteger startX = chess.x < radius ? 0 :  chess.x - radius;
    NSInteger endX = MIN(chess.x + radius, _boardSize - 1);
    NSInteger startY = chess.y < radius ? 0 :  chess.y - radius;
    NSInteger endY = MIN(chess.y + radius, _boardSize - 1);
//    NSLog(@"(%ld,%ld)->(%ld,%ld)",(long)startX,(long)startY,(long)endX,(long)endY);
    for (NSInteger i = startX; i < endX; i++) {
        for (NSInteger j = startY; j < endY; j++) {
            LXDChess *chess = _boardArray[i][j];
            if (chess.type == OccupyTypeEmpty) {
//                NSLog(@"(x,y)=(%ld,%ld) myScore %f  humanScore %f",(long)chess.x,(long)chess.y,chess.myScore,chess.humanScore);
                chess.myScore = [self scorePoint:i y:j type:OccupyTypeAI];
                chess.humanScore = [self scorePoint:i y:j type:OccupyTypeHuman];

            }

        }
    }

}

-(CGFloat)scorePoint:(NSInteger)x y:(NSInteger)y type:(OccupyType)type{
    CGFloat result = 0;
    __block NSInteger count = 1;
    __block NSInteger block = 0;
    __block NSMutableArray *firstArray = [NSMutableArray array];
    __block NSMutableArray *secondArray = [NSMutableArray array];

    NSInteger radius = 4;
    NSInteger startX = x < radius ? 0 :  x - radius;
    NSInteger endX = MIN(x + radius, _boardSize - 1);
    NSInteger startY = y < radius ? 0 :  y - radius;
    NSInteger endY = MIN(y + radius, _boardSize - 1);
    
    void(^reset)() = ^() {
        count = 1;
        block = 0;
        [firstArray removeAllObjects];
        [secondArray removeAllObjects];
    };
    
    void(^score)(NSMutableArray * ,NSMutableArray * ,OccupyType) = ^(NSMutableArray * firstArray, NSMutableArray * secondArray, OccupyType type) {
        for (int i = 0; i < firstArray.count; i ++) {
            LXDChess *curChess = firstArray[i];
            if (curChess.type == type) {
                count ++;
            }else{
                if (curChess.type != OccupyTypeEmpty) {
                    block++;
                }
                break;
            }
        }
        for (int i = 0 ; i < secondArray.count; i++) {
            LXDChess *curChess = secondArray[i];
            if (curChess.type == type) {
                count ++;
            }else{
                if (curChess.type != OccupyTypeEmpty) {
                    block++;
                }
                break;
            }
        }
//        NSLog(@"count %ld , block %ld",(long)count,(long)block);
        
//        NSLog(@"--------------------------------------");
    };
    
//    横向
    reset();

    for (NSInteger i = x - 1;i >= x - radius; i --) {
        if (i < startX) {
            LXDChess * curChess = [[LXDChess alloc] initBorderChess];
            [firstArray addObject:curChess];
            break;
        }
        LXDChess *curChess = _boardArray[i][y];
        [firstArray addObject:curChess];
    }
    
    for (NSInteger i = x + 1; i <= x + radius ; i++) {
        if (i > endX) {
            LXDChess * curChess = [[LXDChess alloc] initBorderChess];
            [secondArray addObject:curChess];
            break;
        }
        LXDChess *curChess = _boardArray[i][y];
        [secondArray addObject:curChess];
    }
    
    score(firstArray,secondArray,type);
    result += [self typeWithCount:count block:block];
    
//    纵向
    reset();
    for (NSInteger i = y - 1; i >= y - radius; i--) {
        if (i < startY) {
            LXDChess * curChess = [[LXDChess alloc] initBorderChess];
            [firstArray addObject:curChess];
            break;
        }
        LXDChess *curChess = _boardArray[x][i];
        [firstArray addObject:curChess];
    }
    
    for (NSInteger i = y + 1; i <= y + radius ; i++) {
        if (i > endY) {
            LXDChess * curChess = [[LXDChess alloc] initBorderChess];
            [secondArray addObject:curChess];
            break;
        }
        LXDChess *curChess = _boardArray[x][i];
        [secondArray addObject:curChess];
    }
    score(firstArray,secondArray,type);
    result += [self typeWithCount:count block:block];
    
    // \\向
    reset();
    
    for (int i = 1; i <= radius; i++) {
        NSInteger curX = x - i;
        NSInteger curY = y - i;
        if (curX < startX || curY < startY) {
            LXDChess * curChess = [[LXDChess alloc] initBorderChess];
            [firstArray addObject:curChess];
            break;
        }
        LXDChess *curChess = _boardArray[curX][curY];
        [firstArray addObject:curChess];
    }
    
    for (int i = 1; i <= radius; i++) {
        NSInteger curX = x + i;
        NSInteger curY = y + i;
        if (curX > endX || curY > endY) {
            LXDChess * curChess = [[LXDChess alloc] initBorderChess];
            [secondArray addObject:curChess];
            break;
        }
        LXDChess *curChess = _boardArray[curX][curY];
        [secondArray addObject:curChess];
    }
    score(firstArray,secondArray,type);
    result += [self typeWithCount:count block:block];
    
//    //向
    reset();
    for (int i = 1; i <= radius; i++) {
        NSInteger curX = x + i;
        NSInteger curY = y - i;
        if (curX < startX || curY < startY || curX > endX || curY > endY) {
            LXDChess * curChess = [[LXDChess alloc] initBorderChess];
            [firstArray addObject:curChess];
            break;
        }
        LXDChess *curChess = _boardArray[curX][curY];
        [firstArray addObject:curChess];
    }

    for (int i = 1; i <= radius; i++) {
        NSInteger curX = x - i;
        NSInteger curY = y + i;
        if (curX < startX || curY < startY || curX > endX || curY > endY) {
            LXDChess * curChess = [[LXDChess alloc] initBorderChess];
            [secondArray addObject:curChess];
            break;
        }
        LXDChess *curChess = _boardArray[curX][curY];
        [secondArray addObject:curChess];
    }
    score(firstArray,secondArray,type);
    result += [self typeWithCount:count block:block];
    
    return result;
}
/**
 *  判断棋型
 *
 *  @param count 连子数
 *  @param block 封闭数
 *
 *  @return 得分类型
 */
- (LXDScoreType) typeWithCount:(NSUInteger )count block:(NSUInteger )block{
    LXDScoreType type = LXDScoreUnknown;
    switch (count) {
        case 0:
            type = LXDScoreUnknown;
            break;
        case 1:{
            if (block == 0) {
                type = LXDScoreOne;
            }else if (block == 1){
                type = LXDScoreBlockedOne;
            }
        }
            break;
        case 2:{
            if (block == 0) {
                type = LXDScoreTwo;
            }else if (block == 1){
                type = LXDScoreBlockedTwo;
            }
        }
            break;
        case 3:{
            if (block == 0) {
                type = LXDScoreThree;
            }else if (block == 1){
                type = LXDScoreBlockedThree;
            }
        }
            break;
        case 4:{
            if (block == 0) {
                type = LXDScoreFour;
            }else if (block == 1){
                type = LXDScoreBlockedFour;
            }
        }
            break;
        default:
            type = LXDScoreFiveLess;
            break;
    }
    return type;
}

- (LXDChess *)maxmin:(NSUInteger)deep{
    LXDChess *resultChess = nil;
    CGFloat best = -10.0 * LXDScoreFiveLess;
    NSArray *points = [self gen];
    NSMutableArray *bestPoints = [NSMutableArray array];
    for (int i = 0; i < points.count; i++) {
        LXDChess *putChess = points[i];
        putChess.type = OccupyTypeAI;
        [self put:putChess];
        CGFloat v = - [self max:deep-1 alpha:-10.0 * LXDScoreFiveLess beta:-best type:OccupyTypeHuman x:putChess.x y:putChess.y];
        if (putChess.x < 3 || putChess.x > 11 || putChess.y < 3 || putChess.y > 11) {
            v = 0.5 * v;
        }
        if (v == best) {
            [bestPoints addObject:putChess];
        }
        if (v > best) {
            best = v;
            [bestPoints removeAllObjects];
            [bestPoints addObject:putChess];
        }
        [self remove:putChess];
    }
    if (bestPoints.count > 0) {
        NSLog(@"bestPoints -------------------");
        for (int i = 0; i < bestPoints.count; i++) {
            LXDChess *curChess = bestPoints[i];
            NSLog(@"(%ld,%ld)->[%f | %f]",(long)curChess.x,(long)curChess.y,curChess.myScore,curChess.humanScore);
        }
        NSLog(@"bestPoints -------------------");

        resultChess = bestPoints[arc4random() % bestPoints.count];
        
    }
    
    return resultChess;
}
- (CGFloat)max:(NSUInteger)deep alpha:(CGFloat)alpha beta:(CGFloat)beta type:(OccupyType)type x:(NSInteger)x y:(NSInteger)y{
    CGFloat result = [self scorePoint:x y:y type:type];
    if (deep <= 0 || result >= LXDScoreFiveLess) {
        return result;
    }
    CGFloat best = -10.0 * LXDScoreFiveLess;
    NSArray *points = [self gen];
    for (int i = 0; i < points.count; i++) {
        LXDChess *putChess = points[i];
        putChess.type = type;
        [self put:putChess];
        CGFloat v = - [self max:deep-1 alpha:-beta beta:-1.0*MAX(best, alpha) type:[self reverseType:type] x:putChess.x y:putChess.y];
        [self remove:putChess];
        if (v > best) {
            best = v;
        }
        if (v >= beta) {
            return v;
        }
    }
    if ((deep == 2 || deep == 3) && best < LXDScoreThree * 2.0 && best > LXDScoreThree * -1.0) {
//        checkmate-fast
    }
    return best;
}

-(OccupyType )reverseType:(OccupyType)type{
    if (type == OccupyTypeAI) {
        return OccupyTypeHuman;
    }else if (type == OccupyTypeHuman){
        return OccupyTypeAI;
    }else{
        return type;
    }
}

@end
