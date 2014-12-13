%'Easy' mode for the computer.
easyLine( _, [], _, _, _, _, _ ). %End of line reached.
easyLine( Board, [_|LT], Line, Col, Piece, RLine, RCol ) :-
	(getPiece( Board, Line, Col, Piece ), %Check if we're checking a piece that is the same as ours.
		listMoves( Board, Line, Col, ML ); %If so, list its moves.
		append( [], [], ML ) ), %Otherwise, ML is empty.
	(append( [], [], ML ), %If ML is empty
		NCol is Col+1, %Move on to the next column
		easyLine( Board, LT, Line, NCol, Piece, RLine, RCol ) %Recursive call.
	%Otherwise, we've found our Line and Column and so we can finally assign them.
	;	(	RLine = Line,
			RCol = Col
		)
	).

easyMoves( _, [], _, _, _, _ ).
easyMoves( Board, [BH|BT], Line, Piece, RLine, RCol ) :-
	easyLine( Board, BH, Line, 1, Piece, RLine, RCol ), !, %Call this function for each line.
	NLine is Line+1, %Move on to the next Line if we don't have a solution yet.
	easyMoves( Board, BT, NLine, Piece, RLine, RCol ). %Recursive call.

easyMoves( Board, Piece, Line, Col ) :-
	easyMoves( Board, Board, 1, Piece, Line, Col ), !.

computer_easy( Board, Spaces, ResultBoard, Piece ) :-
	%Print whose turn it is to play.
	translate( Piece, C ),
	write( 'Turn to play: ' ), write( C ), nl,
	%Get the move to be made.
	easyMoves( Board, Piece, Line, Col ),
	listMoves( Board, Line, Col, [[DLine|DCol]|_] ),
	%Make the move.
	movePiece( Board, ResultBoard, Line, Col, DLine, DCol ),
	%Print the Board and end.
	printBoard( ResultBoard, Spaces ),
	write( 'Press Enter to continue.' ), nl,
	get_char( _ ).

%'Hard' mode for the computer.
hardBoard( _, _, _, [], 0 ). %We don't win if we have no moves.
hardBoard( Board, Line, Col, [[DL|DC]|ML], Win ) :-
	getPiece( Board, DL, DC, EPiece ), %Get the 'enemy' piece.
	movePiece( Board, ResultBoard, Line, Col, DL, DC ), %Simulate moving to the spot of said piece.
	playerMoves( ResultBoard, EPiece, Valid ), %Check if the other Player can still make a move.
	(	(Valid is 0)
	->	Win is 1 %And we win if they can't.
	;	hardBoard( Board, Line, Col, ML, Win ) %Otherwise, we continue on to the next candidate of the list of movements.
	).
	

hardLine( _, [], _, _, _, _, _ ). %End of line reached.
hardLine( Board, [_|LT], Line, Col, Piece, RLine, RCol ) :-
	(getPiece( Board, Line, Col, Piece ), %Check if we're checking a piece that is the same as ours.
		listMoves( Board, Line, Col, ML ); %If so, list its moves.
		append( [], [], ML ) ), %Otherwise, ML is empty.
	NCol is Col+1, %Move on to the next column
	(append( [], [], ML ), %If ML is empty
		hardLine( Board, LT, Line, NCol, Piece, RLine, RCol ) %Recursive call.
	%Otherwise, we've found a possible move.
	;	(	hardBoard( Board, Line, Col, ML, 1 ) %If we do win...
		->	RLine = Line, RCol = Col %Assign the winning move.
		;	hardLine( Board, LT, Line, NCol, Piece, RLine, Col ) %Otherwise, move on to the next iteration.
		)
	).

hardMoves( Board, [], _, Piece, L, C ) :-
	(	(integer(L),integer(C)) %If we got to the end and we DID find a move that lets us win, we use that.
	->	! %So we cut without any further ado.
	;	easyMoves( Board, Piece, L, C ) %Otherwise, we get any other move so we do something on our turn.
	).
hardMoves( _, [], _, _, _, _ ).
hardMoves( Board, [BH|BT], Line, Piece, RLine, RCol ) :-
	hardLine( Board, BH, Line, 1, Piece, RLine, RCol ), %Call this function for each line.
	NLine is Line+1, %Move on to the next Line if we don't have a solution yet.
	hardMoves( Board, BT, NLine, Piece, RLine, RCol ). %Recursive call.

hardMoves( Board, Piece, Line, Col ) :-
	hardMoves( Board, Board, 1, Piece, Line, Col ), !.

computer_hard( Board, Spaces, ResultBoard, Piece ) :-
	%Print whose turn it is to play.
	translate( Piece, C ),
	write( 'Turn to play: ' ), write( C ), nl,
	%Get the move to be made.
	hardMoves( Board, Piece, Line, Col ),
	listMoves( Board, Line, Col, [[DLine|DCol]|_] ),
	%Make the move.
	movePiece( Board, ResultBoard, Line, Col, DLine, DCol ),
	%Print the Board and end.
	printBoard( ResultBoard, Spaces ),
	write( 'Press Enter to continue.' ), nl,
	get_char( _ ).

