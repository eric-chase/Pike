"""
COMS W4111.001 Introduction to Databases Webserver

To run locally: python server.py
Go to http://localhost:8111 in your browser.

"""

import os
from sqlalchemy import *
from sqlalchemy.pool import NullPool
from flask import Flask, request, render_template, g, redirect, Response
import datetime

tmpl_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'templates')
app = Flask(__name__, template_folder = tmpl_dir)

# Connects to database
DATABASEURI = "postgresql://eac2242:BestDatabaseEver@35.231.44.137/proj1part2"

# Create a database engine that knows how to connect to the above URI
engine = create_engine(DATABASEURI)

@app.before_request
def before_request():
    """
    This function is run at the beginning of every web request
    (every time an address is entered in the web browser).
    We use it to setup a database connection that can be used throughout the request.

    The variable g is globally accessible.
    """
    try:
        g.conn = engine.connect()
    except:
        print ("Error connecting to database.")
        import traceback; traceback.print_exc()
        g.conn = None

# At the end of the web request, this makes sure to close the database connection
@app.teardown_request
def teardown_request(exception):
    try:
        g.conn.close()
    except Exception:
        pass

# Render the index page
@app.route('/') # Non-logged in user
@app.route('/index.html/<name>') # Logged in user
def index(name = None):
    return render_template('index.html', user = name)

# Render the login page
@app.route('/log_in.html')
def log_in_form():
    return render_template('log_in.html')

# Render the register page
@app.route('/register.html')
def register_form(error = 0):
    return render_template('register.html', error = error)

# Activated when a user attempts to login
@app.route('/login', methods = ['POST'])
def log_in():
    username = request.form['username']
    password = request.form['password']
    # Specified user information checked to see if it is a valid user in the database
    cursor = g.conn.execute("SELECT * FROM Users U WHERE (U.username = %s AND U.password = %s);", 
                            (username, password))
    users = []
    for result in cursor:
        users.append(result)
    cursor.close()

    # Invalid login information
    if len(users) == 0:
        return render_template('index.html', user = None, error = 1)
    # Valid login information
    else:
        return redirect('/index.html/' + username)

# Activated when a user registers
@app.route('/register', methods = ['POST'])
def register():
    username = request.form['username']
    password = request.form['password']
    # Username and password lengths checked
    if (len(username) > 20 or len(password) > 20):
        # Error returned if either username or password is too long
        return register_form(1)
    # Specified user information inserted into the database
    g.conn.execute("INSERT INTO Users (username, password) VALUES (%s, %s);", username, password)
    return redirect('/index.html/' + username)

# Render the search page
@app.route('/search', methods = ['POST'])
@app.route('/search/<name>', methods = ['POST'])
def search(name=None):
    search_word = request.form['song_search'].lower()
    
    # Search by song
    cursor = g.conn.execute("""SELECT S.song_id, S.title, A.act_id, A.name AS act_name
    FROM Songs S, performs P, Acts A
    WHERE lower(S.title) LIKE '%%' || %s || '%%' AND S.song_id = P.song_id AND P.act_id = A.act_id;""", (search_word))
    songs = []
    for result in cursor:
        songs.append(result)

    # Search by album
    cursor1 = g.conn.execute("""SELECT A.album_id
                                FROM Albums A
                                WHERE lower(A.title) LIKE '%%' || %s || '%%';""", (search_word))
    albums = []
    for result1 in cursor1:
        cursor2 = g.conn.execute("""SELECT S.song_id, S.title, A.act_id, A.name AS act_name
        FROM (SELECT P2.song_id
              FROM part_of P2
              WHERE P2.album_id = %s) AlbumIDs,
              songs S, performs P1, Acts A
        WHERE AlbumIDs.song_id = S.song_id AND
              S.song_id = P1.song_id AND
              P1.act_id = A.act_id;""", (result1['album_id']))
        for result2 in cursor2:
            albums.append(result2)

    # Search by act
    cursor1 = g.conn.execute("""SELECT A.act_id FROM Acts A WHERE lower(a.name)
            LIKE '%%' || %s || '%%';""", (search_word))
    acts = []
    for result1 in cursor1:
        cursor2 = g.conn.execute("""SELECT S.song_id, S.title, A.act_id, A.name AS act_name
        FROM Songs S, performs P1, Acts A
        WHERE S.song_id = P1.song_id AND P1.act_id = A.act_id AND
        S.song_id IN (SELECT P2.song_id FROM performs P2 WHERE P2.act_id = %s);""", (result1['act_id']))
        for result2 in cursor2:
            acts.append(result2)

    # Search by genre
    cursor = g.conn.execute("""SELECT S.song_id, S.title, A.act_id, A.name AS act_name
    FROM Songs S, performs P, Acts A
    WHERE lower(S.genre) LIKE '%%' || %s || '%%' AND S.song_id = P.song_id AND P.act_id = A.act_id;""", (search_word))
    genre = []
    for result in cursor:
        genre.append(result)

    # Search by artist
    cursor = g.conn.execute("""SELECT S.song_id, S.title, A1.act_id, A1.name AS act_name
        FROM Songs S, performs P1, Acts A1
        WHERE S.song_id = P1.song_id AND P1.act_id = A1.act_id AND
        A1.act_id IN (SELECT P2.act_id FROM plays_in P2 WHERE
        P2.artist_id IN (SELECT A2.artist_id FROM Artists A2
        WHERE lower(A2.name) LIKE '%%' || %s || '%%'));""", (search_word))
    artists = []
    for result in cursor:
        artists.append(result)

    # The user is notified if the search result returns nothing
    if (len(songs) == 0 and len(albums) == 0 and len(acts) == 0 and len(genre) == 0 and
    len(artists) == 0):
        return render_template("search.html", user = name, songs = songs,
                           album_songs = albums, act_songs = acts, genre_songs = genre,
                           artist_songs = artists, error = 1)

    return render_template("search.html", user = name, songs = songs,
                           album_songs = albums, act_songs = acts, genre_songs = genre,
                           artist_songs = artists)

