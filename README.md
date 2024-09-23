# WorldbankAsDataframe

A wrapper for the World Bank's Development Indicators API.  This API was initially developed and sponsored by Code for America, and later updated by Alexander Auritt.

Please see the World Bank's data [[developer's page](http://data.worldbank.org/developers/)] for more info on the data sources.



Usage
-----
```ruby

	require 'worldbank_as_dataframe'

  WorldbankAsDataframe::Source.all.fetch       # =>  ['Doing Business', 'Something Else'...]
                                    #        array of 16 sources of information the bank used

  WorldbankAsDataframe::IncomeLevel..all.fetch # =>  { HIC: 'High Income', HPC: 'Heavily Indebted Poor Countries (HIPC)'...}
                                    #       hash of 9 income levels the bank assigns

  WorldbankAsDataframe::LendingType.all.fetch  # =>  [ { id: 'IBD', value: 'IBRD' }... ] an array of key: value pairs of
                                    #        the 4 lending types

  WorldbankAsDataframe::Topic.all.fetch        # =>  the 18 high level topics that indicators are grouped into

  WorldbankAsDataframe::Region.all.fetch       # =>  returns all the regions the World Bank can classify a country as

  WorldbankAsDataframe::Country.all.fetch      # =>  returns all countries the World Bank tracks

  WorldbankAsDataframe::Indicator.all.fetch    # =>  returns all the indicators the World Bank uses

  WorldbankAsDataframe::Indicator.featured     # =>  returns the featured indicators

  WorldbankAsDataframe::Topic.all.fetch        # =>  returns all the topics the World Bank catagorizes its indicators into


include WorldbankAsDataframe
  #
  # Topics
  #
  @environment = Topic.find(6).fetch
  @environment.id                 # =>  6
  @environment.name               # =>  'Environment'
  @environment.note               # =>  'Natural and man-made environmental resources – fresh...'

  #
  # Countries
  #
  @brazil = Country.find('br').fetch
  @brazil = Country.find('bra').fetch
  @brazil.name                    # =>  'Brazil'
  #
  # note: only low and middle income countries are classified by region...
  #
  @brazil.region                  # =>  <WorldbankAsDataframe::Region @name="Latin America & Caribbean (all income levels)" ....>
  @brazil.capital                 # =>  'Brasilia'
  @brazil.lending_type            # => <WorldbankAsDataframe::LendingType>

  #
  # Indicators
  #
  @tractors = Indicator.find('AG.AGR.TRAC.NO').fetch
  @tractors.id                    # =>  'AG.AGR.TRAC.NO'
  @tractors.name                  # =>  'Agricultural Machinery, tractors'
  @tractors.source                # =>  { id: 2, value: 'World Development Indicators' }

  #
  # Data
  #
  @results = WorldbankAsDataframe::Data.country('brazil').indicator('NY.GDP.MKTP.CD').dates('2000:2008').fetch
  # returns an array of WorldbankAsDataframe::Data objects that correspond to
  # Brazil's Yearly Gross Domestic Product as MarKeT Prices in Current U.S.
  # Dollars from 2000 to 2008

  puts @results.first.name
  @results.each {|d| puts d.date + ': $' + d.value }
  #   => 
  # shape: (9, 2)  
  # ┌────────────┬──────────────────────────────┐                                                                                             
  # │ Timestamps ┆ GDP (current US$) for Brazil │                                                                                             
  # │ ---        ┆ ---                          │                                                                                             
  # │ date       ┆ f64                          │                                                                                             
  # ╞════════════╪══════════════════════════════╡                                                                                             
  # │ 2008-12-31 ┆ 1.6959e12                    │
  # │ 2007-12-31 ┆ 1.3971e12                    │
  # │ 2006-12-31 ┆ 1.1076e12                    │
  # │ 2005-12-31 ┆ 8.9163e11                    │
  # │ 2004-12-31 ┆ 6.6929e11                    │
  # │ 2003-12-31 ┆ 5.5823e11                    │
  # │ 2002-12-31 ┆ 5.0980e11                    │
  # │ 2001-12-31 ┆ 5.5998e11                    │
  # │ 2000-12-31 ┆ 6.5545e11                    │
  # └────────────┴──────────────────────────────┘ 
  #
  #  The WorldbankAsDataframe::Data can have have methods matching any of the World Bank API's
  # modifiers (like #dates above) called as class methods or chained in a query.
  #

```


Contributing
------------
In the spirit of [free
software](http://www.fsf.org/licensing/essays/free-sw.html),
**everyone** is encouraged to help improve this project.

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments,
  clean up inconsistent whitespace)
* by refactoring code
* by resolving [issues](https://github.com/bmck/worldbank_as_dataframe/issues)
* by reviewing patches

Submitting an Issue
-------------------
We use the [GitHub issue
tracker](https://github.com/bmck/worldbank_as_dataframe/issues) to track bugs and
features. Before submitting a bug report or feature request, check to
make sure it hasn't already
been submitted. You can indicate support for an existing issuse by
voting it up. When submitting a
bug report, please include a [Gist](https://gist.github.com/) that
includes a stack trace and any
details that may be necessary to reproduce the bug, including your gem
version, Ruby version, and
operating system. Ideally, a bug report should include a pull request
with failing specs.

Submitting a Pull Request
-------------------------
1. Fork the project.
2. Create a topic branch.
3. Implement your feature or bug fix.
4. Add documentation for your feature or bug fix.
5. Run <tt>bundle exec rake doc:yard</tt>. If your changes are not 100%
   documented, go back to step 4.
6. Add specs for your feature or bug fix.
7. Run <tt>bundle exec rake spec</tt>. If your changes are not 100%
   covered, go back to step 6.
8. Commit and push your changes.
9. Submit a pull request. Please do not include changes to the gemspec,
   version, or history file. (If you want to create your own version for
some reason, please do so in a separate commit.)

Copyright
---------
Copyright (c) 2011 Code for America
See
[LICENSE](https://github.com/bmck/worldbank_as_dataframe/blob/master/LICENSE.md)
for details.



