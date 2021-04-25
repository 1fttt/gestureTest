//
//  ViewController.m
//  手势
//
//  Created by 房彤 on 2021/4/16.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutUI];
}

- (void)layoutUI {
    self.view.backgroundColor = [UIColor whiteColor];
    _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100, 300, 200, 200)];
    [self.view addSubview:_imageView1];
    [_imageView1 setImage:[UIImage imageNamed:@"tj11.jpg"]];
    _imageView1.userInteractionEnabled = YES;
    _imageView1.layer.masksToBounds = YES;
    [self addGestures:_imageView1];
    

    
    
}

//添加手势
- (void)addGestures:(UIImageView *)imageView {
    //拖动
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [imageView addGestureRecognizer:pan];
    
    //捏合
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [imageView addGestureRecognizer:pinch];
    
    
    //旋转
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
    [imageView addGestureRecognizer:rotation];
    
    //点按
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [imageView addGestureRecognizer:tap];
    
    //长按
    UILongPressGestureRecognizer *longPerss = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [imageView addGestureRecognizer:longPerss];
    
    
    //轻扫
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    //设置轻扫方向
    
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
   
    //绑定轻扫手势；支持四个方向的轻扫，但是不同的方向要分别定义轻扫手势
    [self.view addGestureRecognizer:swipe];
    
    
}


//拖动
- (void)pan:(UIPanGestureRecognizer *)recognizer {
    //视图前置操作
      [recognizer.view.superview bringSubviewToFront:recognizer.view];
       
      CGPoint center = recognizer.view.center;
      CGFloat cornerRadius = recognizer.view.frame.size.width / 2;
      CGPoint translation = [recognizer translationInView:self.view];
      //NSLog(@"%@", NSStringFromCGPoint(translation));
      recognizer.view.center = CGPointMake(center.x + translation.x, center.y + translation.y);
      [recognizer setTranslation:CGPointZero inView:self.view];
       
      if (recognizer.state == UIGestureRecognizerStateEnded) {
        //计算速度向量的长度，当他小于200时，滑行会很短
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        //NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult); //e.g. 397.973175, slideMult: 1.989866
         
        //基于速度和速度因素计算一个终点
        float slideFactor = 0.1 * slideMult;
        CGPoint finalPoint = CGPointMake(center.x + (velocity.x * slideFactor),
                         center.y + (velocity.y * slideFactor));
        //限制最小［cornerRadius］和最大边界值［self.view.bounds.size.width - cornerRadius］，以免拖动出屏幕界限
        finalPoint.x = MIN(MAX(finalPoint.x, cornerRadius),
                  self.view.bounds.size.width - cornerRadius);
        finalPoint.y = MIN(MAX(finalPoint.y, cornerRadius),
                  self.view.bounds.size.height - cornerRadius);
         
        //使用 UIView 动画使 view 滑行到终点
        [UIView animateWithDuration:slideFactor*2
                   delay:0
                  options:UIViewAnimationOptionCurveEaseOut
                 animations:^{
                   recognizer.view.center = finalPoint;
                 }
                 completion:nil];
      }
}

//捏合
- (void)pinch:(UIPinchGestureRecognizer *)pinchRecognizer {
    
    _imageView1.transform = CGAffineTransformScale(pinchRecognizer.view.transform, pinchRecognizer.scale, pinchRecognizer.scale); 
    pinchRecognizer.scale = 1;
}

//旋转
- (void)rotation:(UIRotationGestureRecognizer *)rotation {
    rotation.view.transform = CGAffineTransformRotate(rotation.view.transform, rotation.rotation);
    rotation.rotation = 0.0;
    
}

//点按
- (void)tap:(UITapGestureRecognizer *)tap {
    tap.view.transform = CGAffineTransformMakeScale(2.0, 2.0);
    
}


//长按
- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    longPress.view.transform = CGAffineTransformMakeScale(1, 1);
}

- (void)swipe:(UISwipeGestureRecognizer *)swipe {
    switch (swipe.direction) {
        case UISwipeGestureRecognizerDirectionRight: {
            //swipe.view.center.y -= 20.0;
            
            CGPoint new = swipe.view.center;
            new.x += 30;
            _imageView1.center = new;
            break;
        }
           
        case UISwipeGestureRecognizerDirectionDown: {
            CGPoint new = swipe.view.center;
            new.y += 30;
            _imageView1.center = new;
            break;
        }
        case UISwipeGestureRecognizerDirectionLeft: {
            CGPoint new = swipe.view.center;
            new.x -= 30;
            _imageView1.center = new;
            break;
        }
        case UISwipeGestureRecognizerDirectionUp: {
            CGPoint new = swipe.view.center;
            new.y -= 30;
            _imageView1.center = new;
            break;
        }
        default: {
            NSLog(@"1");
            
            break;
        }
            
            
    }
}

@end
