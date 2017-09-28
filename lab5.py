import time
import datetime

from protorpc import messages
from protorpc import message_types
from protorpc import remote

import lab2

default_limit=10

class Say(messages.Message):
	say=messages.StringField(1)
	
class Book_view(messages.Message):
	book_id=messages.IntegerField(1)
	book_name=messages.StringField(2)
	book_author=messages.StringField(3)
	book_date=messages.IntegerField(4)
	book_add_date=messages.IntegerField(5)
	
class Book_ent(messages.Message):
	book_name=messages.StringField(1)
	book_author=messages.StringField(2)
	book_date=messages.IntegerField(3)
	
class Book_id(messages.Message):
	id_b=messages.IntegerField(1,required=True)
 
class List_books(messages.Message):
	global default_limit
	limit=messages.IntegerField(1, default=default_limit)
	class Sort_by(messages.Enum):
		ID=0
		NAME=1
		AUTHOR=2
		DATE_B=3
		DATE_B_ADD=4
	sort_opt=messages.EnumField(Sort_by,2,default=Sort_by.ID)
	
class Books(messages.Message):
	books_list=messages.MessageField(Book_view,1,repeated=True)

class Message_Services(remote.Service):
	@remote.method(message_types.VoidMessage,Say)
	def say_hello(self,request):
		if request:
			return 	Say(say="well, hi")
		'''else:
			return Say(say="hello");'''
	@remote.method(List_books,Books)
	def get_books(self,request):
		query=lab2.Model.all().ancestor(lab2.lib_key(lab2.username))
		'''query.order('id_b')
		tst_books=query.fetch(10)
		for tst_book in tst_books:
			print 'book.id_b={}'.format(tst_book.id_b)'''
		global default_limit
		limit=default_limit
		if request.limit:
			limit=request.limit
		if request.sort_opt:
			if request.sort_opt==List_books.Sort_by.ID:
				query.order('id_b')
			elif request.sort_opt==List_books.Sort_by.NAME:
				query.order('name_b')
			elif request.sort_opt==List_books.Sort_by.AUTHOR:
				query.order('author_b')
			elif request.sort_opt==List_books.Sort_by.DATE_B:
				query.order('date_b')
			else: #request.sort_opt==List_books.Sort_by.DATE_B_ADD;
				query.order('date_b_add')
		books_list=[]
		for fnd_book in query.fetch(limit):
			if fnd_book.date_b:
				tmp_date=int(time.mktime(fnd_book.date_b.utctimetuple()))
			else:
				tmp_date=None
			if fnd_book.date_b_add:
				tmp_date_add=int(time.mktime(fnd_book.date_b_add.utctimetuple()))
			else:
				tmp_date_add=None
			book_ent=Book_view(
				book_id=fnd_book.id_b, book_name=fnd_book.name_b,book_author=fnd_book.author_b,book_date=tmp_date,book_add_date=tmp_date_add)
			books_list.append(book_ent)
		return Books(books_list=books_list)
	@remote.method(Book_ent,message_types.VoidMessage)
	def add_book(self,request):
		'''global lab2.books_num'''
		print 'blab2.books_num={}'.format(lab2.books_num)
		print 'lab2.username={}'.format(lab2.username)
		n_book = lab2.Model(parent=lab2.lib_key(lab2.username))
		n_book.id_b=lab2.books_num
		if request.book_name is not None:
			n_book.name_b=request.book_name
		if request.book_author is not None:
			n_book.author_b=request.book_author
		if request.book_date is not None:
			n_book.date_b=request.book_date
		if n_book.name_b or n_book.author_b:
			global default_limit
			query=lab2.Model.all().ancestor(lab2.lib_key(lab2.username))
			tmp_books = query.fetch(default_limit)
			tmp_id=0
			for c_book in tmp_books:
				if tmp_id<c_book.id_b:
					tmp_id=c_book.id_b
			lab2.books_num=tmp_id
			print 'alab2.books_num={}'.format(lab2.books_num)
			lab2.books_num+=1
			n_book.id_b=lab2.books_num
			n_book.date_b_add=datetime.datetime.now()
			n_book.put()
		else:
			print 'q\nq\n'
		return message_types.VoidMessage()
	@remote.method(Book_id,message_types.VoidMessage)
	def del_book(self,request):
		global default_limit
		books_query = lab2.Model.all().ancestor(lab2.lib_key(lab2.username)).order('id_b')
		tmp_books = books_query.fetch(default_limit)
		tmp_id=0
		for c_book in tmp_books:
			if tmp_id<c_book.id_b:
				tmp_id=c_book.id_b
			lab2.books_num=tmp_id
		if request.id_b>=1 and request.id_b<=lab2.books_num:
			books_query.filter('id_b =',request.id_b)
			books_query.get().delete()
		return message_types.VoidMessage()
        
        
        
        
