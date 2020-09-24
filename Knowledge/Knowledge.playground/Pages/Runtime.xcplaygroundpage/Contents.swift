/*:
 # Runtime
 
 * objc_object
 * objc_class
 * isa指针
 * cache_t
 * class_data_bits_t
 * class_rw_t
 * class_rw_o
 * method_t
 * 对象、类对象、元类对象
 * 消息传递
 * 消息转发
 * 实战
 
  ----------
 
 #### 1、objc_object结构体（对象：id）
 
 ![IMG_3919](IMG_3919.PNG)
 
 
 #### 2、objc_class结构体(类对象： Class)

 ![IMG_3920](IMG_3920.PNG)

 
 #### 3、isa指针
 
 32/64位0-1数字

 ![IMG_3921](IMG_3921.PNG)
 
 ![IMG_3922](IMG_3922.PNG)
 
 ![IMG_3928](IMG_3928.PNG)


 #### 4、cache_t
 
 ![IMG_3923](IMG_3923.PNG)

 局部性原理：将调用频率最高的方法放入在cache_t中，提高命中率，提升效率。
 
 ![IMG_3924](IMG_3924.PNG)

 * cache_t可以理解为 [bucket_t] 的数据结构
 * bucket_t包含Key（方法选择器），IMP（无类型函数指针）
 * 通过Key使用**哈希查找**算法去cache_t中定位bucket_t，然后获取IMP具体实现，从而调用函数
 
 
 #### 5、class_data_bits_t
 
 ![IMG_3925](IMG_3925.PNG)

  rw: read write   ro: only read

 
 #### 6、class_rw_t
 
 ![IMG_3926](IMG_3926.PNG)

 * class_rw_o:  系统类的内容（所以只读）
 * protocols、properties、methods：存储分类的内容
 * list_array_tt：因为包含多个分类的内容（所以可读写），每一个分类是一个数组，所以是二维数组

 #### 7、class_rw_o
 
 ![IMG_3927](IMG_3927.PNG)

 #### 8、method_t
 
 ![IMG_3929.PNG](IMG_3929.PNG)
 
 ![IMG_3930](IMG_3930.PNG)
 
 * types是返回值和入参的结合体。
 * - (void)aMethod;  最终转化成  objc_msgSend(void * id self, SEL op, ... )的形式，所以它的types = v@:
 
 ![IMG_3931](IMG_3931.PNG)
 
  #### 9、对象、类对象、元类对象
 
 * 类对象存储实例方法列表等信息。
 * 元类对象存储类方法列表等信息。
 
 
>* **元类对象的isa指针都指向根元类对象，并且根元类对象的superclass指向根类对象**
>* **调用类方法过程中，如果在元类对象中都查找不到，它会查找根类对象中同名的实例方法**
 
 
  #### 10、消息传递
 
 * [self class] 消息接收者是self（当前对象）->  objc_msgSend(void * id self, SEL op, ... )
 * [super class] 消息接收者还是是self（当前对象），但是调用的是父类的方法  -> objc_msgSendSuper(void * id self, SEL op, ... )

 ![IMG_3932](IMG_3932.PNG)
 
  **缓存查找**
 
 * 哈希查找
 
  ![IMG_3934](IMG_3934.PNG)
 
  **当前类中查找**

 * 对于已排序号的列表，采用二分查找算法查找方法对应执行函数
 * 对于没有排序的列表，采用一般遍历查找方法对应执行函数

  **父类逐级中查找**
 
  ![IMG_3933](IMG_3933.PNG)
 
   #### 11、消息转发

  ![IMG_3935](IMG_3935.PNG)
 
 * 1、+ (BOOL)resolveInstanceMethod:(SEL)sel           可动态添加方法实现
 * 2、- (id)forwardingTargetForSelector:(SEL)aSelector       转发消息给其他类处理
 * 3、- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector   函数签名（返回 的NSMethodSignature是对返回值类型、参数的封装  == cosnt char *types）
 * 3.1、 - (void)forwardInvocation:(NSInvocation *)anInvocation  实现函数
 
  **Method-Swizzling**

  ![IMG_3936](IMG_3936.PNG)
    
 > cls：类对象    name：方法选择器  返回：Method
 * class_getInstanceMethod(Class  _Nullable __unsafe_unretained cls, SEL  _Nonnull name)
 * method_exchangeImplementations(Method  _Nonnull m1, Method  _Nonnull m2)   交换两个方法的实现（IMP）
 
   **动态添加方法**
 
 * performSelector:     可调用动态添加的方法
 >  cls: 类对象    name：方法选择器（方法名）imp：函数的实现    types：返回类型和入参   eg：v@:
 * class_addMethod(Class  _Nullable __unsafe_unretained cls, SEL  _Nonnull name, IMP  _Nonnull imp, const char * _Nullable types)
 
  **动态方法解析**

 ![IMG_3937](IMG_3937.PNG)
 
 * 声明属性**@dynamic**    代表set、get的具体实现是在运行时添加，而不是编译时


   #### 12、实战
    
 * [objc foo]和objc_msgSend()函数之间的关系
    * [objc foo]在编译器处理过后就会变成objc_msgSend()的形式
 * Runtime如何通过Seletor找到对应的IMP地址
    * 消息传递的知识点
 * 能否向**编译后的类**中增加实例变量？
    * 不能，因为编译之前，定义/创建的类已经完成实例变量的布局,也就是class_ro_t,所以编译后的类是无法修改的。
 * 能否向**动态添加的类**中增加实例变量？
    * 能，因为在动态添加类的过程中，只要在调用注册类方法调用之前，完成实例变量的添加是可以实现的。
 
   **其他应用**
 * 关联对象，添加实例变量
 * 遍历类的所有成员变量（也就是class_ro_t中的ivars），也就是字典转模型的原理

*/
