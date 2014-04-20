#import "MainScene.h"
#import "Grid.h"

@implementation MainScene {
    CCLabelTTF *_generationLabel;
    CCLabelTTF *_populationLabel;
}
- (void)play {
    [self schedule:@selector(step) interval:0.5f];
}

- (void)pause {
    [self unschedule:@selector(step)];
}

- (void)step {
    [self.grid evolveStep];
    self.generationLabel.string = [NSString stringWithFormat:@"%d", self.grid.generation];
    self.populationLabel.string = [NSString stringWithFormat:@"%d", self.grid.population];
}
@end
