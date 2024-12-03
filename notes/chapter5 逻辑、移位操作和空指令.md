## 指令介绍
### 1. 逻辑操作
#### 1.1 and、or、xor、nor
**and、or、xor、nor的指令格式：**
![image](https://github.com/zach0zhang/Single_instruction_cycle_OpenMIPS/blob/master/logic_shift_nop/md_images/and_or_xor_nor.png)
这4条指令，指令码都是6'b000000，第6~10bit都为0，需要功能码(0\~5bit)的值进一步判断是哪一种指令

1. and指令，功能码是6'b100100，逻辑“与”运算。
    
    指令用法：and rd, rs,rt (rd <- rs AND rt)
2. or指令，功能码是6'b100101，逻辑“或”运算。

    指令用法：or rd, rs,rt (rd <- rs OR rt)
3. xor指令，功能码是6'b100110，异或运算。

    指令用法：xor rd, rs,rt (rd <- rs XOR rt)
4. nor指令，功能码是6'b100111，或非运算。

    指令用法：nor rd, rs,rt (rd <- rs NOR rt)
#### 1.2 andi xori
**andi、xori的指令格式：**
![image](https://github.com/zach0zhang/Single_instruction_cycle_OpenMIPS/blob/master/logic_shift_nop/md_images/andi_xori.png)
这两条指令，通过指令码(26~31bit)判断是哪一种指令
1. andi指令，指令码是6'b001100,逻辑“与”运算。
    
    指令用法：andi rt, rs,imm ( rt <- rs AND zero_extended(imm) )
2. xori指令，指令码是6'b01110,逻辑“异或”运算

    指令用法：xori rt, rs,imm ( rt <- rs XORI zero_extended(imm) )
#### 1.3 lui
**lui的指令格式：**
![image](https://github.com/zach0zhang/Single_instruction_cycle_OpenMIPS/blob/master/logic_shift_nop/md_images/lui.png)
通过指令码(26~31bit)是6b001111判断

指令用法：lui rt,imm ( rt <- imm || 0^16 , 即将指令中的16bit立即数保存到地址为rt的通用寄存器的高16位，低16位用0填充) 

### 2. 移位操作
**sll、sllv、sra、srav、srl、srlv的指令格式：**
![image](https://github.com/zach0zhang/Single_instruction_cycle_OpenMIPS/blob/master/logic_shift_nop/md_images/sll_srl_sra_sllv_srlv_srav.png)
这6条指令指令码(26~31bit)都是6'b000000，需要根据指令的功能码(0\~5bit)进一步判断是哪一条指令
1.  sll指令，功能码是6'b000000,逻辑左移

    指令用法：sll rd,rt,sa ( rd <- rt << sa(logic) rt的值向左移位sa位，空出来的位置用0填充，结果保存到地址为rd的通用寄存器中)
2. srl指令，功能码是6'b000010,逻辑右移

    指令用法：srl rd,rt,sa ( rd <- rt >> sa(logic) rt的值向右移位sa位，空出来的位置用0填充，结果保存到地址为rd的通用寄存器中)
3. sra指令，功能码是6'b000011,算术右移

    指令用法：sra rd,rt,sa ( rd <- rt >> sa(arithmetic) rt的值向右移位sa位，空出来的位置用rt[31]的值填充，结果保存到地址为rd的通用寄存器中)
4. sllv指令，功能码是6'b000100，逻辑左移

    指令用法：sllv rd,rt,rs ( rd <- rt << rs\[4:0](logic) rt的值向左移位rs[4:0]位，空出来的位置用0填充，结果保存到地址为rd的通用寄存器中)
5. srlv指令，功能码是6'b000110，逻辑右移

    指令用法：srlv rd,rt,rs ( rd <- rt >> rs\[4:0](logic) rt的值向右移位rs[4:0]位，空出来的位置用0填充，结果保存到地址为rd的通用寄存器中)
6. srav指令，功能码是6'b000111,算术右移

    指令用法：srav rd,rt,rs ( rd <- rt >> rs\[4:0](arithmetic) rt的值向右移位rs[4:0]位，空出来的位置用rt[31]填充，结果保存到地址为rd的通用寄存器中)
### 3. 空指令
**nop、ssnop、sync和pref的指令格式：**
![image](https://github.com/zach0zhang/Single_instruction_cycle_OpenMIPS/blob/master/logic_shift_nop/md_images/nop_ssnop_sync_pref.png)

## 实现逻辑、移位操作和空指令
### 1. 修改译码阶段的ID模块
根据8条逻辑操作指令、6条位操作、4条空指令的指令格式，判断相应的指令码和功能码来确定是什么指令，并执行每一个指令的译码操作

**确定指令种类的过程：**
![image](https://github.com/zach0zhang/Single_instruction_cycle_OpenMIPS/blob/master/logic_shift_nop/md_images/select.png)