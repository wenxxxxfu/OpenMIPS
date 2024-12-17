## 指令简介
MIPS指令集架构中定义6条移动操作指令：**movn、movz、mfhi、mthi、mflo、mtlo**

后4条指令涉及对特殊寄存器HI、LO的读写操作

HI、LO寄存器用于保存乘法、除法结果

6条移动操作指令格式:
![image](https://github.com/zach0zhang/Single_instruction_cycle_OpenMIPS/blob/master/move/md_images/res_move.png)
由指令格式可以看出指令码都是6'b000000(bit26\~31)，由功能码(0\~5bit)判断是哪个指令,并且指令6~10bit都是0
- **movn**(功能码是6'b001011):用法：movn rd, rs, rt；作用：if rt != 0 then rd <- rs(如果rt通用寄存器里的值不为0，则将地址为rs的通用寄存器的值赋值给地址为rd的通用寄存器)
- **movz**(功能码是6'b001010):用法：movn rd, rs, rt；作用：if rt == 0 then rd <- rs(如果rt通用寄存器里的值为0，则将地址为rs的通用寄存器的值赋值给地址为rd的通用寄存器)
- **mfhi**(功能码是6'b010010):用法：mflo rd 作用：rd <- lo将特殊寄存器HI的值赋给地址为rd的通用寄存器
- **mflo**(功能码是6'b010000)：用法 mflo rd 作用：rd <- lo将特殊寄存器LO的值赋给地址为rd的通用寄存器
- **mthi**(功能码是6‘b010001):用法：mthi rs 作用：hi <- rs将地址为rs的通用寄存器的值赋给特殊寄存器HI
- **mtlo**(功能码是6'b010011):用法：mtlo rs 作用：lo <- rs,将地址为rs的通用寄存器的值赋给特殊寄存器LO
## 修改系统结构
对之前的结构进行改变
1. 增加HILO模块，实现HI、LO寄存器
2. 增加执行模块EX的输入接口，接收从HILO模块传来的HI、LO寄存器的值；输出到WB模块是否要写HILO、写入HI寄存器的值、写入LO寄存器的值
3. 增加回写模块WB的输入输出接口
![image](https://github.com/zach0zhang/Single_instruction_cycle_OpenMIPS/blob/master/move/md_images/move_struct.png)