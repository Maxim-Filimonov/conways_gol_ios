#import "Kiwi.h"
#import "Grid.h"
#import "Creature.h"
#import "CCBAnimationManager.h"

SPEC_BEGIN(GridSpecs)

describe(@"Grid", ^{
    describe(@"-onEnter", ^{
        it(@"allows user interaction", ^{
            Grid *grid = [[Grid alloc] init];

            [grid onEnter];

            [[theValue(grid.userInteractionEnabled) should] beTrue];
        });
        describe(@"grid setup", ^{
            __block Grid *grid;
            beforeEach(^{
                grid = [[Grid alloc] init];
                [grid onEnter];
            });
            it(@"creates rows", ^{
                [[theValue([[grid gridArray] count]) should] equal:theValue(GRID_ROWS)];
            });
            it(@"creates columns for each row", ^{
                for (NSMutableArray *row in [grid gridArray]) {
                    [[theValue([row count]) should] equal:theValue(GRID_COLUMNS)];
                }
            });
            it(@"creates a creature in every cell", ^{
                for (NSMutableArray *row in [grid gridArray]){
                    for (Creature *cell in row) {
                        [[cell should] beKindOfClass:[Creature class]];
                    }
                }
            });
            it(@"places cells in each corner of the grid", ^{
                grid.contentSize = CGSizeMake(300, 400);
                [grid onEnter];

                Creature* upperLeftCell = [[[grid gridArray] firstObject] firstObject];
                Creature* upperRightCell = [[[grid gridArray] firstObject] lastObject];
                Creature* lowerLeftCell = [[[grid gridArray] lastObject] firstObject];
                Creature* lowerRightCell = [[[grid gridArray] lastObject] lastObject];

                int lastCellX = 300 - 300/GRID_COLUMNS;
                int lastCellY = 400 - 400/GRID_ROWS;
                [[theValue(upperRightCell.position.x - upperLeftCell.position.x) should] equal:theValue(lastCellX)];
                [[theValue(lowerRightCell.position.x - lowerLeftCell.position.x) should] equal:theValue(lastCellX)];
                [[theValue(lowerLeftCell.position.y - upperLeftCell.position.y) should] equal:theValue(lastCellY)];
                [[theValue(lowerRightCell.position.y - upperRightCell.position.y) should] equal:theValue(lastCellY)];
            });
            it(@"adds cells as children of the grid", ^{
                NSUInteger gridChildrenCount = [[grid children] count];

                [[theValue(gridChildrenCount) should] equal:theValue(GRID_COLUMNS*GRID_ROWS)];
            });
        });

        describe(@"-touchBegan", ^{
            __block Grid *grid;
            beforeEach(^{
                grid = [[Grid alloc] init];
                grid.contentSize = CGSizeMake(100, 80);
                [grid onEnter];
            });
            it(@"revives creature in touched cell when it is not alive", ^{
               Creature *selectedCell = (Creature*)[grid gridArray][5][2];
               selectedCell.isAlive = FALSE;

               UITouch *touch = [UITouch mock];
               [touch stub:@selector(locationInNode:) andReturn:theValue(ccp(selectedCell.position.x,selectedCell.position.y))];

               [grid touchBegan:touch withEvent:nil];

                [[theValue(selectedCell.isAlive) should] beTrue];
            });
            it(@"kills creature when is is alive", ^{
                Creature *selectedCell = (Creature*)[grid gridArray][0][0];
                selectedCell.isAlive = TRUE;

                UITouch *touch = [UITouch mock];
                [touch stub:@selector(locationInNode:) andReturn:theValue(ccp(selectedCell.position.x,selectedCell.position.y))];

                [grid touchBegan:touch withEvent:nil];

                [[theValue(selectedCell.isAlive) should] beFalse];

            });
        });
    });
    describe(@"-play", ^{
        __block Grid *grid;
        __block Grid *gameEvolver;
        beforeEach(^{
            grid = [[Grid alloc] init];
            [grid onEnter];

            gameEvolver = [Grid mock];
            [grid setGameEvolver:gameEvolver];
            [gameEvolver stub:@selector(evolveStep)];
            [gameEvolver stub:@selector(generation) andReturn:theValue(0)];
            [gameEvolver stub:@selector(population) andReturn:theValue(0)];
            [grid setGenerationLabel:[[CCLabelTTF alloc] init]];
            [grid setPopulationLabel:[[CCLabelTTF alloc] init]];
        });
       it(@"schedules evolve of step every half a second", ^{
           // 2 schedules per second + 1 initial when schedule launched
           [grid play];

           [[gameEvolver should] receive:@selector(evolveStep) withCount:3];
           [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
       });
       it(@"updates generation label and population labels", ^{
           // 2 schedules per second + 1 initial when schedule launched
           [gameEvolver stub:@selector(generation) andReturn:theValue(42)];
           [gameEvolver stub:@selector(population) andReturn:theValue(111)];
           [grid play];

           [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
           [[grid.generationLabel.string should] equal:@"42"];
           [[grid.populationLabel.string should] equal:@"111"];
       });
    });
    describe(@"-pause", ^{
        __block Grid *grid;
        __block Grid *gameEvolver;
        beforeEach(^{
            grid = [[Grid alloc] init];
            gameEvolver = [Grid mock];
            [grid setGameEvolver:gameEvolver];
        });
        it(@"stops schedule", ^{
            [grid play];

            [[gameEvolver shouldNot] receive:@selector(evolveStep)];
            [grid pause];
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
        });
    });
    describe(@"-countNeighbours", ^{
        __block Grid *grid;
        __block Grid *gameEvolver;
        beforeEach(^{
            grid = [[Grid alloc] init];
            gameEvolver = [Grid mock];
            [grid setGameEvolver:gameEvolver];
            [grid onEnter];
        });
       it(@"counts alive neighbors from row above", ^{
           for (NSUInteger cols = 0; cols < 3; cols++) {
               Creature *creature = [[Creature alloc] initCreature];
               creature.isAlive = TRUE;
               [grid gridArray][0][cols] = creature;
           }
           Creature *testCreature = [[Creature alloc] initCreature];
           [grid gridArray][1][1] = testCreature;

           [grid countNeighbours];

           [[theValue(testCreature.livingNeighbors) should] equal:theValue(3)];
       });
        it(@"counts alive neighbor from row below", ^{
            for (NSUInteger cols = 0; cols < 3; cols++) {
                Creature *creature = [[Creature alloc] initCreature];
                creature.isAlive = TRUE;
                [grid gridArray][2][cols] = creature;
            }
            Creature *testCreature = [[Creature alloc] initCreature];
            [grid gridArray][1][1] = testCreature;

            [grid countNeighbours];

            [[theValue(testCreature.livingNeighbors) should] equal:theValue(3)];
        });
        it(@"counts alive neighbors on the same row", ^{
            Creature* aliveCreature = [[Creature alloc] initCreature];
            aliveCreature.isAlive = TRUE;
            [grid gridArray][1][0] = aliveCreature;
            [grid gridArray][1][2] = aliveCreature;

            Creature *testCreature = [[Creature alloc] initCreature];
            [grid gridArray][1][1] = testCreature;

            [grid countNeighbours];

            [[theValue(testCreature.livingNeighbors) should] equal:theValue(2)];
        });
        it(@"ignores the cell itselfs when counting neighbors", ^{
            Creature* aliveCreature = [[Creature alloc] initCreature];
            aliveCreature.isAlive = TRUE;
            [grid gridArray][1][0] = aliveCreature;
            [grid gridArray][1][2] = aliveCreature;

            Creature *testCreature = [[Creature alloc] initCreature];
            [grid gridArray][1][1] = testCreature;
            testCreature.isAlive = TRUE;

            [grid countNeighbours];

            [[theValue(testCreature.livingNeighbors) should] equal:theValue(2)];
        });
    });
});

SPEC_END
