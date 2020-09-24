/*:
 # Block
 
 > Block是将**函数**及其**执行上下文**封装起来的**对象**。
 
 `Block结构体中包含 函数指针以及isa指针`
 
 ![IMG_4001](IMG_4001.PNG)
 
 #### 1、截获变量
 
 * 从变量的不同类型，来理解截获变量
 
 ![IMG_4002](IMG_4002.PNG)
 
 ![IMG_4003](IMG_4003.PNG)
 
  **截获前**
 
 ![IMG_4013](IMG_4013.PNG)
 
  **截获前**
 
 ![IMG_4014](IMG_4014.PNG)
 
 #### 2、__block
 
 ![IMG_4004](IMG_4005.PNG)
 
 * 对于静态局部变量，因为是以指针形式对外部变量进行操作的，所以不需要__block修饰
 
 ![IMG_4004](IMG_4004.PNG)
 
  **block修饰符**
 
 ![IMG_4006](IMG_4006.PNG)
 
 ![IMG_4015](IMG_4015.PNG)
 
 * 将multiplier赋值为4，最终会转化为 **multiplier对象**通过**_forwarding**指针找到对象中**int multiplier**变量，进行赋值
 
 * 在**栈**上的**_forwarding**指针指向的是自身即**multiplier对象**
 
 #### 3、Block的内存管理
 
 ![IMG_4007](IMG_4007.PNG)
 
 * ARC环境下，只有_NSConcreateMallocBlock和_NSConcreateGlobalBlock，因为在ARC环境下系统会将栈上的_NSConcreateStackBlock进行Copy操作，转换成堆上的Block。 ??
 
  **Block的Copy操作**
 
 ![IMG_4008](IMG_4008.PNG)
 
  **栈上Block的销毁**
 
 ![IMG_4016](IMG_4016.PNG)
 
 ![IMG_4009](IMG_4009.PNG)
 
 * 栈上Block进行Copy操作，会在堆上分配一个新的Block，当变量作用域结束，栈上的Block会销毁，堆上的Block还会存在，在**MRC**环境下会产生内存泄露
 
  **栈上Block的Copy操作**
 
  ![IMG_4010](IMG_4010.PNG)
 
 * 如果栈上的Block进行了Copy操作，那么在进行变量的修改，其实是通过栈上Block的_forwarding指针找到堆上的Block，在对堆上的Block变量进行值的修改
 
  **_forwarding存在的意义**
 
 * 不论在任何内存位置，都可以顺利的访问同一个__block变量
 
 
  #### 3、Block的循环引用
 
  ![IMG_4017](IMG_4017.PNG)
 
  ![IMG_4018](IMG_4018.PNG)
 
  ![IMG_4019](IMG_4019.PNG)
 
  ![IMG_4020](IMG_4020.PNG)
 
 * **弊端**: 如果一直不执行Block，那么引用循环就会一直存在。
 
 */
