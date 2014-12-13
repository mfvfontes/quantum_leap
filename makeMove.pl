%Dir 1 = UpLeft, Dir 2 = UpRight. NewLine = 0 when there's a problem.
canMove( Board, Line, Col, 1, N, NewLine, NewCol ) :-
	getSize( Board, Size ), %Get the Size of the Board.
	LineDelta is Line-Size, % (Line-Size) for positive distance from Line to Middle.
	(LineDelta > 0, %If it's a positive value...
		TmpDelta is N-LineDelta, %We'll remove a certain amount...
		(TmpDelta > 0,	%If that amount is larger than 0.
			NewCol is Col-TmpDelta; %We get the remainder to the position we want to go to.
		NewCol is Col); %Otherwise, we're entirely in the bottom half of the hexagon, and we stay the same.
	NewCol is Col-N), %Otherwise, we're entirely in the upper half of the hexagon, and we only subtract.
	TmpLine is Line-N, %Go up N.
	getPiece( Board, TmpLine, NewCol, Piece ), %See if it's still a valid position.
	(Piece < 3, %If valid (_, X or O)
		NewLine is TmpLine; %Then NewLine = TmpLine.
	NewLine is 0). %Otherwise NewLine is 0.

canMove( Board, Line, Col, 2, N, NewLine, NewCol ) :-
	getSize( Board, Size ), %Get the Size of the Board.
	LineDelta is Line-Size, % (Line-Size) for positive distance from Line to Middle.
	(LineDelta > 0, %If it's a positive value...
		TmpDelta is N-LineDelta, %We'll remove a certain amount...
		(TmpDelta > 0,	%If that amount is larger than 0.
			NewCol is Col+LineDelta; %We get the remainder to the position we want to go to.
		NewCol is Col+N); %Otherwise, we're entirely in the bottom half of the hexagon, and we only add.
	NewCol is Col), %Otherwise, we're entirely in the upper half of the hexagon, and we stay the same.
	TmpLine is Line-N, %Go up N.
	getPiece( Board, TmpLine, NewCol, Piece ), %See if it's still a valid position.
	(Piece < 3, %If valid (_, X or O)
		NewLine is TmpLine; %Then NewLine = TmpLine.
	NewLine is 0). %Otherwise NewLine is 0.
	
%Dir 0 = Left, Dir 3 = Right. NewLine = 0 when there's a problem.
canMove( Board, Line, Col, Dir, N, NewLine, NewCol ) :-
	(Dir is 0 ; Dir is 3), %Ensure Dir is either 0 or 3.
	(Dir is 0, %If Dir=0,
		TmpDir is -1; %We'll move left.
	TmpDir is 1), %Otherwise, we'll move right.
	NewCol is Col+TmpDir*N, %Go N hexagons left or right.
	getPiece( Board, Line, NewCol, Piece ), %See if it's still in a valid position.
	(Piece < 3, %If valid (_, X or O)
		NewLine is Line; %Then NewLine = Line.
	NewLine is 0). %Otherwise NewLine is 0.

%Dir 5 = DownLeft, Dir 4 = DownRight. NewLine = 0 when there's a problem.
canMove( Board, Line, Col, 5, N, NewLine, NewCol ) :-
	getSize( Board, Size ), %Get the Size of the Board.
	LineDelta is Size-Line, % (Size-Line) for positive distance from Line to Middle.
	(LineDelta > 0, %If it's a positive value... (We're in the top half)
		TmpDelta is N-LineDelta, %We'll remove a certain amount...
		(TmpDelta > 0,	%If that amount is larger than 0.
			NewCol is Col-TmpDelta; %We get the remainder to the position we want to go to.
		NewCol is Col); %Otherwise, we're entirely in the upper half of the hexagon, and we stay the same.
	NewCol is Col-N), %Otherwise, we're entirely in the bottom half of the hexagon, and we only subtract.
	TmpLine is Line+N, %Go down N.
	getPiece( Board, TmpLine, NewCol, Piece ), %See if it's still a valid position.
	(Piece < 3, %If valid (_, X or O)
		NewLine is TmpLine; %Then NewLine = TmpLine.
	NewLine is 0). %Otherwise NewLine is 0.

