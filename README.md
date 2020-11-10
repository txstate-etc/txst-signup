
Texas State Signup
==================

This is [Texas State University's](http://txstate.edu) instance of the 
[Signup Reservation System](https://github.com/txstate-etc/txst-signup).

See it live at http://signup.txstate.edu.
=======
Signup
=========

The Signup tool allows users to signup for a workshop, presentation, meeting, or any other event requiring a reservation. Users will be sent automatic reminders about the event and allowed to cancel their reservation if needed.

Events in Signup can also contain a maximum participant limit. If the limit is reached users are automatically added to a waiting list. If an already confirmed user cancels the reservation, the people on the waiting list are confirmed as participants and sent a notification.

This application was generated with the [rails_apps_composer](https://github.com/RailsApps/rails_apps_composer) gem
provided by the [RailsApps Project](http://railsapps.github.io/).

Ruby on Rails
-------------

This application requires:

-   Ruby
-   Rails

Learn more about [Installing Rails](http://railsapps.github.io/installing-rails.html).

Database
--------

This application uses MySQL with ActiveRecord.

Development
-----------

-   Template Engine: ERB
-   Testing Framework: Test::Unit
-   Form Builder: SimpleForm
-   Authentication: Omniauth ([CAS](http://jasig.github.io/cas/4.0.x/index.html) support built-in. Other services can be added as needed.)

Email
-----

The application is configured to send email using a SMTP account.

Email delivery is disabled in development.


Contributing
------------

We encourage you to contribute to Signup! Here's how:

-   Fork the project on GitHub.
-   Make your feature addition or bug fix.
-   Commit with Git.
-   Send us a pull request.

If you add functionality to Signup, create an alternative
implementation, or build an application that is similar, please contact
us and we’ll add a note to the README so that others can find your work.

Credits
-------

Signup is developed by the Texas State University [Educational Technology Center](http://www.its.txstate.edu/departments/etc/signup.html).

License
-------

Signup is released under the Apache License Version 2.0. See the LICENSE.txt file for details.

Development
-------
* For dev, using fakesmtp , but do need to uncomment followinng line in config/application.rb  for smtp_settings

    enable_starttls_auto: false,

* Till [commit 1937f6014c48](https://github.com/txstate-etc/txst-signup/commit/1937f6014c4808ff7509e3de610357c2d3dbb35a), this txst-signup is depend on [signup gem source code ](https://github.com/txstate-etc/signup/commit/0b87344243abeacdbb011ce1ff1c805ea18eadf5) (as signup engine) which was also developed by Texas State University as an open source contribution).

