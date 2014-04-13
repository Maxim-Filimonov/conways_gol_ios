//
// Created by Maxim Filimonov on 13/04/2014.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Creature.h"


@implementation Grid {
    NSMutableArray *_gridArray;
    float _cellWidth;
    float _cellHeight;
    int _generation;
    int _totalAlive;
}
// Calls on loading of grid into UI
- (void)onEnter {
    [super onEnter];

    [self setupGrid];

    self.userInteractionEnabled = TRUE;
}

- (void)setupGrid {
    _gridArray = [NSMutableArray array];
    for (NSUInteger rowIndex = 0; rowIndex < GRID_ROWS; rowIndex++) {
        _gridArray[rowIndex] = [NSMutableArray array];
        for (NSUInteger columnIndex = 0; columnIndex < GRID_COLUMNS; columnIndex++) {

            Creature* creature = [[Creature alloc] initCreature];
            _gridArray[rowIndex][columnIndex] = creature;

        }
    }
}

@end
