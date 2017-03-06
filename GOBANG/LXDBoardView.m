//
//  LXDBoardView.m
//  goBang
//
//  Created by 李兴东 on 17/2/13.
//  Copyright © 2017年 xingshao. All rights reserved.
//

#import "LXDBoardView.h"
#import "LXDChess.h"

static NSInteger const kBoardSize = 9;

@implementation LXDBoardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _board = [[LXDBoard alloc] init];
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews{
    for (int i = 0; i < kBoardSize + 2; i ++) {
        UIView *horizonLine = [[UIView alloc] initWithFrame:CGRectMake(0, i * self.bounds.size.height / (kBoardSize + 1), self.bounds.size.width, 1.f / [UIScreen mainScreen].scale)];
        horizonLine.backgroundColor = [UIColor blackColor];
        [self addSubview:horizonLine];
    }
    
    for (int i = 0; i < kBoardSize + 2; i ++) {
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(i * self.bounds.size.width / (kBoardSize + 1), 0, 1.f / [UIScreen mainScreen].scale, self.bounds.size.height)];
        verticalLine.backgroundColor = [UIColor blackColor];
        [self addSubview:verticalLine];
    }
    
    [self move:_board.boardArray.count/2 y:_board.boardArray.count/2 type:OccupyTypeAI];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.userInteractionEnabled = NO;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSUInteger h = 0;
    NSUInteger v = 0;

    
    for (NSUInteger i = 0; i <= kBoardSize; i ++) {
        
        if (i * self.frame.size.width / (kBoardSize + 1) <= point.x && point.x < (i + 1) * self.frame.size.width / (kBoardSize + 1)) {
            
            
            
            if (i == 0) {
                h = 0;
                
                break;
            }
            
            if (i == kBoardSize) {
                h = kBoardSize - 1;
                
                break;
            }
            
            if (fabs(i * self.frame.size.width / (kBoardSize + 1) - point.x) >= fabs((i + 1) * self.frame.size.width / (kBoardSize + 1) - point.x)) {
                h = i;
                
                break;
            } else {
                
                h = i - 1;
                break;
            }
        }
        
    }
    for (NSUInteger i = 0; i <= kBoardSize; i ++) {
        if (i * self.frame.size.width / (kBoardSize + 1) <= point.y && point.y < (i + 1) * self.frame.size.width / (kBoardSize + 1)) {
            if (i == 0) {
                v = 0;
                break;
            }
            
            if (i == kBoardSize) {
                v = kBoardSize - 1;
                break;
            }
            
            if (fabs(i * self.frame.size.width / (kBoardSize + 1) - point.y) >= fabs((i + 1) * self.frame.size.width / (kBoardSize + 1) - point.y)) {
                v = i;
                
                break;
            } else {
                
                v = i - 1;
                
                break;
            }
        }
        
    }
    
    if (h >= kBoardSize || v >= kBoardSize) {
        
        NSLog(@"failed!");
        self.userInteractionEnabled = YES;
        return;
    }
    
    if ([self move:h y:v type:OccupyTypeHuman]) {
#warning todo
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            LXDChess *chess = [_board fight];
            chess.type = OccupyTypeAI;
            
            [_board des];
            
            
            if (!chess) {
                NSLog(@"failed ,ai do not go");
                return ;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self move:chess.x y:chess.y type:OccupyTypeAI];
                self.userInteractionEnabled = YES;

            });
        });
        
    }
    


    
}

- (BOOL)move:(NSInteger)x y:(NSInteger)y type:(OccupyType)type{ // 向p点进行落子并绘制的方法
    LXDChess *donwChess =  _board.boardArray[x][y];
    if (x < 0 || x >= kBoardSize ||
        y < 0 || y >= kBoardSize) {
        return NO;
    }

//    落子
    LXDChess *chess = [[LXDChess  alloc] initPointWith:x y:y];
    chess.type = type;
    [_board put:chess];
    
    UIImageView *black = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    black.backgroundColor = [UIColor clearColor];
    if (type == OccupyTypeHuman) {
        black.image = [UIImage imageNamed:@"black"];
    }else{
        black.image = [UIImage imageNamed:@"white"];
    }
    black.layer.cornerRadius = 5;
    black.clipsToBounds = YES;
    [self addSubview:black];
    black.frame = CGRectMake((x + 1) * self.frame.size.width / (kBoardSize + 1) - 5, (y + 1) * self.frame.size.height / (kBoardSize + 1) - 5, 10, 10);
    [self addSubview:black];
    
    return YES;

}

@end
