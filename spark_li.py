from pyspark import SparkContext, SparkConf
conf = SparkConf().setAppName("sparc_li.py")
sc = SparkContext(conf=conf)

def fmapper(pair):
	f, text = pair
	f = f[len(f)-5:]
	offset=0
	outstr=''
	for lines in text.splitlines():
		for word in lines.split():
			outstr+=word+'\t'+f+'@'+str(offset)+'___'
			offset+=len(word)+1 #1 for space character;
	return outstr.split('___')
	
def mmaper(llist):
	l2map=llist.split('\t')
	word=l2map[0]
	entry=l2map[-1]
	#print 'word=%s, entry=%s' % (word,entry)
	return [word,entry]
	

rdd = sc.wholeTextFiles("../lab1/input").flatMap(fmapper).map(mmaper).reduceByKey(lambda a, b: str(a) +', '+str(b))
rdd.collect()
