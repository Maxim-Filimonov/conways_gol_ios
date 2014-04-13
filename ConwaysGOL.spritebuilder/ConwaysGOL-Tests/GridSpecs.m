#import "Kiwi.h"
#import "Grid.h"
#import "Creature.h"

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
                for (NSUInteger rowIndex = 0; rowIndex < [[grid gridArray] count]; rowIndex++) {
                    NSMutableArray *row = [grid gridArray][rowIndex];
                    [[theValue([row count]) should] equal:theValue(GRID_COLUMNS)];
                }
            });
            it(@"creates a creature in every cell", ^{
                for (NSUInteger rowIndex = 0; rowIndex < [[grid gridArray] count]; rowIndex++) {
                    NSMutableArray *row = [grid gridArray][rowIndex];
                    for (NSUInteger columnIndex = 0; columnIndex < [row count]; columnIndex++) {
                        NSMutableArray *cell = row[columnIndex];
                        [[cell should] beKindOfClass:[Creature class]];
                    }
                }
            });
        });
    });
});

SPEC_END



