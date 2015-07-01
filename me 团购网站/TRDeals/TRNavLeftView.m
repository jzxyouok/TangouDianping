//
//  TRNavLeftView.m
//  TRDeals
//
//  Created by tarena on 15-6-25.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "TRNavLeftView.h"

@implementation TRNavLeftView

+ (id)view {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"TRNavLeftView" owner:nil options:nil] lastObject];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }

    return self;
}

- (void)addTarget:(id)target action:(SEL)action {
    [self.navButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}




@end
