#设置slow animation
p [(CALayer *)[[[[UIApplication sharedApplication] windows] objectAtIndex:0] layer] setSpeed:.1f]
#autolay out 调试
po [[UIWindow keyWindow] _autolayoutTrace]
#调试 所有view的 frame层级
po [[UIApp keyWindow] recursiveDescription] 
