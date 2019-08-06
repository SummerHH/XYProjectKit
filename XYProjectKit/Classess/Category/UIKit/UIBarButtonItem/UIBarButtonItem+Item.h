#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)


+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;


+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)color target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image withTitle:(NSString *)title titleColor:(UIColor *)color withFrame:(CGRect *)rect target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end
