//
// Created by Maxim Filimonov on 4/03/2014.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Cell.h"


@implementation Cell {
    BOOL _dead;
}

- (BOOL)dead {
    return _dead;
}

- (void)die {
    _dead = TRUE;
}
@end
