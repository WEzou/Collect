/*:
# 内存管理

 * 内存布局
 * 内存管理方法
 * 数据结构
 * MRC
 * ARC
 * 引用计数管理
 * 弱引用管理
 * 自动释放池
 * 循环引用

 ----------

 #### 1、内存布局
 
 ![IMG_3960](IMG_3960.PNG)
 
 * stack：方法调用（编译器自动分配并释放。在执行函数时，函数内局部变量的存储单元都可以在栈上创建，函数执行结束时这些存储单元自动被释放）
 * heap：通过alloc等分配的对象
 * bss：未初始化的全局变量、静态变量等
 * data：已初始化的全局变量等
 * text：程序代码（存放函数体的二进制代码，运行程序就是执行代码，代码要执行就要加载进内存）
 * 常量区：常量字符串等。
 
  #### 2、内存管理方法
 
 * 1、TaggedPointer （小对象 eg： NSNumber）
 * 2、NONPOINTER_ISA (非指针型的isa。在64位架构下，isa指针本来站64位，但是实际32或40位就够用了，剩余的就存储关于内存管理的相关数据内容，提高使用率)
 * 3、散列表（弱引用表、引用计数表）
 
  **散列表（哈希表）**
 
  ![IMG_3962](IMG_3962.PNG)
 
 > **为什不是一个SideTable？**
 > 假如只有一张SideTable，相当于我们在内存中分配的所有对象（引用计数、弱引用表）都存储在这张SideTable中，这时如果我们要操作某一对象的引用计数值（比如修改、增减），由于所有的对象可能在不同的线程分配创建、包括调用retain、release方法在不同的线程操作，都需要对这张表进行加锁处理才能保证数据安全，这就存在**效率的问题**，如果很多对象都需要操作这张表，只有等前一个对象操作完，才能操作下一个对象，显然效率就会很低。所以系统引入**分离锁**，分离成多张表，这样的话，不同对象就能并发操作，提高效率。
 
 
  **快速分流**
 
  ![IMG_3961](IMG_3961.PNG)
 
  * 通过对象指针作为Key，经过Hash函数的计算，就能得出SideTable的位置Value。
 
  **Hash查找**
 
  ![IMG_3963](IMG_3963.PNG)
 
  * 不涉及遍历的操作，所以Hash查找的为了提高效率，Hash表是均匀分布。
  * Hash查找效率的提高源于我们存储对象的引用计数是通过Hash函数来计算存储位置的，而我们获取对象所代表的引用计数值也是通过这个Hash函数来获取的索引位置。插入和查找都是通过同一Hash函数来操作，所以就避免了循环遍历操作，提高效率
 
  #### 3、数据结构
 
  * Spinlock_t自旋锁
  * RefcountMap引用计数表
  * weak_table_t弱引用表
 
  **自旋锁**

  * 自旋锁是**忙等**的锁**。如果当前锁已被其他线程获取，那么的当前线程会不断的探测当前锁是否有被释放，如果释放掉，自己第一时间去获取这个锁。
  * 适用于轻量访问。
 
  **引用计数表**
 
  ![IMG_3964](IMG_3964.PNG)
 
  * 引用计数表是通过Hash表来实现的
  * 为什么用Hash表来实现？ ->     插入和查找都是通过同一Hash函数来操作，避免了循环遍历操作。
 
  **弱引用表**
 
  ![IMG_3965](IMG_3965.PNG)
 
  * 弱引用表是通过Hash表来实现的
  * weak_entry_t弱引用数组，存储弱引用指针
 
  #### 4、MRC  手动引用计数
 
  ![IMG_3976](IMG_3976.PNG)
 
  #### 5、ARC 自动引用计数
 
  * ARC是LLVM（编译器自动插入retain/release）和Runtime协作的结果
  * ARC中禁止手动调用retain/release/retainCount/dealloc
  * ARC中新增weak、strong属性关键字
 
  #### 6、引用计数管理
 
  **alloc**
 
  ![IMG_3966](IMG_3966.PNG)
 
  * alloc并没有设置引用计算为1，但是通过retainCount获取的引用计数确是1。
 
  **retain**
 
  ![IMG_3967](IMG_3967.PNG)
 
  * 1、通过this（当前对象指针），经过Hash查找，可以快速获取对应的SideTable。
  * 2、通过this（当前对象指针），经过Hash查找，可以在SideTable表中查找引用计算值。
  * 3、进行+1操作。
 
  **release**
 
  ![IMG_3968](IMG_3968.PNG)
 
  **retainCount**
 
  ![IMG_3969](IMG_3969.PNG)
 
  * 当新alloc一个对象，在引用计数表是没有这个对象相关联的Key->Value映射，这个值读出来是0，但是局部变量是1，所以最终得出来的retainCount是1。
 
  **dealloc**
 
  ![IMG_3972](IMG_3972.PNG)
 
  ![IMG_3973](IMG_3973.PNG)
 
  ![IMG_3974](IMG_3974.PNG)
 
  ![IMG_3975](IMG_3975.PNG)
 
  #### 7、弱引用管理
  
  **添加weak变量**
 
  ![IMG_3977](IMG_3977.PNG)
 
  * 一个被申明__weak的对象指针，经过编译器编译之后，会调用objc_initWeak(),然后经过一系列的函数调用栈，最终在weak_register_no_lock()中进行弱引用的添加，具体添加的位置是通过Hash算法来查找，如果查找的位置中已经有了当前对象所对应的弱引用数组，那就把新的弱引用变量添加到数组中，如果没有，就创建一个弱引用数组，然后把第0个变量，添加上最新弱引用变量，后面的初始化为nil。
  
  **清初weak变量，并置指向nil**
  
  ![IMG_3978](IMG_3978.PNG)
  
  * 当一对象被dealloc后，在dealloc的内部实现中，会调用weak_clear_no_lock(),然后在这个函数的内部实现中，会根据当前对象指针查找弱引用表，把当前对象相对应的弱引用都拿出来-是一个弱引用数组，然后遍历数组中所有弱引用，并置为nil，
  
  #### 8、自动释放池
  
  **AutoreleasePool**
 
  ![IMG_3989](IMG_3989.PNG)
  
  ![IMG_3980](IMG_3980.PNG)
  
  **AutoreleasePoolPage**
   
  ![IMG_3982](IMG_3982.PNG)
 
  ![IMG_3983](IMG_3983.PNG)
  
  * next: 指向下一个可填充的位置
  * AutoreleasePoolPage和线程是一一对应的
  
  **AutoreleasePoolPage::push**

  ![IMG_3981](IMG_3981.PNG)
  
  * 发生一次AutoreleasePoolPage::push，会将当前next置为nil
  * 然后将next指针指向下一个可入栈的位置
  * 每调用一次AutoreleasePoolPage::push，就是在栈中插入哨兵对象
  
  **[objc autorelase]**
  
  ![IMG_3984](IMG_3984.PNG)
 
  ![IMG_3985](IMG_3985.PNG)
 
  **AutoreleasePoolPage::pop**
  
  ![IMG_3986](IMG_3986.PNG)
  
  **实战场景**
  
  ![IMG_3988](IMG_3988.PNG)
  
  #### 9、循环引用
  
  * 1、自循环引用
  * 2、相互循环引用
  * 3、多循环引用
  
  **循环引用考点**
  
  * 代理（相互引用）
  * block
  * NSTimer
  
  **破除循环引用**
  
  * 避免产生循环引用
  * 在合适的时机手动断环
  
  * __weak
  * __block
  * __unsafe_unretained(修饰的对像没有增加引用计数、建议抛弃使用)
 
  ![IMG_3990](IMG_3990.PNG)
 
  ![IMG_3991](IMG_3991.PNG)
  
  **示例-NSTimer**
  
  ![IMG_3992](IMG_3992.PNG)
 
  ![IMG_3993](IMG_3993.PNG)
 
  ![IMG_3994](IMG_3994.PNG)
  
  * 1、通过创建中间对象，让中间对象持有两个弱引用变量（对象、NSTimer），然后NSTimer的回调是在中间对象实现的。
  * 2、在NSTimer的回调方法中，对它所持有的原对象进行值的判断，如果对象还存在，就调用原对象的方法，如果对象已经被释放，就设置NSTimer为无效状态，就可以解除Runloop对NSTimer的强引用，以及NSTimer对中间对象的强引用。
  * 利用对象被释放后，会被置为nil的特点，在下一个回调中判断对象是否为nil，然后设置NSTimer为无效状态。
 */
