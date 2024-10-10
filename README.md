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

  WorldbankAsDataframe::Commodities.new.fetch
  #    => 
  # shape: (777, 72)
  # ┌────────────┬────────────────────────────┬──────────────────────────┬──────────────────────────┬───┬─────────────┬──────────────────┬──────────────────────┬────────────────────┐
  # │ Timestamps ┆ Crude oil, average ($/bbl) ┆ Crude oil, Brent ($/bbl) ┆ Crude oil, Dubai ($/bbl) ┆ … ┆ Zinc ($/mt) ┆ Gold ($/troy oz) ┆ Platinum ($/troy oz) ┆ Silver ($/troy oz) │
  # │ ---        ┆ ---                        ┆ ---                      ┆ ---                      ┆   ┆ ---         ┆ ---              ┆ ---                  ┆ ---                │
  # │ date       ┆ f64                        ┆ f64                      ┆ f64                      ┆   ┆ f64         ┆ f64              ┆ f64                  ┆ f64                │
  # ╞════════════╪════════════════════════════╪══════════════════════════╪══════════════════════════╪═══╪═════════════╪══════════════════╪══════════════════════╪════════════════════╡
  # │ 1960-01-01 ┆ 1.63                       ┆ 1.63                     ┆ 1.63                     ┆ … ┆ 260.8       ┆ 35.27            ┆ 83.5                 ┆ 0.9137             │
  # │ 1960-02-01 ┆ 1.63                       ┆ 1.63                     ┆ 1.63                     ┆ … ┆ 244.9       ┆ 35.27            ┆ 83.5                 ┆ 0.9137             │
  # │ 1960-03-01 ┆ 1.63                       ┆ 1.63                     ┆ 1.63                     ┆ … ┆ 248.7       ┆ 35.27            ┆ 83.5                 ┆ 0.9137             │
  # │ 1960-04-01 ┆ 1.63                       ┆ 1.63                     ┆ 1.63                     ┆ … ┆ 254.6       ┆ 35.27            ┆ 83.5                 ┆ 0.9137             │
  # │ 1960-05-01 ┆ 1.63                       ┆ 1.63                     ┆ 1.63                     ┆ … ┆ 253.8       ┆ 35.27            ┆ 83.5                 ┆ 0.9137             │
  # │ …          ┆ …                          ┆ …                        ┆ …                        ┆ … ┆ …           ┆ …                ┆ …                    ┆ …                  │
  # │ 2024-05-01 ┆ 81.445                     ┆ 81.995                   ┆ 83.53                    ┆ … ┆ 2959.13     ┆ 2351.13          ┆ 1014.68              ┆ 29.36              │
  # │ 2024-06-01 ┆ 81.205                     ┆ 82.555                   ┆ 82.17                    ┆ … ┆ 2809.19     ┆ 2326.44          ┆ 985.08               ┆ 29.577             │
  # │ 2024-07-01 ┆ 83.258667                  ┆ 85.296                   ┆ 83.94                    ┆ … ┆ 2777.27     ┆ 2398.2           ┆ 978.8                ┆ 29.773             │
  # │ 2024-08-01 ┆ 78.121                     ┆ 80.863                   ┆ 77.95                    ┆ … ┆ 2714.08     ┆ 2470.15          ┆ 945.36               ┆ 28.53              │
  # │ 2024-09-01 ┆ 72.424333                  ┆ 74.293                   ┆ 73.43                    ┆ … ┆ 2837.02     ┆ 2570.55          ┆ 966.7                ┆ 30.131             │
  # └────────────┴────────────────────────────┴──────────────────────────┴──────────────────────────┴───┴─────────────┴──────────────────┴──────────────────────┴────────────────────┘ 

  WorldbankAsDataframe::Commodities.new('crude').fetch 
  #   => 
  # shape: (777, 5)
  # ┌────────────┬────────────────────────────┬──────────────────────────┬──────────────────────────┬────────────────────────┐
  # │ Timestamps ┆ Crude oil, average ($/bbl) ┆ Crude oil, Brent ($/bbl) ┆ Crude oil, Dubai ($/bbl) ┆ Crude oil, WTI ($/bbl) │
  # │ ---        ┆ ---                        ┆ ---                      ┆ ---                      ┆ ---                    │
  # │ date       ┆ f64                        ┆ f64                      ┆ f64                      ┆ f64                    │
  # ╞════════════╪════════════════════════════╪══════════════════════════╪══════════════════════════╪════════════════════════╡
  # │ 1960-01-01 ┆ 1.63                       ┆ 1.63                     ┆ 1.63                     ┆ null                   │
  # │ 1960-02-01 ┆ 1.63                       ┆ 1.63                     ┆ 1.63                     ┆ null                   │
  # │ 1960-03-01 ┆ 1.63                       ┆ 1.63                     ┆ 1.63                     ┆ null                   │
  # │ 1960-04-01 ┆ 1.63                       ┆ 1.63                     ┆ 1.63                     ┆ null                   │
  # │ 1960-05-01 ┆ 1.63                       ┆ 1.63                     ┆ 1.63                     ┆ null                   │
  # │ …          ┆ …                          ┆ …                        ┆ …                        ┆ …                      │
  # │ 2024-05-01 ┆ 81.445                     ┆ 81.995                   ┆ 83.53                    ┆ 78.81                  │
  # │ 2024-06-01 ┆ 81.205                     ┆ 82.555                   ┆ 82.17                    ┆ 78.89                  │
  # │ 2024-07-01 ┆ 83.258667                  ┆ 85.296                   ┆ 83.94                    ┆ 80.54                  │
  # │ 2024-08-01 ┆ 78.121                     ┆ 80.863                   ┆ 77.95                    ┆ 75.55                  │
  # │ 2024-09-01 ┆ 72.424333                  ┆ 74.293                   ┆ 73.43                    ┆ 69.55                  │
  # └────────────┴────────────────────────────┴──────────────────────────┴──────────────────────────┴────────────────────────┘ 

WorldbankAsDataframe::Commodities.new('gold').fetch(start: '1980-01-01', fin: '2000-12-31') 
  #  => 
  # shape: (252, 2)
  # ┌────────────┬──────────────────┐
  # │ Timestamps ┆ Gold ($/troy oz) │
  # │ ---        ┆ ---              │
  # │ date       ┆ f64              │
  # ╞════════════╪══════════════════╡
  # │ 1980-01-01 ┆ 675.31           │
  # │ 1980-02-01 ┆ 665.32           │
  # │ 1980-03-01 ┆ 553.58           │
  # │ 1980-04-01 ┆ 517.41           │
  # │ 1980-05-01 ┆ 513.8            │
  # │ …          ┆ …                │
  # │ 2000-08-01 ┆ 274.47           │
  # │ 2000-09-01 ┆ 273.68           │
  # │ 2000-10-01 ┆ 270.0            │
  # │ 2000-11-01 ┆ 266.01           │
  # │ 2000-12-01 ┆ 271.45           │
  # └────────────┴──────────────────┘ 

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



