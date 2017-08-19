########################################
#e for deafaultict 依靠元组生成字典
########################################
from collections import defaultdict
document = ('dasd','asd2qwd','asdasd','dasd','asd2qwd')
word_counts = defaultdict(int)
for word in document:
	word_counts[word] += 1
word_counts

########################################
#e for Counter 依靠元组生成字典
########################################
from collections import Counter
document = ('dasd','asd2qwd','asdasd','dasd','asd2qwd')
word_counts = Counter(document)

########################################
#集合 e for set {}创建缺省为dict 
########################################
ex = set()
ex.add(1)

########################################
#排序 sort()方法更新list
#     sorted()函数产生新list
########################################
test_1 = [1,7,5,2,6]
test_2 = (1,7,5,2,6)
test_1.sort(reverse = True)
test_3 = sorted(test_2 , key = abs , reverse = True)

########################################
#列表解析
########################################
test_1 = [s for s in range(10) if s < 5]
test_2 = [1 for _ in test_1]
test_3 = [(x,y) for x in range(3) for y in range(2)]

########################################
#生成器
########################################
def lazy_range(n):
	i = 0
	while i < n:
		yield i 
		i += 1

lis = []
for x in lazy_range(10):
	lis.append(x)

#只能用一次
lazy_range_10 = lazy_range(10)

#列表解析生成非连续生成器
lazy_range_10 = (i for i in lazy_range(20) if i % 2 == 0)

for x in lazy_range_10:
	lis.append(x)

########################################
#随机性
########################################

import random as ra

#随机数种子 结果可复生 作用于所有random随机方法
ra.seed(10)
ra.random()

#随机数种子自动重置

#范围内随机数 
ra.randrange(1,5)

#随机重排列表
lis = [1,3,5,2,5]
ra.shuffle(lis)

#随机选取一个元素(放回)
ra.choice(lis)

#随机选取一个元素(无放回)
ra.sample(lis , 3)

########################################
#面向对象 class
########################################

class Set():
	"""
	成员函数
	每个函数都取第一个参数"self"
	表示所用到的特别的集合对象
	"""
	def __init__(self , values = None):
		#私有属性
		self.__dict = {}
		if values is not None:
			for value in values:
				self.add(value)

	def add( self , value ):
		self.__dict[value] = True 

	def contains( self , value ):
		return value in self.__dict

	def remove( self , value ):
		del self.__dict[value]
s =Set([1,2,3])
s.add(4)
print (s.contains(4))
s.remove(3)
print (s.contains(3))

########################################
#函数式工具
########################################

# 1 def

def exp_( base , power ):
	return base ** power

# 2 functools.partial

from functools import partial

#默认填充第一个参数
#仅当需要填充后面参数时才可指定参数名称

exp_power_2 = partial(exp_ , power = 2 ) # num ** 2
exp_base_2 = partial(exp_ ,  2 )  # 2 ** num

print (exp_power_2(3))

print (exp_base_2(3))

#3 map 对list使用函数 
#2.x中返回独立list 3.x中为生成器，按需生成

data = [1 , 2 , 3 , 4]
exp_lis = [exp_base_2(x) for x in data]
exp_lis_2 = map( exp_base_2 , data )
li = []

for x in exp_lis_2:
	li.append(x)

lis_exp = partial(map , exp_base_2)
exp_lis_3 = lis_exp(data)

print(exp_lis_2 == exp_lis)

print(li)

#4 filter 对于list中的值 返回函数值为True的值
#2.x中返回独立list 3.x中为生成器，按需生成

print(filter(exp_base_2 , data) == [x for x in data if exp_base_2(x)]) 

for x in filter(exp_base_2 , data):
	li.append(x)

print(li)

#5 reduce python3.x已删除该内建函数

########################################
#枚举 enumerate 
#产生(index , element)元组
########################################

'''
for i , document in enumerate(documents , start = 0):
	do_st(i , document)

for i , _ in enumerate(documents) : do_st(i)
'''

########################################
#压缩和参数拆分
########################################

#1 zip(list1 , list2)
#将两个list对应元素组合 
#list长度为短对齐
#2.x中返回独立list 3.x中为生成器，按需生成
list1 = [1,2,3]
list2 = ['q','w','e']
print(zip(list1,list2))

for x in zip(list1,list2):
	li.append(x)

print(li)

#2 拆分 * 多参数传递？
a = [*(1,2)]
print(a)

########################################
#args 未知tuple 
#以*args传入 传入后组合为tuple
#kwargs 未知dict 
#以**kwargs传入 传入后组合为dict
########################################
def magic(*args,**kwargs):
	print(args)
	print(kwargs)

magic(2,1,key = '1' , key2 = '2')

def adds(x,y,z):
	return x+y+z 
x_y = [1,2]
z = {"z":3}
print(adds(*x_y,**z))

def f(x,y,z):
	return x+y+z

def double_correct(f):
	def g(*args , **kwargs):
		return 2 * f(*args , **kwargs)
	return g
z = {"z" : 3}
g = double_correct(f)
print (g(1,2,3))

