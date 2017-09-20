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
  return db.Key.from_path('Lib', user_name or 'anonymous')

class MainPage(webapp2.RequestHandler):
    def get(self):
        if users.get_current_user():
            url = users.create_logout_url(self.request.uri)
            url_linktext = 'Logout'
            user=users.get_current_user().nickname()
            global username
            username=user
        else:
            url = users.create_login_url(self.request.uri)
            url_linktext = 'Login'
            user='anonymous'
            global username
            username=user
        
        books_query = Model.all().ancestor(
            lib_key(username)).order('id_b')
        books = books_query.fetch(10)
        global books_num
        tmp_id=0
        for c_book in books:
        	if tmp_id<c_book.id_b:
        		tmp_id=c_book.id_b
        books_num=tmp_id        	
        
        template_values = {
        	'user': user,
            'url': url,
            'url_linktext': url_linktext,
            'books': books
        }        
        path = os.path.join(os.path.dirname(__file__), 'index.html')
        self.response.out.write(template.render(path, template_values))
        
class Add_book(webapp2.RequestHandler):
	def post(self):
		global books_num
		inc_globvar()
		n_book = Model(parent=lib_key(username))
		n_book.id_b=books_num
		n_book.name_b=self.request.get('n_book_name')
		n_book.author_b=self.request.get('n_book_author')
		n_book.date_b=datetime.strptime(self.request.get('n_book_date'), "%Y-%m-%d")
		n_book.put()
		self.redirect('/')
        
app = webapp2.WSGIApplication([
  ('/', MainPage),
  ('/add_book', Add_book)
], debug=True)
