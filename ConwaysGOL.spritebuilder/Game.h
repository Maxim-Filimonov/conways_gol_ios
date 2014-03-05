//
// Created by Maxim Filimonov on 4/03/2014.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Cell;


@interface Game : NSObject
- (Cell *)spawnCellAtY;

- (void)tick;
@end
