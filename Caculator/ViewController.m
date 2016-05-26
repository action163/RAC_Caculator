//
//  ViewController.m
//  Caculator
//
//  Created by jzl on 16/5/20.
//  Copyright © 2016年 jiaozhenlong. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "OtherVIewController.h"
#import "FlagItem.h"
@interface ViewController ()
@property(nonatomic,strong)RACCommand* command;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 200, 300, 100);
    [button setTitle:@"通知" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
//监听UIButton控件的UIControlEventTouchUpInside事件
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"点击了button");
        [self racCommand];
     }];
    
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(100, 380, 100, 30)];
    label.textColor = [UIColor redColor];
    [self.view addSubview:label];
    
    
    
//监听textField的点击事件
    UITextField* textfield = [[UITextField alloc] initWithFrame:CGRectMake(100, 300, 100, 30)];
    textfield.placeholder = @"hello";
    [textfield.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"点击了textfield%@",x);
    }];
    [self.view addSubview:textfield];
    
    [[label rac_valuesAndChangesForKeyPath:@"text.length" options:NSKeyValueObservingOptionOld observer:nil] subscribeNext:^(id x) {
        
        NSLog(@"KVO监测===%@",x);
        
    }];
    //监听某个对象的某个属性值  textfield 的值长度
    [RACObserve(textfield, text.length) subscribeNext:^(id x) {
        
        NSLog(@"length == %@",x);
    }];

    //只要textField的值改变,那么label的值就会改变
    RAC(label,text) = textfield.rac_textSignal;
    
    
//监听键盘变化
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification* notification) {
        NSDictionary* info = [notification userInfo];
        NSValue* keyboardFrameValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
        NSLog(@"键盘弹出%@",NSStringFromCGRect(keyboardFrame));
    }];
    [[[NSNotificationCenter defaultCenter]
      rac_addObserverForName:UIKeyboardWillHideNotification
      object:nil]
     subscribeNext:^(NSNotification *notification) {
         NSDictionary* info = [notification userInfo];
         NSValue* keyboardFrameValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
         CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
         NSLog(@"键盘消失%@",NSStringFromCGRect(keyboardFrame));
     }
     ];
    

    
    NSArray *numbers = @[@2,@2,@3,@4];
    
    // 这里其实是三步
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    
    // 遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"name":@"xmg",@"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        // 相当于以下写法
        //        NSString *key = x[0];
        //        NSString *value = x[1];
        
//        NSLog(@"%@ %@",key,value);
        
    }];

    
//    rac字典转模型
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *flags = [NSMutableArray array];
    
    [dictArr.rac_sequence.signal subscribeNext:^(id x) {
        FlagItem* item = [FlagItem flagWithDic:x];
        [flags addObject:item];
    }];
    
    [self racCommand];

}
-(void)btnClick:(id)sender{
   /* .h文件中定义代理信号
    @property(nonatomic,strong)RACSubject* delegateSignal;
———————————————————————————————————————————————————————————————————
    if (self.delegateSignal) {
        发送信息
        [self.delegateSignal sendNext:@"hello  world"];
    }
——————————————————————————————————————————————————————————————————
         */
    [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        
        NSLog(@"控制器调用了viewDidLoad");
    }];
    OtherVIewController* vc = [[OtherVIewController alloc] init];
    //设置代理信号
    vc.delegateSignal = [RACSubject subject];
    //订阅代理信号
    [vc.delegateSignal subscribeNext:^(id x) {
    //x为传过来的值
        NSLog(@"我运行了");
        NSLog(@"%@",x);
    }];
    [self presentViewController:vc animated:YES completion:nil];

    
}

-(void)racCommand{
    
    RACCommand* command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //这儿进行网络请求
            //将请求到的数据传递出去
            [subscriber sendNext:@"这是请求到的数据"];
            return nil;
        }];
    }];
    
    _command = command;
    
    
    //获取请求数据
    [command.executionSignals subscribeNext:^(id x) {
        [x subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];

    //监听命令是否执行完毕 skip跳过第一次信号
    [[command.executing skip:1] subscribeNext:^(id x) {
        
       
        if ([x boolValue] == YES) {
            // 正在执行
             NSLog(@"%@",x);
            NSLog(@"正在执行");
        }else{
            // 执行完成
            NSLog(@"执行完成");
        }
        
    }];
    

    // 5.执行命令
    [self.command execute:@"这玩意有屌用啊"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
