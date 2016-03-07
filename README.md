GEM reponsible for run the manual and automatic systems.  To run both systems the user has to cal a file which is located in bin directory.

GitHub
  https://github.com/romalopes/lawn_mowing
Travis
  https://travis-ci.org/romalopes/lawn_mowing

    To build a GEM
        $ gem build lawn_mowing.gemspec
    To install a GEM
        $ gem install ./lawn_mowing-0.1.0.gem

    To use a GEM
        use: require "lawn_mowing"
              Method....

To run the GEM

Manual:
  File format:
    Fist line has informatino of width and height.
    Following lines have position of each mower, heading and sequence of moves.
    Ex:
    5 5 
    1 2 N
    LMLMLMLMM
    3 3 E
    MRMRMRMRMM
    $ ruby -Ilib ./bin/lawn_mowing.rb "manual_mowing.txt"
Automatic
  File format:
    1 Line with 3 information, width and height of lawn and number of mowers.
  Ex: 5 5 3

  $ ruby -Ilib ./bin/lawn_mowing.rb "automatic_mowing.txt"





 To build a GEM
        $ gem build lawn_mowing.gemspec
    To install a GEM
        $ gem install ./lawn_mowing-0.1.0.gem
    Publish
        gem push lawn_mowing-0.1.0.gem