# Finding related music: Outer function that works through the specified degrees of separation
def degrees_of_separation(list_of_songs, remaining_degrees):
    songs = set() # Related music set

    if remaining_degrees < 0:
        return set()

    if remaining_degrees == 0:
        return set(list_of_songs)

    # For each song, its related songs are added to the set
    for song in list_of_songs:
        related_songs, distant_songs = get_related_songs(int(song[0]),
                                                         int(song[2]),
                                                         remaining_degrees)

        songs.update(degrees_of_separation(related_songs,
                                           remaining_degrees - 1))

        songs.update(degrees_of_separation(distant_songs,
                                           remaining_degrees - 2))

    return songs

# Finding related music: Inner function that gets the related songs for a single song
def get_related_songs(song_id, act_id, degree):
    songs = set()
    distant_songs = set()

    # Get all songs by the same act
    cursor = g.conn.execute("""
        SELECT S.song_id, S.title, A.act_id, A.name AS act_name
        FROM Songs S, Performs P, Acts A
        WHERE S.song_id = P.song_id
        AND A.act_id = P.act_id
        AND P.act_id = %s;
        """, (act_id))

    for song in cursor:
        songs.add(tuple(song))

    # Get all albums that the song appears in
    cursor1 = g.conn.execute("""
                            SELECT A.album_id
                            FROM Albums A, part_of P
                            WHERE A.album_id = P.album_id
                            AND P.song_id = %s;""", (song_id))
    # For each album, get the songs in that album
    for result1 in cursor1:
        cursor2 = g.conn.execute("""SELECT S.song_id, S.title, A.act_id, A.name AS act_name
        FROM (SELECT P2.song_id
        FROM part_of P2
        WHERE P2.album_id = %s) AlbumIDs,
        songs S, performs P1, Acts A
        WHERE AlbumIDs.song_id = S.song_id AND
        S.song_id = P1.song_id AND
        P1.act_id = A.act_id;
        """, (result1['album_id']))
    for song in cursor2:
        songs.add(tuple(song))

    # Get all songs by acts that share an artist
    cursor = g.conn.execute("""
        SELECT S.song_id, S.title, A.act_id, A.name AS act_name
        FROM Songs S, Acts A, Performs P1, Performs P2,

        (SELECT PA1.act_id as first_id, PA2.act_id as second_id
        FROM plays_in PA1, plays_in PA2
        WHERE PA1.act_id != PA2.act_id
        AND PA1.act_id = %s
        AND PA1.artist_id = PA2.artist_id) P

        WHERE P.first_id = P1.act_id AND P.second_id = P2.act_id
        AND P1.song_id = %s
        AND P2.song_id = S.song_id
        AND A.act_id = P2.act_id
        """, (act_id, song_id))

    for song in cursor:
        distant_songs.add(tuple(song))

    return songs, distant_songs

# Render the collections page
@app.route('/collections/<name>')
@app.route('/collections/user=<name>&owner=<c_owner>')
def collections(name, c_owner = None, error = 0):
    if c_owner is None: # A user is viewing their own collections
        c_owner = name
    # Get all collections for the user given by c_owner
    cursor = g.conn.execute("""SELECT C.name FROM Collections_owns C
    WHERE C.username = %s;""", (c_owner))
    collection_list = []
    for result in cursor:
        collection_list.append(result)

    return render_template("collections.html", user = name, collections = collection_list,
                           c_owner = c_owner, error = error)

