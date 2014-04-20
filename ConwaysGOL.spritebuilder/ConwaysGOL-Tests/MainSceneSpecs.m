#import "Kiwi.h"
#import "MainScene.h"
#import "Grid.h"

SPEC_BEGIN(MainSceneSpecs)

describe(@"MainScene", ^{
    describe(@"-play", ^{
        __block MainScene *scene;
        __block Grid *gameEvolver;
        beforeEach(^{
            scene = [[MainScene alloc] init];
            [scene setGenerationLabel:[[CCLabelTTF alloc] init]];
            [scene setPopulationLabel:[[CCLabelTTF alloc] init]];

            gameEvolver = [Grid mock];
            [scene setGrid:gameEvolver];

            [gameEvolver stub:@selector(evolveStep)];
            [gameEvolver stub:@selector(generation) andReturn:theValue(0)];
            [gameEvolver stub:@selector(population) andReturn:theValue(0)];
        });
       it(@"schedules evolve of step every half a second", ^{
           // 2 schedules per second + 1 initial when schedule launched
           [scene play];

           [[gameEvolver should] receive:@selector(evolveStep) withCountAtLeast:2];
           [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
       });
       it(@"updates generation label and population labels", ^{
           // 2 schedules per second + 1 initial when schedule launched
           [gameEvolver stub:@selector(generation) andReturn:theValue(42)];
           [gameEvolver stub:@selector(population) andReturn:theValue(111)];

           [scene play];

           [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
           [[scene.generationLabel.string should] equal:@"42"];
           [[scene.populationLabel.string should] equal:@"111"];
       });
    });
    describe(@"-pause", ^{
        __block MainScene *scene;
        __block Grid *gameEvolver;
        beforeEach(^{
            scene = [[MainScene alloc] init];
            gameEvolver = [Grid mock];
            [scene setGrid:gameEvolver];
        });
        it(@"stops schedule", ^{
            [scene play];

            [[gameEvolver shouldNot] receive:@selector(evolveStep)];

            [scene pause];
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
        });
    });
});

SPEC_END
