//
//  FUDRefreshHeader.h
//  FUDRefresh
//
//  Created by fudo on 2017/6/30.
//  Copyright © 2017年 fudo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FUDRefreshHeader : UIView

@property (nonatomic, copy) void(^refreshHandle)();

- (void)stopRefresh;

@end
