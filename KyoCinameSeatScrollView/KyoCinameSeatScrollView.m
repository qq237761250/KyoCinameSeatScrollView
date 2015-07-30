//
//  KyoScrollView.m
//  test
//
//  Created by Kyo on 29/7/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import "KyoCinameSeatScrollView.h"
#import "KyoRowIndexView.h"

#define kRowIndexWith   16
#define kRowIndexSpace  2
#define kRowIndexViewDefaultColor   [[UIColor blackColor] colorWithAlphaComponent:0.7]

@interface KyoCinameSeatScrollView()

@property (strong, nonatomic) NSMutableDictionary *dictSeat;
@property (strong, nonatomic) KyoRowIndexView *rowIndexView;

- (void)btnSeatTouchIn:(UIButton *)btn;

@end

@implementation KyoCinameSeatScrollView

#pragma mark --------------------
#pragma mark - CycLife

- (void)drawRect:(CGRect)rect {
    //计算并设置contentsize
    self.contentSize = CGSizeMake(self.seatLeft + self.column * self.seatSize.width + self.seatRight + (self.showRowIndex ? kRowIndexWith + kRowIndexSpace * 2  : 0),
                                  self.seatTop + self.row * self.seatSize.height + self.seatBottom);
    
    //画座位
    if (!self.dictSeat) self.dictSeat = [NSMutableDictionary dictionary];
    
    CGFloat x = self.seatLeft + (self.showRowIndex ? kRowIndexSpace * 2 : 0);
    CGFloat y = self.seatTop;
    for (NSInteger row = 0; row < self.row; row++) {
        
        NSMutableArray *arraySeat = self.dictSeat[@(row)] ? : [NSMutableArray array];
        
        for (NSInteger column = 0; column < self.column; column++) {
            
            UIButton *btnSeat = nil;
            if (arraySeat.count <= column) {
                btnSeat = [UIButton buttonWithType:UIButtonTypeCustom];
                btnSeat.tag = row;  //tag纪录行数
                [btnSeat addTarget:self action:@selector(btnSeatTouchIn:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btnSeat];
                [arraySeat addObject:btnSeat];
            } else {
                btnSeat = arraySeat[column];
            }
            
            btnSeat.frame = CGRectMake(x, y, self.seatSize.width, self.seatSize.height);
            if (self.kyoCinameSeatScrollViewDelegate &&
                [self.kyoCinameSeatScrollViewDelegate respondsToSelector:@selector(kyoCinameSeatScrollViewSeatStateWithRow:withColumn:)]) {
                KyoCinameSeatState state = [self.kyoCinameSeatScrollViewDelegate kyoCinameSeatScrollViewSeatStateWithRow:row withColumn:column];
                [btnSeat setImage:[self getSeatImageWithState:state] forState:UIControlStateNormal];
            } else {
                [btnSeat setImage:self.imgSeatNormal forState:UIControlStateNormal];
            }
            
            x += self.seatSize.width;
        }
        
        y += self.seatSize.height;
        x = self.seatLeft + (self.showRowIndex ? kRowIndexSpace * 2 : 0);
        
        [self.dictSeat setObject:arraySeat forKey:@(row)];
    }
    
    //画座位行数提示
    if (!self.rowIndexView) {
        self.rowIndexView = [[KyoRowIndexView alloc] init];
        self.rowIndexView.backgroundColor = self.rowIndexViewColor ? : kRowIndexViewDefaultColor;
        [self addSubview:self.rowIndexView];
    }
    if (self.showRowIndex) {
        self.rowIndexView.row = self.row;
        self.rowIndexView.width = kRowIndexWith;
        self.rowIndexView.rowIndexViewColor = self.rowIndexViewColor;
        self.rowIndexView.frame = CGRectMake(kRowIndexSpace, self.seatTop, kRowIndexWith, self.row * self.seatSize.height);
        self.rowIndexView.hidden = NO;
    } else {
        self.rowIndexView.hidden = YES;
    }
}

#pragma mark --------------------
#pragma mark - Events

- (void)btnSeatTouchIn:(UIButton *)btn {
    
    if (self.kyoCinameSeatScrollViewDelegate &&
        [self.kyoCinameSeatScrollViewDelegate respondsToSelector:@selector(kyoCinameSeatScrollViewDidTouchInSeatWithRow:withColumn:)]) {
        NSArray *arraySeat = self.dictSeat[@(btn.tag)];
        NSUInteger column = [arraySeat indexOfObject:btn];
        [self.kyoCinameSeatScrollViewDelegate kyoCinameSeatScrollViewDidTouchInSeatWithRow:btn.tag withColumn:column];
        
        [self setNeedsDisplay];
    }
    
}

#pragma mark --------------------
#pragma mark - Methods

- (UIImage *)getSeatImageWithState:(KyoCinameSeatState)state {
    if (state == KyoCinameSeatStateHadBuy) {
        return self.imgSeatHadBuy;
    } else if (state == KyoCinameSeatStateNormal) {
        return self.imgSeatNormal;
    } else if (state == KyoCinameSeatStateSelected) {
        return self.imgSeatSelected;
    } else if (state == KyoCinameSeatStateUnexist) {
        return self.imgSeatUnexist;
    } else if (state == KyoCinameSeatStateLoversLeftNormal) {
        return self.imgSeatLoversLeftNormal;
    } else if (state == KyoCinameSeatStateLoversLeftHadBuy) {
        return self.imgSeatLoversLeftHadBuy;
    } else if (state == KyoCinameSeatStateLoversLeftSelected) {
        return self.imgSeatLoversLeftSelected;
    } else if (state == KyoCinameSeatStateLoversRightNormal) {
        return self.imgSeatLoversRightNormal;
    } else if (state == KyoCinameSeatStateLoversRightHadBuy) {
        return self.imgSeatLoversRightHadBuy;
    } else if (state == KyoCinameSeatStateLoversRightSelected) {
        return self.imgSeatLoversRightSelected;
    } else {
        return self.imgSeatNormal;
    }
}

@end
