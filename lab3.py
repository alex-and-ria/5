from pyspark import SparkContext, SparkConf
conf = SparkConf().setAppName("lab3.py")
sc = SparkContext(conf=conf)

def get_lines_ff(pair):
	f,text=pair;
	rt=f[len(f)-3:]; cnt=0
	print 'filename=%s; rt==%s' % (f, rt)
	n_text='';
	for lines in text.splitlines():
		if rt=='RT1':
			n_text+=lines[5:15]+' '#get TIGER/Line ID;
			if lines[19:49].replace(' ',''):
				if cnt<10:
					print 'not empty name: %s %s' % (lines[5:15], lines[19:49])
					cnt+=1
				n_text+=lines[19:49]+' '#get Feature Name;
			n_text+=lines[190:200]+' '#get Start Longitude;
			n_text+=lines[200:209]+' '#get Start Latitude;
			n_text+=lines[209:219]+' '#get End Longitude;
			n_text+=lines[219:228]+' '#get End Latitude;
		else:
			n_text+=lines[5:15]+' '#get TIGER/Line ID;
			#n_text+=lines[15:18]+' '#get Record Sequence Number;
			i=18; lgtd=True
			while i<209:
				if lgtd:
					if lines[i+1:i+10].replace('0',''):
						if cnt<10:
							print 'not empty point lgtd: %s %s' % (lines[6:15], lines[i:i+10])
							cnt+=1
						n_text+=lines[i:i+10]+' '#get Point Longitude;
					i+=10;
				else:
					if lines[i+1:i+9].replace('0',''):
						if cnt<10:
							print 'not empty point lgtd: %s %s' % (lines[6:15], lines[i:i+9])
							cnt+=1
						n_text+=lines[i:i+9]+' '#get Point Latitude;
					i+=9;
				lgtd=not(lgtd)
		n_text=n_text[:len(n_text)-1]#deleting ending ' ' symbol;
		n_text+=rt+'@';
	cnt=0; print '\n\n'
	return [n_text];
	
def group_f(x,y):
	if x==None or y==None:
		print 'none'
		return
	ret=''
	if x[len(x)-3:len(x)]=='RT2':
		if y[len(y)-3:len(y)]=='RT2':
			x=x[:len(x)-3]#clear 'RT2' string;
			ret=x+y#+' x=rt2; y=rt2'
		elif y[len(y)-3:len(y)]=='RT1':
			y=y[:len(y)-3]
			x=x[:len(x)-3]+'RT1'#+' x=rt2, y=rt1'
			ret=y+x#append rt2 in the end of rt1
		else:
			print '\nx=RT2; y=?\n'
	elif x[len(x)-3:len(x)]=='RT1':
		if y[len(y)-3:len(y)]=='RT2':
			x=x[:len(x)-3]
			y=y[:len(y)-3]+'RT1'
			ret=x+y#+' x=rt1, y=rt2'
		elif y[len(y)-3:len(y)]=='RT1':
			print '\n\nwarning\n\n'
		else:
			print '\nx=RT1; y=?\n'
	else:
		print '\nx=?; y=?\n'
		print(x)
		print(y)
		return
	#print 'ret=',x,y,ret,'\n'
	return ret
	
def ptf(inp_tuple):
	lid=inp_tuple[0]
	l_data=inp_tuple[1]
	is_str=False
	if l_data==None:
		print 'l_data==None'
		return
	print 'inp'+l_data+'\n'
	if l_data[len(l_data)-3:len(l_data)]=='RT2':
		print 'ptf: warning l_data=%s' % l_data
		return
	print 'l_data(:11)=%s' % l_data[:11]
	try:
		float(l_data[:11])
	except ValueError:
		is_str=True
	with open("../lab3/outp_f.txt","ab") as fout:
		if is_str:
			fout.write(l_data[1:len(l_data)]+'\n')
		else:
			i=0; spl=''
			while i<30:
				spl+=' '
				i+=1
			fout.write(spl+l_data[0:len(l_data)]+'\n')
	fout.close()		
	return inp_tuple

rdd = sc.wholeTextFiles("../lab3/input").flatMap(get_lines_ff).flatMap(lambda a: a.split('@')).flatMap(lambda elem: [(elem[:10],elem[10:])]).reduceByKey(group_f).map(ptf); rdd.collect()
rdd.take(10)
rdd.collect()
