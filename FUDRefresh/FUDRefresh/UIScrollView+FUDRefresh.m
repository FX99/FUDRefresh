//
//  UIScrollView+FUDRefresh.m
//  FUDRefresh
//
//  Created by fudo on 2017/6/30.
//  Copyright © 2017年 fudo. All rights reserved.
//

#import "UIScrollView+FUDRefresh.h"
#import "FUDRefreshHeader.h"
#import <objc/runtime.h>

const char *FUDRefreshHeaderKey = "fud_refresh_header_key";

@implementation UIScrollView (FUDRefresh)

- (void)addHeaderWithHandle:(void (^)())handler {
    FUDRefreshHeader *header = [[FUDRefreshHeader alloc] init];
    header.refreshHandle = handler;
    self.header = header;
    [self insertSubview:header atIndex:0];
}

- (void)stopRefresh {
    if (self.header) {
        [self.header stopRefresh];
    }
}

- (void)setHeader:(FUDRefreshHeader *)header {
    objc_setAssociatedObject(self, FUDRefreshHeaderKey, header, OBJC_ASSOCIATION_ASSIGN);
}

- (FUDRefreshHeader *)header {
    return objc_getAssociatedObject(self, FUDRefreshHeaderKey);
}

- (void)dealloc {
    NSLog(@"****** %@ dealloc ******", [self class]);
}

@end