# Render the song page
@app.route('/song/song_id=<song_id>&act_id=<act_id>', methods = ['GET', 'POST'])
@app.route('/song/song_id=<song_id>&act_id=<act_id>&user=<name>', methods = ['GET', 'POST'])
def song(song_id, act_id, name = None, error_1 = 0, error_2 = 0):
    # Number of views for the given song incremented
    g.conn.execute("""UPDATE performs SET num_views = num_views + 1
                   WHERE song_id = %s AND act_id = %s""", (song_id, act_id))
    
    # Song info and reviews retrieved from the database
    song_cursor = g.conn.execute("""SELECT * FROM Songs S WHERE S.song_id = %s;""", (song_id))
    song = song_cursor.fetchone()
    reviews = g.conn.execute("""SELECT * FROM Reviews R WHERE R.song_id = %s
                             AND R.act_id = %s;""", (song_id, act_id))
    p_info_cursor = g.conn.execute("""SELECT * FROM performs P WHERE P.song_id = %s
                          AND P.act_id = %s""", (song_id, act_id))
    p_info = p_info_cursor.fetchone()

    # For logged-in users, collections are retrieved from the database
    c_list = []
    if (name != None):
        c_cursor = g.conn.execute("""SELECT * FROM Collections_owns C WHERE
                                  C.username = %s""", (name))
        for result in c_cursor:
            c_list.append(result)

    return render_template("song.html", user = name, song_id = song_id,
                           act_id = act_id, error_1 = error_1, reviews = reviews, 
                           title = song.title, length = song.length,
                           genre = song.genre, views = p_info.num_views,
                           link = p_info.link, likes = p_info.num_likes,
                           collections = c_list, error_2 = error_2)

# Activated when a user likes a song
@app.route('/like/song_id=<song_id>&act_id=<act_id>', methods = ['GET', 'POST'])
@app.route('/like/song_id=<song_id>&act_id=<act_id>&user=<name>', methods = ['GET', 'POST'])
def like(song_id, act_id, name = None):
    # Number of likes for the given song incremented
    g.conn.execute("""UPDATE performs SET num_likes = num_likes + 1
                   WHERE song_id = %s AND act_id = %s""", (song_id, act_id))
    if name is None: # Non-logged in user
        return song(song_id, act_id)
    else: # Logged-in user
        return song(song_id, act_id, name)

