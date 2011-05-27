Extended Mind
=============

Overview
--------

http://xkcd.com/903 (xkcd comic #903) suggested that for any article on 
Wikipedia you can get to the article on Philosophy by clicking on the 
first valid link.

    Wikipedia trivia: if you take any article, click on the first link in the article text not in parentheses or italics, and then repeat, you will eventually end up at "Philosophy".

Usage
-----

### run.rb

  * Contains the core ExtendedMind class.
  * For use as a library 
  * Or for use to find the trail of a single page
    * ruby run.rb Prolog

### random.rb
  
  * Pulls a new page from Wikipedia:Random and data logs the results.

### analyze_data.rb

  * Since there's actually a lot of data here, this script prints out (with colour!) various statistics.

Special Thanks
--------------

  * To dominikh for a quick and dirty YAML cache.
