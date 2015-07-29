//
//  ViewController.m
//  test
//
//  Created by Kyo on 29/7/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import "ViewController.h"
#import "KyoCinameSeatScrollView.h"

@interface ViewController ()<KyoCinameSeatScrollViewDelegate>

@property (weak, nonatomic) IBOutlet KyoCinameSeatScrollView *kyoScrollView;

@property (strong, nonatomic) NSMutableDictionary *dictSeatState;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dictSeatState = [NSMutableDictionary dictionary];
    for (NSInteger row = 0; row < self.kyoScrollView.row; row++) {
        NSMutableArray *arrayState = [NSMutableArray array];
        for (NSInteger column = 0; column < self.kyoScrollView.column; column++) {
            if (row * column % 5 == 0) {
                [arrayState addObject:@(KyoCinameSeatStateHadBuy)];
            } else if (row * column % 5 == 0) {
                [arrayState addObject:@(KyoCinameSeatStateUnexist)];
            } else {
                [arrayState addObject:@(KyoCinameSeatStateNormal)];
            }
        }
        [self.dictSeatState setObject:arrayState forKey:@(row)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --------------------
#pragma mark - KyoCinameSeatScrollViewDelegate

//座位状态
- (KyoCinameSeatState)kyoCinameSeatScrollViewSeatStateWithRow:(NSUInteger)row withColumn:(NSUInteger)column {
    NSMutableArray *arraySeat = self.dictSeatState[@(row)];
    return (KyoCinameSeatState)[arraySeat[column] integerValue];
}

//点击座位
- (void)kyoCinameSeatScrollViewDidTouchInSeatWithRow:(NSUInteger)row withColumn:(NSUInteger)column {
    NSMutableArray *arraySeat = self.dictSeatState[@(row)];
    KyoCinameSeatState currentState = (KyoCinameSeatState)[arraySeat[column] integerValue];
    if (currentState == KyoCinameSeatStateNormal) {
        [arraySeat replaceObjectAtIndex:column withObject:@(KyoCinameSeatStateSelected)];
    } else if (currentState == KyoCinameSeatStateSelected) {
        [arraySeat replaceObjectAtIndex:column withObject:@(KyoCinameSeatStateNormal)];
    } else if (currentState == KyoCinameSeatStateHadBuy || currentState == KyoCinameSeatStateUnexist) {
        return;
    }
}

@end