canMove( Board, Line, Col, 4, N, NewLine, NewCol ) :-
	getSize( Board, Size ), %Get the Size of the Board.
	LineDelta is Size-Line, % (Size-Line) for positive distance from Line to Middle.
	(LineDelta > 0, %If it's a positive value... (We're in the top half)
		TmpDelta is N-LineDelta, %We'll remove a certain amount...
		(TmpDelta > 0,	%If that amount is larger than 0.
			NewCol is Col+LineDelta; %We get the remainder to the position we want to go to.
		NewCol is Col+N); %Otherwise, we're entirely in the upper half of the hexagon, and we only add.
	NewCol is Col), %Otherwise, we're entirely in the bottom half of the hexagon, and we stay the same.
	TmpLine is Line+N, %Go down N.
	getPiece( Board, TmpLine, NewCol, Piece ), %See if it's still a valid position.
	(Piece < 3, %If valid (_, X or O)
		NewLine is TmpLine; %Then NewLine = TmpLine.
	NewLine is 0). %Otherwise NewLine is 0.

%Returns a list of all moves a given piece can make.
listMoves( Board, Line, Col, MovesList ) :-
	numNearPiece( Board, Line, Col, N ), %Get the N used in all the above functions.
	%Get all the coordinates.
	canMove( Board, Line, Col, 0, N, L0, C0 ),
%	write( 'L0='+L0+', C0='+C0 ),nl,
	canMove( Board, Line, Col, 1, N, L1, C1 ),
%	write( 'L1='+L1+', C1='+C1 ),nl,
	canMove( Board, Line, Col, 2, N, L2, C2 ),
%	write( 'L2='+L2+', C2='+C2 ),nl,
	canMove( Board, Line, Col, 3, N, L3, C3 ),
%	write( 'L3='+L3+', C3='+C3 ),nl,
	canMove( Board, Line, Col, 4, N, L4, C4 ),
%	write( 'L4='+L4+', C4='+C4 ),nl,
	canMove( Board, Line, Col, 5, N, L5, C5 ),
%	write( 'L5='+L5+', C5='+C5 ),nl,
	%List appendings. We also need to make sure that we're 'jumping' to an 'enemy' piece.
	getPiece( Board, Line, Col, Piece ), %Enemy pieces are calculated by 2-Piece+1 (Piece=1 -> 2, Piece=2 -> 1).
	(L0 > 0, getPiece( Board, L0, C0, P0 ), P0 is 2-Piece+1, append( [], [[L0|C0]], T0 ); append( [], [], T0 ) ), %If Lx isn't 0, append coords to the MovesList. Otherwise, MovesList stays the same.
	(L1 > 0, getPiece( Board, L1, C1, P1 ), P1 is 2-Piece+1, append( T0, [[L1|C1]], T1 ); append( [], T0, T1 ) ),
	(L2 > 0, getPiece( Board, L2, C2, P2 ), P2 is 2-Piece+1, append( T1, [[L2|C2]], T2 ); append( [], T1, T2 ) ),
	(L3 > 0, getPiece( Board, L3, C3, P3 ), P3 is 2-Piece+1, append( T2, [[L3|C3]], T3 ); append( [], T2, T3 ) ),
	(L4 > 0, getPiece( Board, L4, C4, P4 ), P4 is 2-Piece+1, append( T3, [[L4|C4]], T4 ); append( [], T3, T4 ) ),
	(L5 > 0, getPiece( Board, L5, C5, P5 ), P5 is 2-Piece+1, append( T4, [[L5|C5]], MovesList ); append( [], T4, MovesList ) ).

%Checks if a given Player (1 for Crosses, 2 for Circles) has any valid moves left. Valid will either be 1 or 0.
playerMovesLine( _, [], _, _, _, _ ). %End of line reached.
playerMovesLine( Board, [_|LT], Line, Col, Piece, Valid ) :-
	(getPiece( Board, Line, Col, Piece ), %Check if we're checking a piece that is the same as ours.
		listMoves( Board, Line, Col, ML ); %If so, list its moves.
		append( [], [], ML ) ), %Otherwise, ML is empty.
	(append( [], [], ML ), %If ML is empty
		NCol is Col+1, %Move on to the next column
		playerMovesLine( Board, LT, Line, NCol, Piece, Valid ); %Recursive call.
	Valid is 1). %Otherwise, we know that the player has *at least* one more move left.

playerMoves( _, [], _, _, _ ). %If we actually reach the end of the board and didn't get any solution yet, then the player has no more moves left.
playerMoves( Board, [BH|BT], Line, Piece, Valid ) :-
	playerMovesLine( Board, BH, Line, 1, Piece, Valid ), %Call this function for each line.
	NLine is Line+1, %Move on to the next Line if we don't have a solution yet.
	playerMoves( Board, BT, NLine, Piece, Valid ). %Recursive call.

playerMoves( Board, Piece, Valid ) :-
	playerMoves( Board, Board, 1, Piece, Valid ), !, %Attempt to only get the first solution - no need to iterate all the way through until the end.
	(integer( Valid ), !; %If Valid was defined by now (Valid=1 in that case), then we can stop.
	Valid is 0). %Otherwise, we found no moves for this player, so Valid=0 now.
