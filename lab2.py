#!/usr/bin/env python
from pyspark import SparkContext, SparkConf
conf = SparkConf().setAppName("lab2.py")
sc = SparkContext(conf=conf)

d=0.85
strt_pr=(1-d) #d=0.85 => strt_pr=(1-d)=(1-0.85)=0.15;
bc_strt_pr=sc.broadcast(strt_pr)

N=1
bc_N=sc.broadcast(N)

def fmparser(line):
	n_links=len(line.split())-1# 1st word is a page name
	line+=' '+str(bc_strt_pr.value)+' '+str(n_links)
	return [line]
	
def fmparser1(line):
	n_links=len(line.split())-1# 1st word is a page name
	cr=0.; i=0;
	with open("../lab2/outp_f.txt","rb") as fin:
		for fline in fin:
			for fword in fline.split():
				#print "fword=%s, i=%d" % (fword, i)
				if(fword == (line.split())[0]): #find fword whuch name in given page name;
					cr=float((fline.split())[i+1])
					break;
				i+=1;
	fin.close()
	line+=' '+str(cr)+' '+str(n_links)
	return [line]
	
def fmpremap(line):
	arr=line.split()
	ret_line='';
	for word in arr:
		if(word!=arr[0] and word!=arr[len(arr)-2] and word!=arr[len(arr)-1]):#skip self links and numbers
			ret_line+=word+'\t'+arr[len(arr)-2]+' '+arr[len(arr)-1]+'___'
	#print 'len(ret_line=%d)' % len(ret_line)
	ret_line=ret_line[0:len(ret_line)-3] # deleting '___' separator in the end of line;
	return ret_line.split('___')
	
def msep_keyes(line):
	l2map=line.split('\t')
	with open("../lab2/outp_f.txt","wb") as fout:# erasing file's content to put new values in it;
		pass
	fout.close()
	return [l2map[0], l2map[1]]
	
def mcalc(inp_tuple):
	page=inp_tuple[0]
	arr_nums=inp_tuple[1].split()
	i=0; tot=0.;
	for num in arr_nums:
		if not (i%2):
			tot+=(float(arr_nums[i]))/(float(arr_nums[i+1]))
			#print 'tot=%f, float(arr_nums[%d])=%f, float(arr_nums[%d])=%f' % (tot,i,float(arr_nums[i]),(i+1),float(arr_nums[i+1]))
		i=i+1		
	tot=tot*(1-bc_strt_pr.value) + bc_strt_pr.value
	with open("../lab2/outp_f.txt","a+b") as fout:
		fout.write(str(page)+' '+str(tot)+' ')
	fout.close()
	return [page, tot]
	
rdd=sc.textFile("../lab2/input.txt").flatMap(fmparser).flatMap(fmpremap).map(msep_keyes).reduceByKey(lambda a,b: str(a)+' '+str(b)).map(mcalc)
rdd.collect()

for itr in range(N):
	rdd=sc.textFile("../lab2/input.txt").flatMap(fmparser1).flatMap(fmpremap).map(msep_keyes).reduceByKey(lambda a,b: str(a)+' '+str(b)).map(mcalc)
	
rdd=sc.textFile("../lab2/input.txt").flatMap(fmparser1).flatMap(fmpremap).map(msep_keyes).reduceByKey(lambda a,b: str(a)+' '+str(b)).map(mcalc)
rdd.collect()
