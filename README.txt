error_log
    by Kacper Ciesla (omboy)   

== DESCRIPTION:

Easy way to track exceptions and warnings in your rails app

It's still just a skeleton.
More description and documentation will come.. one day.. I guess.

THIS IS AN EARLY DEVELOPMENT VERSION, DO NOT EVEN TOUCH PRODUCTION SERVER WITH IT.
Actually, it is so unmature that even playing with it can make you sad.
And no one likes to be sad.

dev screenshot: http://tesuji.pl/error_logs.png

== REQUIREMENTS

I hope it to work with rails 2.x and 3, currently I'm testing it only on rails 3.

== INSTALATION AND USAGE

Just put

  gem 'error_log'

in your Gemfile. By default it will use your database to store error logs.
Automagically table error_logs is going to be created, and all unhandled
controller exceptions will end up there by default (displaying your 500 page
as normal).

Generate yourself some empty controller (say error_logs) and put this line 
inside:

  error_logs

You can use it now to browse exceptions. It is your responsibility to make this
controller secure and unaccessible by others.

There's also one global method catch_error that you can use to.. catch errors.

  catch_error do
     # some stuff that may cause problems
  end

or
  
  catch_error('page parsing', :level => :fatal) do
    raise "tangled cables"
  end

To be continued.

== TODOS

* better params viewing (currently only example params)
* setting error level threshold while browsing
* nicer browsing (themes would be good, but I really do not like css so help needed)
* adding errors to ignore list
* alternative errors storage (for database failures, maybe just some sqlite?)
* clickable backtraces? we could show some code
* rails 2.x compatibility
* marking single errors as read, browsing archive
* bugfixes, lots of

== STUFF

Ideas, opinions and contributions are extrememly welcome.

== LICENSE:

(The MIT License)

Copyright (c) 2010 Kacper Ciesla

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
