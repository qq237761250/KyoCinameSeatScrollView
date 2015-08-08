//
//  KyoRowIndexView.h
//  test
//
//  Created by Kyo on 30/7/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KyoCinameSeatScrollView.h"

@interface KyoRowIndexView : UIView

@property (nonatomic, assign) NSUInteger row;
@property (assign, nonatomic) CGFloat width;
@property (weak, nonatomic) UIColor *rowIndexViewColor;
@property (assign, nonatomic) KyoCinameSeatRowIndexType rowIndexType;

@end
