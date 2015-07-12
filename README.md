# YXLabel
允许点击指定文本，根据[PPLabel](https://github.com/petrpavlik/PPLabel)修改而来。

## 用法
<pre><code>
 YXLabel *label = [[YXLabel alloc] initWithFrame:CGRectMake(10, 40, 200, 44)];
 label.backgroundColor = [UIColor whiteColor];
 label.text = @"段誉回复张宝山";
 [label addClickText:@"张宝山" action:^{
        NSLog(@"点击了:张宝山");
 }];
 [label addClickText:@"段誉" action:^{
         NSLog(@"点击了:段誉");
  }];
  [self.view addSubview:label];
</code></pre>

## 注意
不支持attributedText。
