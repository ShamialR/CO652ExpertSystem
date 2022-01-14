:- dynamic at/2, i_am_at/1, alive/1.   /* Needed by SWI-Prolog. */

:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).

 

i_am_at(town).

path(town, north, mountain).

path(town, south, knight).
path(knight, north, town).

path(town, east, inn).
path(town, west, shop).

path(shop, east, town).
path(inn, west, town).

path(mountain, south, town).
path(mountain, north, mountain_cave).
path(mountain_cave, south, mountain).

path(mountain_cave, east, dragon).
path(dragon, west, mountain_cave).
path(dragon, north, gold_room).
path(gold_room, south, dragon).

path(haunted_village, south, knight).
path(haunted_village, east, fishing_port).
path(fishing_port, west, haunted_village).


at(diamonds, gold_room).
at(bow, inn).

alive(dragon).

take(X) :-
        at(X, in_hand),
        write('You''re already holding it!'),
        nl, !.

take(X) :-
        i_am_at(Place),
        at(X, Place),
        retract(at(X, Place)),
        assert(at(X, in_hand)),
        write('OK.'),
        nl, !.

take(_) :-
        write('I don''t see it here.'),
        nl.


/* These rules describe how to put down an object. */

drop(X) :-
        at(X, in_hand),
        i_am_at(Place),
        retract(at(X, in_hand)),
        assert(at(X, Place)),
        write('OK.'),
        nl, !.

drop(_) :-
        write('You aren''t holding it!'),
        nl.

/* This fact specifies that the dragon is alive. */ 

north :- go(north).
south :- go(south).
east :- go(east).
west :- go(west).

 
go(Direction) :-

        i_am_at(Here),
        path(Here, Direction, There),
        retract(i_am_at(Here)),
        assert(i_am_at(There)),
        look, !.

go(_) :-

        write('You can''t go that way.').

look :-
        i_am_at(Place),
        describe(Place),
        nl,
        notice_objects_at(Place),
        nl.
                               
notice_objects_at(Place) :-
        at(X, Place),
        write('There is a '), write(X), write(' here.'), nl,
        fail.

 notice_objects_at(_).

/* These rules tell how to handle killing the dragon. */
kill :-
        i_am_at(mountain_cave),
        write('This isn''t working.  The dragon''s skin is about as tough'), nl,
        write('as an iron chestplate.').

kill :-
        i_am_at(dragon),
        at(bow, in_hand),
        retract(alive(dragon)),
        write('You fire repeatedly at the dragon''s face.  blood'), nl,
        write('gushes out of the dragon''s face, and gets all over you.'), nl,
        write('I think you have killed it, despite the continued twitching.'),
        nl, !.

kill :-
        i_am_at(dragon),
        write('Beating on the dragon''s tail with your fists has no'), nl,
        write('effect.  This is totally useless.'), nl.

kill :-
        i_am_at(town),
        at(bow, in_hand),
        retract(alive(knight)),
        write('You snipe at the weak points of the knight''s armour.  blood'), nl,
        write('gushes out of the knight''s exposed knee, and covers the floor.'), nl,
        write('I think you just killed someone, that wasn''t necessary.'),
        nl, !.

kill :-
        i_am_at(town),
        write('smacking on the knight''s chestplate with your fists leaves no'), nl,
        write('dent.  This is a dumb idea which you now have regret for.'), nl,
        write('The knight swings his sword cutting your head off!'), nl.
        die.

kill :-

        write('I see nothing as a threat here.'), nl.

/* This rule tells how to die. */
die :-

        !, finish.

start :-

        instructions,

        look.

instructions :-
        nl,
        write('Enter commands using standard Prolog syntax.'), nl,
        write('Available commands are:'), nl,
        write('start.                   -- to start the game.'), nl,
        write('north.  south.  east.  west.  -- to go in that direction.'), nl,
        write('take(Object).            -- to pick up an object.'), nl,
        write('drop(Object).            -- to put down an object.'), nl,
        write('kill.                    -- to attack an enemy.'), nl,
        write('look.                    -- to look around you again.'), nl,
        write('instructions.            -- to see this message again.'), nl,
        write('halt.                    -- to end the game and quit.'), nl,
        nl.

describe(town) :-
        write('You enter a seemingly deserted town.  To the north you '), nl,
        write('see a tall mountain; to the south you hear loud howling'), nl,
        write('from a nearby foggy village, maybe you will find an item '), nl,
        write('in the town that can help you find your way; to the east'), nl,
        write('is an inn; and to the south is a deserted shop; you take'), nl,
        write('out a torn map with X marked somewhere around the mountain'), nl,
        write('to the north'), nl,
        write('There''s also this knight here but i don''t '), nl,
        write(' think it''s a good idea to mess with him '), nl.
               
describe(inn) :-

        write('The Local town inn, it seems people left in a rush as you see'), nl,
        write('broken items all over the floor, maybe you should look around').

describe(shop) :-
        write('A deserted shop, seems like its already been looted').
		
describe(mountain) :-
        write('You see a massive mountain ahead of you with a small mine entrance'), nl,
        write('in the mountain, you hear load deep snoring from inside'), nl,
        die.

describe(haunted_village) :-
        at(gold, in_hand),
        write('Congratulations!!  You pocketed some gold!'), nl.

describe(haunted_village) :-
        write('This place is a bit too spooky but weirdly enough'), nl,
        write(' there''s free gold here!'), nl.        

describe(mountain_cave) :-
        alive(dragon),
        write('You are on facing a menacing dragon, standing in front'), nl,
        write('of its terrifiying presence.'), nl.

 describe(knight) :-
        alive(knight),
        write('You see a tall, well armoured knight with a greatsword.'), nl,
		die.

describe(knight) :-
        write('You contemplate whether to take the dead knight''s free armour.'), nl.       

describe(mountain_cave) :-
        alive(dragon),
        at(gold, in_hand),
        write('The dragon with it''s greedy eyes sees you with the gold and attacks!!!'), nl,
        write('    ...it is over in seconds....'), nl,
        die.

describe(dragon) :-
        alive(dragon),
        write('There is a giant dragon here!  One tail, about the'), nl,
        write('size of a telephone pole, is directly in front of you!'), nl,
        write('I would advise you to leave promptly and quietly....'), nl, !.

describe(dragon) :-
        write('Yecch!  My boots are covered in this dead dragon''s blood.').
               
describe(gold_room) :-
        write('you look up from your map and see you are surronded by a mountain'), n1,
		write('of gold and diamonds, maybe you could take some!').

describe(fishing_port) :-
        write('the local fishing port').
