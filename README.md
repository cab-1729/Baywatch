# Baywatch

A command-line program to browse torrents from the infamous [PirateBay](thepiratebay.org/index.html).

Terminal colors are used to be aesthetically pleasing. The interface is designed to be as minimal as possible.
This project was heavily inspired by `torrtux`. In fact the whole reason why I wrote this was that I saw a video on `torrtux` but I couldn't find the program anywhere.

This project has no affiliation with the site _PirateBay_. The code for this project was written by reverse engineering the website.

## Usage

1. Run the Perl script and you will be prompted for a search string.
2. Above the prompt are displayed the categories that will be searched.
3. If you want to change the categories, press enter without providing any search.
4. You will be prompted to enter either `y` or `n` for each category, `y` indicating you want that category to be searched, `n` indicating the opposite. All other keys will be ignored.
5. After the search is complete you will be shown a list of all the torrents with relevant details shown in different colors. You may scroll up with the help of your terminal emulator/multiplexer.
6. After you have decided on the torrent, enter the number in purple on the leftmost column.
7. Relevant details will be shown and the following prompt will appear.
```
Press:
        d to view description
        v to view magnet link
        c to copy magnet link to clipboard
        t to send to transmission-client
        b to go back
```
8. Press the key to activate the option you see fit. You choose multiple options as the prompt is still valid after the keys are pressed.
9. If you do not use `transmission-cli`, then you may copy the magnet link and use it in your torrent client of choice.
10. To go back to the torrent prompt enter `b` as instructed
11. You will be taken back to the torrent prompt where you may enter the number of another torrent number and do the same.
12. If you wish to go back to search a new torrent, press enter leaving the torrent prompt blank.
13. Repeat
14. If you wish to exit the program at any point, close the terminal buffer or press `Crtl+C` .

## Dependencies

Perl and Perl modules:
+ LWP::UserAgent
+ URI::Encode
+ JSON::Parse
+ Term::ReadKey
+ Term::ANSIColor
+ Number::Format
+ YAML::Tiny
+ Clipboard

## Contributing

One must remember that this project aims to be very minimal.
Issues, pull requests and suggestions are welcome as long as there is an understanding that I am not obliged to make changes I don't deem necessary.
If you feel something is wrong or lacking with the project, you have the right to fork it and go your own way.
