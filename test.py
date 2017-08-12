########################################
#e for deafaultict
########################################
from collections import defaultdict
document = ('dasd','asd2qwd','asdasd','dasd','asd2qwd')
word_counts = defaultdict(int)
for word in document:
	word_counts[word] += 1
word_counts

########################################
#e for Counter
########################################
from collections import Counter
document = ('dasd','asd2qwd','asdasd','dasd','asd2qwd')
word_counts = Counter(document)
