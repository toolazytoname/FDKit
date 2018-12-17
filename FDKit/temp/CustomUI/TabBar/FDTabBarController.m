//
//  FDTabBarController.m
//  AFNetworking
//
//  Created by Lazy on 2018/12/17.
//

#import "FDTabBarController.h"
#import "FDTabBar.h"
#import "FDCategoriesMacro.h"

@interface FDTabBarController ()
@property (nonatomic, strong) FDTabBar *customFDTabbar;
@end

@implementation FDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [child removeFromSuperview];
        }
    }
}

- (void)setCustomFDTabbar:(FDTabBar *)customFDTabbar {
    _customFDTabbar = customFDTabbar;
    [self setValue:_customFDTabbar forKey:@"tabBar"];
    @weakify(self)
    [_customFDTabbar setSelectedIndexChanged:^(NSUInteger currentIndex) {
        @strongify(self)
        self.selectedIndex = currentIndex;
    }];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex != self.selectedIndex) {
        [super setSelectedIndex:selectedIndex];
    }

}
#pragma mark - 屏幕旋转相关
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate {
    return self.selectedViewController.shouldAutorotate;
}
@end
