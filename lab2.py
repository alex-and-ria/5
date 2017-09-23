import cgi
import datetime
import urllib
import wsgiref.handlers

from datetime import datetime

from google.appengine.ext import db
from google.appengine.api import users
import webapp2

import os
from google.appengine.ext.webapp import template

books_num=0
username='anonymous'
edit_i=-1
delete_i=-1
edited=False
editing=False
deleted=False
edited_name_b=''
edited_author_b=''
edited_date_b=u''

def inc_globvar():
    global books_num    # Needed to modify global copy of globvar
    books_num +=1

class Model(db.Model):
  """Models an individual entry with fields"""
  id_b=db.IntegerProperty()
  name_b=db.StringProperty(multiline=True)
  author_b = db.StringProperty(multiline=True)
  date_b=db.DateTimeProperty()
  date_b_add=db.DateTimeProperty(auto_now_add=True)
  
def lib_key(user_name=None):
  """Constructs a datastore key for a Lib entity with user_name"""
  return db.Key.from_path('Lib', user_name)

class MainPage(webapp2.RequestHandler):
    def get(self):
    	global username
    	global books_num
    	global edit_i
    	global delete_i
    	global edited
    	global editing
    	global deleted
    	global edited_name_b
    	global edited_author_b
    	global edited_date_b
        if users.get_current_user():
            url = users.create_logout_url(self.request.uri)
            url_linktext = 'Logout'
            user=users.get_current_user().nickname()
            username=user
        else:
            url = users.create_login_url(self.request.uri)
            url_linktext = 'Login'
            user='anonymous'
            username=user
        
        books_query = Model.all().ancestor(
            lib_key(username)).order('id_b')
        books = books_query.fetch(10)
        
        tmp_id=0
        for c_book in books:
        	if tmp_id<c_book.id_b:
        		tmp_id=c_book.id_b
        books_num=tmp_id
        
        auto_redirect=False
        if edited==True:
        	books_query.filter('id_b =',edit_i)
        	book_u_e=books_query.get()
        	'''for edited_book_ent in books_query:
        		print edited_book_ent.name_b'''
        	if book_u_e.name_b!=edited_name_b:
        		book_u_e.name_b=edited_name_b
        	if book_u_e.author_b!=edited_author_b:
        		book_u_e.author_b=edited_author_b
        	if edited_date_b!=u'':
        		print 'edited_date_b={}'.format(edited_date_b)
        		book_u_e.date_b=datetime.strptime(edited_date_b, "%Y-%m-%d")
        	print '1edited_name_b={}'.format(edited_date_b)
        	edited_name_b=''
        	edited_author_b=''
        	edited_date_b=u''
        	edited=False
        	auto_redirect=True
        	edit_i=-1
        	book_u_e.put()
        	
        if deleted==True:
        	books_query.filter('id_b =',delete_i)
        	books_query.get().delete()
        	deleted=False
        	delete_i=-1
        	auto_redirect=True
        	
        unicode_date=u''
        if editing==True:
        	books_query.filter('id_b =',edit_i)
        	unicode_date=unicode(books_query.get().date_b)
        	print 'unicode_date={} (type()={})'.format(unicode_date,type(unicode_date))
        	editing=False
        
        template_values = {
        	'user': user,
            'url': url,
            'url_linktext': url_linktext,
            'books': books,
            'unicode_date': unicode_date[0:10],
            'edit_i': edit_i
        }        
        path = os.path.join(os.path.dirname(__file__), 'index.html')
        self.response.out.write(template.render(path, template_values))
        if auto_redirect:
        	self.redirect('/')
        
class Add_book(webapp2.RequestHandler):
	def post(self):
		global books_num
		inc_globvar()
		n_book = Model(parent=lib_key(username))
		n_book.id_b=books_num
		n_book.name_b=self.request.get('n_book_name')
		n_book.author_b=self.request.get('n_book_author')
		if self.request.get('n_book_date'):
			n_book.date_b=datetime.strptime(self.request.get('n_book_date'), "%Y-%m-%d")
		print 'type(n_book_date={}), type(n_book.date_b)={}'.format(type(self.request.get('n_book_date')),type(n_book.date_b))
		if n_book.name_b or n_book.author_b:
			n_book.put()
		else:
			books_num-=1
		self.redirect('/')

class Edit_book(webapp2.RequestHandler):
	def post(self):
		global books_num
		global edit_i
		global editing
		'''print 'edit_i={},type={}'.format(edit_i,type(edit_i))'''
		edit_i=int(self.request.get('e_index'))
		'''print 'edit_i={},type={}'.format(edit_i,type(edit_i))'''
		if edit_i>=1 and edit_i<=books_num:
			editing=True
		else:
			editing=False
			edit_i=-1
		self.redirect('/')
		
class Edit_ok(webapp2.RequestHandler):
	def post(self):
		global edited
		global edited_name_b
		global edited_author_b
		global edited_date_b
		edited_name_b=self.request.get('u_book_name')
		edited_author_b=self.request.get('u_book_author')
		edited_date_b=self.request.get('u_book_date')
		edited=True
		print 'q:{} {} {}'.format(edited_name_b,edited_author_b,edited_date_b)
		if edited_date_b==u'':
			print 'unicode '
		self.redirect('/')
		
class Delete_book(webapp2.RequestHandler):
	def post(self):
		global books_num
		global delete_i
		global deleted
		delete_i=int(self.request.get('d_index'))
		if delete_i>=1 and delete_i<=books_num:
			deleted=True
		else:
			deleted=False
			delete_i=-1
		self.redirect('/')
		
        
app = webapp2.WSGIApplication([
  ('/', MainPage),
  ('/add_book', Add_book),
  ('/edit_book',Edit_book),
  ('/edit_ok',Edit_ok),
  ('/delete_book',Delete_book)
], debug=True)
