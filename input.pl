%Attempt to read two coordinates, X and Y, and loop until valid ones have been entered.
read_coords( X, Y ) :-
	nl, nl, write( 'Please enter coordinates in the format "X-Y.", without the quotation marks.' ), nl,
	write( 'X should be the position along the line, and Y should be the line.' ), nl, nl,
    read( TX-TY ),
    (   (integer(TX), integer(TY))
    ->  X is TX, Y is TY, !
    ;   nl, write( 'Please enter valid values!' ), nl,
        read_coords( X, Y )
    ).

%Ask the user for a piece to move, and then get the coordinates to move it to.
read_move_aux1( Board, Line, Col, ML, Piece ) :-
	read_coords( TCol, TLine ),
	getPiece( Board, TLine, TCol, TPiece ),
	samePiece( Piece, TPiece, SP ),
	(	( SP is 0 ) %Check if we're NOT trying to move one of our own pieces.
	->	nl, write( 'Pick one of your own pieces!' ), nl, %And if we weren't, we throw a warning.
		read_move_aux1( Board, Line, Col, ML, Piece ) %And call the function again.
	;	listMoves( Board, TLine, TCol, TML ),
		(	( length(TML,0) ) %Ensure we have at least one possible move.
		->	nl, write( 'That piece has no valid moves! Please pick a different piece.' ), nl,
			read_move_aux1( Board, Line, Col, ML, Piece )
		;	Col is TCol, Line is TLine, append( [], TML, ML ), ! %And if so, continue.
		)
	).

read_move_aux2( DLine, DCol, ML ) :-
	printMoves( ML ),
	read_coords( TDCol, TDLine ),
	(	(member( [TDLine|TDCol], ML )) %Check if the coordinates we gave are valid.
	->	DCol is TDCol, DLine is TDLine, ! %And if so, continue.
	;	nl, write( 'Invalid coordinates! Please pick valid coordinates to move that piece to:' ),
		read_move_aux2( DLine, DCol, ML )
	).

read_move( Board, Spaces, ResultBoard, Piece ) :-
	%Print the Board.
	printBoard( Board, Spaces ),
	%Print whose turn it is to play.
	write( 'Turn to play: ' ),
	translate( Piece, C ),
	write( C ), nl,
	%Ask for a piece to be moved.
	write( 'Please pick a piece to move.' ), nl,
	read_move_aux1( Board, Line, Col, ML, Piece ),
	printSel( Board, Spaces, Line, Col ),
	%Attempt to make a move.
	write( 'Please pick one of the following possible moves:' ),
	read_move_aux2( DLine, DCol, ML ),
	movePiece( Board, ResultBoard, Line, Col, DLine, DCol ).

%Ask the user to input a number to choose between one of the three game mode options.
get_gamemode( Input ) :-
	nl, nl, write( 'Please pick a game mode by writing one of the numbers equivalent to the given options.' ), nl,
	write( '1. Human vs Human' ), nl,
	write( '2. Human vs Computer' ), nl,
	write( '3. Computer vs Computer' ), nl, nl,
	read( C ),
	(	(C is 1; C is 2; C is 3)
	->	Input is C, !
	;	write( 'Please pick a valid game mode!' ), nl,
		get_gamemode( Input )
	).

%Ask the user to input a number to choose between one of the two computer difficulties.
get_difficulty( Input ) :-
	nl, nl, write( 'Please pick a difficulty by writing one of the numbers equivalent to the given options.' ), nl,
	write( '1. Computer doesn\'t think before playing.' ), nl,
	write( '2. Computer thinks minimally before acting.' ), nl, nl,
	read( C ),
	(	(C is 1; C is 2)
	->	Input is C, !
	;	write( 'Please pick a valid difficulty!' ), nl,
		get_difficulty( Input )
	).

%Allow the Player to change the board at will, as long as valid coordinates are used.
edit_board( Board, Spaces, ResultBoard ) :-
	printBoard( Board, Spaces ),
	write( 'Pick two pieces to swap. If either of the pieces are out of the board (like "0-0." for example) the swapping will end.' ), nl,
	read_coords( X1, Y1 ),
	getPiece( Board, Y1, X1, P1 ),
	(	(P1 < 3) %Check if it is a valid piece.
	->	write( 'Pick the second piece.' ), nl,
		read_coords( X2, Y2 ),
		getPiece( Board, Y2, X2, P2 ),
		(	(P2 < 3) %Check if the second piece is valid as well.
		->	replacePiece( Board, TmpBoard, Y1, X1, P2 ), %Set Location1 to Piece2.
			replacePiece( TmpBoard, RepBoard, Y2, X2, P1 ), %Set Location2 to Piece1.
			edit_board( RepBoard, Spaces, ResultBoard ), ! %Recursive call.
		;	write( 'Invalid piece chosen, starting game with the current Board.' ), nl,
			ResultBoard = Board
		), !
	;	write( 'Invalid piece chosen, starting game with the current Board.' ), nl,
		ResultBoard = Board
	).
