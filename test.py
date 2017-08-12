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
#e for set {}创建缺省为dict 
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
test_2 = [1 _ in test_1]
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
#随机数种子 自动重置

#范围内随机数 
ra.randrange(1,5)

#随机重排列表
lis = [1,3,5,2,5]
ra.shuffle(lis)

#随机选取一个元素(放回)
ra.choice(lis)

#随机选取一个元素(无放回)
ra.sample(lis , 3)