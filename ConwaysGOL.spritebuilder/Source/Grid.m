//
// Created by Maxim Filimonov on 13/04/2014.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Creature.h"
#import "CCNode_Private.h"
#import "CCLabelTTF.h"


@implementation Grid {
    NSMutableArray *_gridArray;
    int _generation;
    int _totalAlive;
    CCLabelTTF *_generationLabel;
    CCLabelTTF *_populationLabel;
}
// Calls on loading of grid into UI
- (void)onEnter {
    [super onEnter];

    _cellWidth = self.contentSize.width / GRID_COLUMNS;
    _cellHeight = self.contentSize.height / GRID_ROWS;
    [self setupGrid];

    self.userInteractionEnabled = TRUE;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];

    Creature *creature = [self creatureForTouchPosition:touchLocation];

    creature.isAlive = ! creature.isAlive;
}

- (Creature *)creatureForTouchPosition:(CGPoint)point {
    NSUInteger rowIndex = (NSUInteger) (point.y / self.cellHeight);
    NSUInteger columnIndex = (NSUInteger) (point.x / self.cellWidth);
    NSMutableArray *row = _gridArray[rowIndex];
    return row[columnIndex];
}

- (id)init {
    self = [super init];
    if (self) {
        [self setGameEvolver:self];
    }

    return self;
}

- (void)setupGrid {

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

            x += self.cellWidth;
        }
        y += self.cellHeight;
    }
}

- (void)play {
    [self schedule:@selector(step) interval:0.5f];
}

- (void)pause {
    [self unschedule:@selector(step)];
}

- (void)step {
    [self.gameEvolver evolveStep];
    self.generationLabel.string = [NSString stringWithFormat:@"%d", _gameEvolver.generation];
    self.populationLabel.string = [NSString stringWithFormat:@"%d", _gameEvolver.population];
}

- (void)evolveStep {
    [self countNeighbours];

    [self updateCreatures];

    [self setGeneration:self.gameEvolver.generation++];
}

- (void)updateCreatures {

}

- (void)countNeighbours {

   for(NSMutableArray *row in _gridArray) {
       for(Creature* creature in row) {
           creature.livingNeighbors = 0;
           NSUInteger topRowIndex = [_gridArray indexOfObject:row] - 1;
           for (NSUInteger rowNeighborsIndex = topRowIndex; rowNeighborsIndex <= topRowIndex + 2; rowNeighborsIndex++) {
               NSUInteger leftColumnIndex = [row indexOfObject:creature] - 1;

               for (NSUInteger neighborsIndex = leftColumnIndex; neighborsIndex <= leftColumnIndex + 2; neighborsIndex++) {
                   if([self isIndexValidForRow:rowNeighborsIndex andColumn:neighborsIndex])
                   {
                       NSMutableArray *neighborRow = _gridArray[rowNeighborsIndex];
                       Creature* neighbor = neighborRow[neighborsIndex];

                       if(neighbor.isAlive && neighbor != creature) {
                           creature.livingNeighbors += 1;
                       }
                   }
               }
           }
       }
   }
}

- (BOOL)isIndexValidForRow:(NSUInteger)rowIndex andColumn:(NSUInteger)columnIndex {
    BOOL isIndexValid = TRUE;
    if(rowIndex < 0 || columnIndex < 0 || rowIndex >= GRID_ROWS || columnIndex >= GRID_COLUMNS){
        isIndexValid = FALSE;
    }
    return isIndexValid;
}
@end