# Activated when a user reviews a song
@app.route('/review/song_id=<song_id>&act_id=<act_id>', methods = ['POST'])
@app.route('/review/song_id=<song_id>&act_id=<act_id>&user=<name>', methods = ['POST'])
def review(song_id, act_id, name = 'anon'):
    comment = request.form['comment']
    rating = request.form['rating']
    # Check if comment is valid
    if rating == '0' or comment == '' or comment.isspace() or len(comment) > 100:
        # All non-logged in users leave reviews under the account 'anon'
        if name == 'anon':
            return song(song_id, act_id, None, 1)
        else:
            return song(song_id, act_id, name, 1)
    time = str(datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
    # New review inserted into the database
    g.conn.execute("""INSERT INTO Reviews (rating, text, username, song_id,
                    act_id, date_time) VALUES (%s, %s, %s, %s, %s, %s);""",
                   (rating, comment, name, song_id, act_id, time))
    if(name == 'anon'):
        return song(song_id, act_id)
    else:
        return song(song_id, act_id, name)

# Render the friends page
@app.route('/friends/<name>')
def friends(name, error = 0):
    # Retrieve the friends of the specified user from the database
    cursor1 = g.conn.execute("""SELECT F.username2 AS username FROM are_friends F
    WHERE F.username1 = %s;""", (name))
    cursor2 = g.conn.execute("""SELECT F.username1 AS username FROM are_friends F
    WHERE F.username2 = %s;""", (name))
    friend_list = []
    for result in cursor1:
        friend_list.append(result)
    for result in cursor2:
        friend_list.append(result)

    return render_template("friends.html", user = name, friends = friend_list, error = error)

# Render the peek page (for looking at the songs in a collection)
@app.route('/peek/user=<name>&collection=<c_name>')
@app.route('/peek/user=<name>&collection=<c_name>&owner=<c_owner>')
def peek(name, c_name, c_owner = None):
    if c_owner is None: # A user is peeking into their own collection
        c_owner = name
    # The songs from the specified collection are retrieved from the database
    cursor = g.conn.execute("""SELECT S.song_id, S.title, A.act_id, A.name AS act_name
    FROM Songs S, performs P1, Acts A
    WHERE S.song_id = P1.song_id AND P1.act_id = A.act_id AND
    (S.song_id, A.act_id) IN (SELECT C.song_id, C.act_id FROM contains C WHERE C.name = %s
    AND C.username = %s);""", (c_name, c_owner))

    song_list = []
    for result in cursor:
        song_list.append(result)

    return render_template("peek.html", user = name, songs = song_list, collection = c_name)

# Activated when a user sends a friend request
@app.route('/add_friend/<name>', methods = ['POST'])
def add_friend(name):
    friend = request.form['friend']
    # Check if friend username corresponds to a valid user
    check = g.conn.execute("""SELECT * FROM Users U WHERE U.username = %s""",
                           (friend))
    check_list = []
    for entry in check:
        check_list.append(entry)
    if(len(check_list) == 0):
        return friends(name, 1)
    
    # Check if the two users are already friends
    check = g.conn.execute("""SELECT * FROM are_friends F WHERE (F.username1 = 
                            %s AND F.username2 = %s) OR (F.username1 = %s AND 
                            F.username2 = %s);""", (name, friend, friend, name))
    check_list = []
    for entry in check:
        check_list.append(entry)
    # Insert the friend request information into the database
    if(len(check_list) == 0):
        g.conn.execute("""INSERT INTO are_friends (username1, username2) 
                        VALUES (%s, %s);""", (name, friend))
        return friends(name)
    else:
        return friends(name, 1)

# Activated when a user adds a collection
@app.route('/add_collection/<name>', methods = ['POST'])
def add_collection(name):
    collection = request.form['collection']
    # Chek if collection name is too long
    if (len(collection) > 30):
        return collections(name, None, 1)
        
    # Check if the user already has a collection with that name
    check = g.conn.execute("""SELECT * FROM Collections_owns C WHERE (C.username = 
                            %s AND C.name = %s);""", (name, collection))
    check_list = []
    for entry in check:
        check_list.append(entry)
    # Insert the new collection into the database
    if(len(check_list) == 0):
        g.conn.execute("""INSERT INTO Collections_owns (username, name) 
                        VALUES (%s, %s);""", (name, collection))
        return collections(name)
    else:
        return collections(name, None, 1)

# Activated when a user adds a song to a collection
@app.route('/add_song/song_id=<song_id>&act_id=<act_id>&user=<name>&c_name=<c_name>')
def add_song(song_id, act_id, name, c_name):
    # Check if that collection already holds the song
    check = g.conn.execute("""SELECT * FROM contains C WHERE (C.username = 
                            %s AND C.name = %s AND C.song_id = %s AND
                            C.act_id = %s);""", (name, c_name, song_id, act_id))
    check_list = []
    for entry in check:
        check_list.append(entry)
    # Insert the song into the specified collection
    if(len(check_list) == 0):
        g.conn.execute("""INSERT INTO contains (username, name, song_id,
                          act_id) VALUES (%s, %s, %s, %s);""", (name,
                          c_name, song_id, act_id))
        return song(song_id, act_id, name)
    else:
        return song(song_id, act_id, name, 0, 1)

# Render the related page (for getting related music)
@app.route('/related/song_id=<song_id>&act_id=<act_id>&degrees=<degrees>')
@app.route('/related/song_id=<song_id>&act_id=<act_id>&degrees=<degrees>&user=<name>')
def related(song_id, act_id, degrees, name = None):
    song_cursor = g.conn.execute("""SELECT S.song_id, S.title, A.act_id, A.name AS act_name
                                    FROM Songs S, performs P, Acts A
                                    WHERE S.song_id = P.song_id AND A.act_id = P.act_id
                                    AND P.song_id = %s AND P.act_id = %s;""", (song_id, act_id))
    songs = []
    for song in song_cursor:
        songs.append(song)

    if int(degrees) == 1:
        songs = degrees_of_separation(songs, 1)
    if int(degrees) == 2:
        songs = degrees_of_separation(songs, 2)
    if int(degrees) == 3:
        songs = degrees_of_separation(songs, 3)
    if int(degrees) == 4:
        songs = degrees_of_separation(songs, 4)

    songs = [song for song in songs if song[0] != int(song_id)]

    if len(songs) == 0:
        return render_template("related.html", user = name, songs = songs, error = 1)
    else:
        return render_template("related.html", user = name, songs = songs)

# For main method
if __name__ == "__main__":
    import click

    @click.command()
    @click.option('--debug', is_flag=True)
    @click.option('--threaded', is_flag=True)
    @click.argument('HOST', default='0.0.0.0')
    @click.argument('PORT', default=8111, type=int)
    def run(debug, threaded, host, port):

        HOST, PORT = host, port
        print ("running on %s:%d" % (HOST, PORT))
        app.run(host=HOST, port=PORT, debug=debug, threaded=threaded)

    run()
