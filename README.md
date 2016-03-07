### Lawn Mowing GEM
GEM reponsible for run the manual and automatic systems.  To run both systems the user has to cal a file which is located in bin directory.
    <p>GitHub<br>
      https://github.com/romalopes/lawn_mowing<br>
    Travis<br>
      https://travis-ci.org/romalopes/lawn_mowing<br>
    </P>

    To run locally:
      $ git clone https://github.com/romalopes/lawn_mowing.git
      $ cd lawn_mowing

    Testing:
      $ rspec spec
    To run the GEM
    Manual Mowing system:
      Run:
        $ ruby -Ilib ./bin/lawn_mowing.rb "manual_mowing.txt"
      File format:
        Fist line has informatino of width and height.
        Following lines have position of each mower, heading and sequence of moves.
        Ex:
        5 5 
        1 2 N
        LMLMLMLMM
        3 3 E
        MRMRMRMRMM
    Automatic Mowing system:
      Run:
        $ ruby -Ilib ./bin/lawn_mowing.rb "automatic_mowing.txt"
      File format:
        1 Line with 3 information, width and height of lawn and number of mowers.
      Ex: 5 5 3
