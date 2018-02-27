
# the_comics_test

 - ruby 2.4.3p205 (2017-12-14 revision 61247)
 - sinatra (1.4.8)

**How to start**

 - git clone https://github.com/guilycruz/the_comics_test.git
 - run bundle install
 - open a cmd which runs ruby
 - open the file config.yml and
	 - replace the values *public_key* and *private_key* with your on credentials from Marvel API (https://developer.marvel.com/account)
 - go to the project root folder
 - run ruby app.rb
 - the server is going to start running commonly in the port *4567* (http://localhost:4567/)

**Navigating through the system**
 - access http://localhost:4567/characters from your browser to display the list of the thirty characters available. It is also possible to inform a *page* as parameter to list a different set of characters (e.g. http://localhost:4567/characters?page=25). The last page is number *49*.
 - access http://localhost:4567/characters/<character_name> from your browser to access the page with the chosen character details (e.g. http://localhost:4567/characters/hulk)
