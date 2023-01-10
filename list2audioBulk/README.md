# AudioSearcher

It searches, filters, sorts and collects youtube-playlists for you. 
Just hand them over to youtube-dl and fill your storage for offline times.

If you want to see a sample output, there is a file called sample_output.txt.

## Usage

./list2audioBulk.sh [searchTermList] [whitelist]

Whitelist = removes all playlists whitout one of the words. Newline-seperated

If you dont provide a whitelist the searchTermList becomes also the whitelist.

If you dont provide a searchTermList it reads from stdin.

### What does it do in detail?

It searches youtube for playlists which include also a keyword on the whitelist.
