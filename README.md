# GreedySnake_base_on_LEDArray
/*Many projects are based on VGA or other peripheral, so owing to my hand-by FPGA device and 5*7 LED arrays, I improve the algorithm of it, so u can easily use it for many parts*/
/************************************************************************************************************************************************/
主要的思想是利用LED动态刷新的方法，当然这也是基于网上一些优秀的博主VGA的方式的一种改良，只适配LED点阵的情况，如果有需要的小伙伴，也可以参考一下我的代码思想。
我的代码思想是这样的：1）Dynamic显示：每次将采集到的蛇的动态位置放到一个35\*11的点阵中,然后用一个很快的速率读取前7或5位数据，这里的35为我的LED的数目，11为我设置的蛇身长度，7为行数据，5为列数据；
                     2）蛇身update(Refresh):每次吃到食物比较判断（case语句）：然后动态刷新将snake_x【0】的数组赋值给snake_x【1】，snake_x【0】是蛇头的位置等等。。
BUG: 1） 时钟选择问题，吃到食物不能立刻刷新，增大时钟刷新频率即可（我的基础频率50MHZ，分频后1HZ）
     2） 食物刷新问题：动态规划食物刷新算法，开拓中。。。。。。
同时一些不足之处恳请指出和修改，共同学习。
