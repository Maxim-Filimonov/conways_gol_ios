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
    _cellWidth = self.contentSize.width / GRID_COLUMNS;
    _cellHeight = self.contentSize.height / GRID_ROWS;

    float x = 0;
    float y = 0;

    _gridArray = [NSMutableArray array];
    for (NSUInteger rowIndex = 0; rowIndex < GRID_ROWS; rowIndex++) {
        x = 0;
        _gridArray[rowIndex] = [NSMutableArray array];
        for (NSUInteger columnIndex = 0; columnIndex < GRID_COLUMNS; columnIndex++) {

            Creature* creature = [[Creature alloc] initCreature];
            creature.anchorPoint = ccp(0, 0);
            creature.position = ccp(x, y);
            [self addChild:creature];
            _gridArray[rowIndex][columnIndex] = creature;

            x += _cellWidth;
        }
        y += _cellHeight;
    }
}

@end
