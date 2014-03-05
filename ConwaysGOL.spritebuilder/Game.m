//
// Created by Maxim Filimonov on 4/03/2014.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Game.h"
#import "Cell.h"


@implementation Game {
    NSMutableArray *_cells;
}
- (id)init {
    self = [super init];
    if(self) {
        _cells = [[NSMutableArray alloc] init];
        return self;
    }
    return nil;
}

- (Cell *)spawnCellAtY {
    Cell *cell = [[Cell alloc] init];
    [_cells addObject:cell];
    return cell;
}

- (void)tick {
    for(Cell* cell in _cells){
        [cell die];
    }
}
@end
