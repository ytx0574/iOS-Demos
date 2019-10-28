//
//  MACustomPinAnnotationView.m
//  GaodeMap
//
//  Created by Johnson on 2019/8/27.
//  Copyright © 2019 Johnson. All rights reserved.
//

#import "MACustomPinAnnotationView.h"

@interface MACustomPinAnnotationView ()
@property (nonatomic, strong) UILabel *labelName;
@end

@implementation MACustomPinAnnotationView

- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews
{
    self.labelName = [[UILabel alloc] init];
    [self addSubview:self.labelName];
    
    @weakify(self)
    [[[RACSignal merge:@[
                         [RACObserve(self.labelName, text) distinctUntilChanged],
                         [RACObserve(self.labelName, font) distinctUntilChanged],
                         [RACObserve(self.labelName, numberOfLines) distinctUntilChanged],
                         [RACObserve(self.labelName, lineBreakMode) distinctUntilChanged],
                         ]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.labelName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.labelName.superview);
        }];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
{
    [super setSelected:selected animated:animated];
    self.labelName.hidden = selected;
}

@end
