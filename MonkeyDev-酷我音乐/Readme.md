//
//  Readme.md
//  XXX
//
//  Created by Johnson on 2019/6/7.
//  Copyright © 2019 Johnson. All rights reserved.
//

1. 直接找到第三方的屏蔽插件.dylib, 放到工程目录中;
2. cd到TargetApp的.app目录中, 使用(.insert_dylib @executable_path/Frameworks/YouTubePatcher.dylib YouTube) 添加动态库到二进制的loadcommands里面. 不要使用mokeydev的说明.(https://github.com/AloneMonkey/MonkeyDev/wiki/%E9%9D%9E%E8%B6%8A%E7%8B%B1App%E9%9B%86%E6%88%90), 这种方式没有效果



./insert_dylib @executable_path/kwmusic.dylib 




iPhone Developer: Jackson Nicholas (7297NWTG75)
