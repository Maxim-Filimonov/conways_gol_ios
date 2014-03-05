#import "Kiwi.h"
#import "Game.h"
#import "Cell.h"

SPEC_BEGIN(GameSpecs)

describe(@"Game of life",^{
    describe(@"Rule1: Any live cell with fewer than two live neighbours dies, as if by needs caused by underpopulation.", ^{
        it(@"kills the cells if it has no neighbourds", ^{
            Game *game = [[Game alloc] init];
            Cell *cell = [game spawnCellAtY];
            [game tick];
            [[theValue([cell dead]) should] beTrue];
        });
    });
});

SPEC_END



